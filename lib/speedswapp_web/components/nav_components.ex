defmodule SpeedswappWeb.NavComponents do
  @moduledoc false

  use Phoenix.Component

  import SpeedswappWeb.CoreComponents

  @spec bottom_nav(any) :: Phoenix.LiveView.Rendered.t()
  def bottom_nav(assigns) do
    ~H"""
    <div class="fixed bottom-0 z-10 w-full h-16 bg-zinc-900 lg:h-12">
      <div class="grid h-3/4 lg:h-full max-w-lg grid-cols-5 mx-auto">
        <.bottom_nav_button navigate={"/"} icon="hero-home-solid" />
        <.bottom_nav_button navigate={"/"} icon="hero-user-group-solid" />
        <.bottom_nav_special navigate={"/"} icon="hero-plus-solid" />
        <.bottom_nav_button navigate={"/"} icon="hero-magnifying-glass-solid" />
        <.bottom_nav_button navigate={"/users/settings"} icon="hero-user-solid" />
      </div>
    </div>
    """
  end

  @doc """
  Renders a button for use within the bottom navigation
  """
  attr :navigate, :any, required: true
  attr :icon, :any, required: true

  def bottom_nav_button(assigns) do
    ~H"""
    <.link href={@navigate} class="inline-flex flex-col items-center justify-center px-5 hover:bg-zinc-800 group">
      <.icon name={@icon} class="h-5 w-5 text-white" />
    </.link>
    """
  end

  @doc """
  Renders a button for use within the bottom navigation
  """
  attr :navigate, :any, required: true
  attr :icon, :any, required: true

  def bottom_nav_special(assigns) do
    ~H"""
    <.link href={@navigate} class="inline-flex flex-col text-2xl items-center justify-center px-5 hover:bg-blue-900 group bg-blue-700 rounded-full my-1 mx-3">
      <.icon name={@icon} class="h-8 w-8 text-white font-bold" />
    </.link>
    """
  end

  @doc """
  Renders a dropdown button and content
  """
  attr :identifier, :any, required: true
  slot :inner_block, doc: "The content that can go within the dropdown"

  def dropdown(assigns) do
    ~H"""
    <a data-dropdown-toggle={@identifier} type="button" class="text-white">
      <%= render_slot(@inner_block) %>
    </a>
    """
  end


  @doc """
  Renders the content for the dropdown
  """
  attr :identifier, :any, required: true
  slot :inner_block, doc: "Here is where the dropdown items should go"

  def dropdown_content(assigns) do
    ~H"""
    <div id={@identifier} class="z-10 hidden bg-white divide-y divide-gray-300 rounded-lg shadow-md border mx-8">
      <ul class="py-2 text-md">
        <%= render_slot(@inner_block) %>
      </ul>
    </div>
    """
  end

  @doc """
  Renders an item for the dropdown, should be used inside the dropdown_content
  """
  attr :href, :any
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, doc: "Content of the dropdown item"

  def dropdown_item(assigns) do
    ~H"""
    <li>
      <.link href={@href} class="block px-8 py-2 hover:bg-gray-100 active:bg-gray-300" {@rest}>
        <%= render_slot(@inner_block) %>
      </.link>
    </li>
    """
  end
end
