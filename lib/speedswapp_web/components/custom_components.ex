defmodule SpeedswappWeb.CustomComponents do
  @moduledoc false

  use Phoenix.Component

  slot :inner_block, required: true

  def container(assigns) do
    ~H"""
    <div class="mx-auto max-w-full px-4 py-4 bg-zinc-800 rounded-lg mt-8 mb-32">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
