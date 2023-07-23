defmodule SpeedswappWeb.FeedLive do
  use SpeedswappWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Feed
        <:subtitle>
          This is your feed!
        </:subtitle>
      </.header>
      </div>
    """
  end
end
