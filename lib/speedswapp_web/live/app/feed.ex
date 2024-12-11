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
    <.feed posts={@streams.posts} current_user={assigns.current_user} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      socket =
        socket
        |> assign(loading: false)
        |> assign(page: 1)
        |> stream(:posts, Posts.list(socket, 1))

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("load-more", _, %{assigns: %{page: page}} = socket) do
    if connected?(socket) do
      socket =
        socket
        |> assign(page: page + 1)
        |> stream_insert_many(:posts, Posts.list(socket, page + 1))

      {:noreply, socket}
    end
  end

  def handle_event("toggle-like", %{"id" => post_id}, %{assigns: %{current_user: user}} = socket) do
    if connected?(socket) do
      case Posts.like(post_id, user) do
        {:ok, post} ->
          {:noreply, stream_insert(socket, :posts, post, at: -1)}

        _ ->
          {:noreply, put_flash(socket, :error, "Liking post failed")}
      end
    end
  end

  defp stream_insert_many(socket, key, array) do
    Enum.reduce(array, socket, fn a, socket ->
      stream_insert(socket, key, a)
    end)
  end
end
