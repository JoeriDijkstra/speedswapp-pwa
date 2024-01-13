defmodule SpeedswappWeb.NewPostLive do
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

        <div class="flex items-center justify-center w-full phx-drop-target={@uploads.image.ref}">
          <label
            for={@uploads.image.ref}
            class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-500 border-dashed rounded-lg cursor-pointer bg-zinc-700"
          >
            <div class="flex flex-col items-center justify-center pt-5 pb-6">
              <svg
                class="w-8 h-8 mb-4 text-gray-300"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 20 16"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"
                />
              </svg>
              <p class="mb-2 text-sm text-gray-300">
                <span class="font-semibold">Click to upload</span>
              </p>
              <p class="text-xs text-gray-300">
                SVG, PNG, JPG or GIF (MAX. 800x400px)
              </p>
            </div>
            <.live_file_input id="dropzone-file" upload={@uploads.image} class="hidden" />
          </label>
        </div>

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
        |> allow_upload(:image, accept: ~w(.jpg .jpeg .png), max_entries: 1)

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
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:speedswapp), "static", "uploads", Path.basename(path)])
      File.cp!(path, dest)

      {:postpone, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end
end
