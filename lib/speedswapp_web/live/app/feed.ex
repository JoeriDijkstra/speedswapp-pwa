defmodule SpeedswappWeb.FeedLive do
  use SpeedswappWeb, :live_view

  alias Speedswapp.Posts

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    <h1 class="text-2xl">Loading Speedswapp</h1>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mb-20 max-w-full">
      <div
        :for={{dom_id, post} <- @streams.posts}
        id={dom_id}
        class="width-100 bg-zinc-800 text-black m-h-64 border-b-1 border-zinc-800 mb-5 mt-5 p-4 rounded-lg"
      >
        <div class="flex items-center gap-4 mb-2">
          <img
            class="w-10 h-10 rounded-full"
            src={post.user.avatar_path || "https://cdn-icons-png.flaticon.com/512/3626/3626507.png"}
          />
          <div class="font-medium text-white">
            <div><%= post.user.handle || "Unhandled" %></div>
            <div class="text-sm text-zinc-300 dark:text-gray-400">
              Posted in <%= post.group.name %>
            </div>
          </div>
        </div>
        <img class="rounded-lg w-full" src={post.image_path} />
        <h5 class="text-xl font-semibold tracking-tight text-gray-100 pt-4">
          <%= post.caption %>
        </h5>
        <p class="text-slate-200 text-sm">
          <%= post.description %>
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Speedswapp.PubSub, "posts")

      socket =
        socket
        |> assign(loading: false)
        |> stream(:posts, Posts.list(socket))

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_info({:new, post}, socket) do
    socket =
      socket
      |> put_flash(:info, "#{post.user.email} just posted!")
      |> stream_insert(:posts, post)

    {:noreply, socket}
  end
end
