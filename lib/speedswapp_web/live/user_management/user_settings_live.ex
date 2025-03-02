defmodule SpeedswappWeb.UserSettingsLive do
  alias Speedswapp.Uploader
  use SpeedswappWeb, :live_view

  alias Speedswapp.Accounts

  def render(%{loading: true} = assigns) do
    ~H"""
    Loading Speedswapp...
    """
  end

  def render(%{loading: false} = assigns) do
    ~H"""
    <div class="mb-20 max-w-full">
      <div class="width-100 bg-zinc-800 text-black m-h-64 border-b-1 border-zinc-800 mb-5 mt-5 p-4 rounded-lg">
        <h5 class="text-xl font-semibold tracking-tight text-gray-100">Account settings</h5>
        <p class="text-zinc-400 text-sm">
          Hi <%= assigns.current_user.handle || "there" %> &#128075;, here you can manage your account information
          <div class="text-white font-bold mt-8 mb-8">
            <button
              type="button"
              class="w-full px-4 py-4 font-medium rounded-t-lg bg-zinc-700"
              phx-click={show_modal("change-email-modal")}
            >
              Change email
            </button>
            <button
              type="button"
              class="w-full px-4 py-4 font-medium bg-zinc-700"
              phx-click={show_modal("change-password-modal")}
            >
              Change password
            </button>
            <button
              type="button"
              class="w-full px-4 py-4 font-medium bg-zinc-700"
              phx-click={show_modal("change-avatar-modal")}
            >
              Update avatar
            </button>
            <button type="button" class="w-full px-4 py-4 font-medium rounded-b-lg bg-red-800">
              <.link href="/users/log_out" method="DELETE">Logout</.link>
            </button>
          </div>
        </p>
      </div>
    </div>

    <.modal id="change-avatar-modal">
      <h2 class="text-xl font-bold text-zinc-100">Update avatar</h2>
      <.simple_form
        for={@avatar_form}
        id="avatar_form"
        phx-submit="update_avatar"
        phx-change="validate_avatar"
      >
        <%= for entry <- @uploads.avatar.entries do %>
          <.live_img_preview entry={entry} class="rounded-lg w-full" />
        <% end %>

        <.file_input input={@uploads.avatar} />

        <:actions>
          <.button phx-disable-with="Changing...">Change Avatar</.button>
        </:actions>
      </.simple_form>
    </.modal>

    <.modal id="change-email-modal">
      <h2 class="text-xl font-bold text-zinc-100">Update email</h2>
      <.simple_form
        for={@email_form}
        id="email_form"
        phx-submit="update_email"
        phx-change="validate_email"
      >
        <.input field={@email_form[:email]} type="email" label="Email" required />
        <.input
          field={@email_form[:current_password]}
          name="current_password"
          id="current_password_for_email"
          type="password"
          label="Current password"
          value={@email_form_current_password}
          required
        />
        <:actions>
          <.button phx-disable-with="Changing...">Change Email</.button>
        </:actions>
      </.simple_form>
    </.modal>

    <.modal id="change-password-modal">
      <h2 class="text-xl font-bold text-zinc-100">Update password</h2>
      <.simple_form
        for={@password_form}
        id="password_form"
        action={~p"/users/log_in?_action=password_updated"}
        method="post"
        phx-change="validate_password"
        phx-submit="update_password"
        phx-trigger-action={@trigger_submit}
      >
        <.input
          field={@password_form[:email]}
          type="hidden"
          id="hidden_user_email"
          value={@current_email}
        />
        <.input field={@password_form[:password]} type="password" label="New password" required />
        <.input
          field={@password_form[:password_confirmation]}
          type="password"
          label="Confirm new password"
        />
        <.input
          field={@password_form[:current_password]}
          name="current_password"
          type="password"
          label="Current password"
          id="current_password_for_password"
          value={@current_password}
          required
        />
        <:actions>
          <.button phx-disable-with="Changing...">Change Password</.button>
        </:actions>
      </.simple_form>
    </.modal>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      user = socket.assigns.current_user
      email_changeset = Accounts.change_user_email(user)
      password_changeset = Accounts.change_user_password(user)
      avatar_changeset = Accounts.change_user_avatar(user)

      socket =
        socket
        |> assign(:current_password, nil)
        |> assign(:email_form_current_password, nil)
        |> assign(:current_email, user.email)
        |> assign(:email_form, to_form(email_changeset))
        |> assign(:password_form, to_form(password_changeset))
        |> assign(:avatar_form, to_form(avatar_changeset))
        |> assign(:trigger_submit, false)
        |> assign(:loading, false)
        |> allow_upload(:avatar,
          accept: ~w(.jpg .jpeg .png),
          max_entries: 1
        )

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  def handle_event("update_avatar", _, socket) do
    %{current_user: user} = socket.assigns

    case Accounts.update_user_avatar(user, %{"avatar_path" => List.first(consume_files(socket))}) do
      {:ok, _user} ->
        socket =
          socket
          |> put_flash(:info, "Succesfully updated avatar")
          |> push_navigate(to: ~p"/")

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Something went wrong updating your avatar")}
    end
  end

  def handle_event("validate_avatar", _, socket) do
    {:noreply, socket}
  end

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :avatar, fn %{path: path}, %{uuid: uuid} ->
      Uploader.do_upload(path, "avatars/avatar-#{uuid}.jpg", &Uploader.to_thumbnail/1)
    end)
  end
end
