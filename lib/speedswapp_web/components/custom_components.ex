defmodule SpeedswappWeb.CustomComponents do
  @moduledoc false

  use Phoenix.Component

  import SpeedswappWeb.CoreComponents

  attr :title, :any, required: true
  slot :inner_block, doc: "Content of the feed item"

  def feed_item(assigns) do
    ~H"""
    <article class="max-w-sm bg-white rounded-lg overflow-hidden my-4">
      <div class="px-6 py-4">
        <h2 class="font-bold text-xl mb-2"><%= @title %></h2>
        <div class="text-gray-700 text-base">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </article>
    """
  end

  def feed(assigns) do
    titles = [
      "Numbero 1",
      "Numbero zwei",
      "Really cool car",
      "something something",
      "New review, look at this cool thing!",
      "Something with an image",
      "Numbero 1",
      "Numbero zwei",
      "Really cool car",
      "something something",
      "New review, look at this cool thing!",
      "Something with an image",
      "Final image"
    ]

    ~H"""
    <%= for title <- titles do %>
      <.feed_item title={title}>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dapibus vestibulum velit sed gravida. Proin eu libero nisl. Aliquam erat volutpat. Praesent hendrerit ultrices dignissim.
      </.feed_item>
    <% end %>
    """
  end
end
