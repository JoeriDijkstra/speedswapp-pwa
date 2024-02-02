defmodule SpeedswappWeb.NewPostLive do
  alias Speedswapp.Uploader
  use SpeedswappWeb, :live_view

  alias Speedswapp.Posts.Post
  alias Speedswapp.Posts
  alias Speedswapp.Groups

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    Loading...
    """
  end

  def render(assigns) do
    ~H"""
    <.container>
      <h5 class="text-xl font-semibold tracking-tight text-gray-100">Create a new post</h5>
      <p class="text-zinc-400 text-sm mb-0">
        Hi <%= assigns.current_user.handle %> &#128075;, here you can manage your account information
      </p>
      <.simple_form for={@form} phx-change="validate" phx-submit="save-post">
        <.input field={@form[:caption]} label="Caption" required />
        <.input field={@form[:description]} type="textarea" label="Description" required />
        <.input
          field={@form[:group_id]}
          type="select"
          label="Group"
          options={Groups.list_for_select(assigns.current_user)}
          required
        />

        <%= for entry <- @uploads.image.entries do %>
          <.live_img_preview entry={entry} class="rounded-lg w-full" />
        <% end %>

        <.file_input input={@uploads.image} />

        <:actions>
          <.button type="submit" phx-disable-with="Saving...">Create Post</.button>
        </:actions>
      </.simple_form>
    </.container>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      form =
        %Post{}
        |> Post.changeset(%{})
        |> to_form(as: "post")

      socket =
        socket
        |> assign(form: form, loading: false)
        |> allow_upload(:image,
          accept: ~w(.jpg .jpeg .png),
          max_entries: 1
        )

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("validate", %{"post" => post}, socket) do
    form =
      %Post{}
      |> Post.changeset(post)
      |> to_form(as: "post")

    IO.inspect(socket.assigns.uploads, label: "uploads")

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save-post", %{"post" => post_params}, socket) do
    %{current_user: user} = socket.assigns

    post_params
    |> Map.put("user_id", user.id)
    |> Map.put("image_path", List.first(consume_files(socket)))
    |> Posts.save()
    |> case do
      {:ok, post} ->
        socket =
          socket
          |> put_flash(:info, "Post created succesfully")
          |> push_navigate(to: ~p"/")

        Phoenix.PubSub.broadcast(
          Speedswapp.PubSub,
          "posts",
          {:new,
           post
           |> Map.put(:user, user)
           |> Speedswapp.Repo.preload(:group)}
        )

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, %{uuid: uuid} ->
      Uploader.do_upload(path, "posts/post-#{uuid}.jpg")
    end)
  end
end
