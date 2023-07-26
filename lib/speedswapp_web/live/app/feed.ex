defmodule SpeedswappWeb.FeedLive do
  use SpeedswappWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mb-20 max-w-full">
      <.feed />
    </div>
    """
  end
end
