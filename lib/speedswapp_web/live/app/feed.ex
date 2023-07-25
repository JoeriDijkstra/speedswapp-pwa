defmodule SpeedswappWeb.FeedLive do
  use SpeedswappWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="max-w-sm mb-20">
      <.feed />
    </div>
    """
  end
end
