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
    <.feed posts={@streams.posts} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      socket =
        socket
        |> assign(loading: false)
        |> stream(:posts, Posts.list(socket))

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end
end
