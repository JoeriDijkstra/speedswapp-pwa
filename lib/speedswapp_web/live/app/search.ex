defmodule SpeedswappWeb.SearchLive do
  use SpeedswappWeb, :live_view

  alias Speedswapp.Groups

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    <h1 class="text-gray-300 text-center animate-pulse text-2xl">Loading Speedswapp</h1>
    """
  end

  def render(assigns) do
    ~H"""
    <.group_container>
      <.container_header>Explore</.container_header>
      <form phx-change="search" phx-submit="search">
        <.input
          type="text"
          name="search"
          placeholder="Search for anything"
          value=""
          phx-debounce="200"
        />
      </form>
      <%= if Enum.count(@streams.groups) > 0 do %>
        <div class="mt-4">
          <h4 class="mb-2 text-zinc-300">Groups</h4>
          <div :for={{dom_id, group} <- @streams.groups} id={dom_id}>
            <div class="inline-flex items-center w-full px-4 py-4 font-bold text-zinc-100 bg-zinc-700 rounded-lg mb-2">
              <img class="w-10 h-10 rounded-lg mr-4 object-cover" src={group.image_path} />
              <.link type="button" href={"group/" <> to_string(group.id)} class="grow h-full">
                <span><%= group.name %></span>
              </.link>
            </div>
          </div>
        </div>
      <% end %>
    </.group_container>
    <%= if Enum.count(@streams.groups) == 0 do %>
      <.group_container>
        <.container_header>Recommended</.container_header>
        <div :for={{dom_id, group} <- @streams.recommended} id={dom_id}>
          <div class="inline-flex items-center w-full px-4 py-4 font-bold text-zinc-100 bg-zinc-700 rounded-lg mb-2">
            <img class="w-10 h-10 rounded-lg mr-4 object-cover" src={group.image_path} />
            <.link type="button" href={"group/" <> to_string(group.id)} class="grow h-full">
              <span><%= group.name %></span>
            </.link>
          </div>
        </div>
      </.group_container>
      <.group_container>
        <.container_header>Events</.container_header>
      </.group_container>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      socket =
        socket
        |> assign(loading: false)
        |> stream(:groups, [])
        |> stream(:recommended, Groups.recommended())

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    socket =
      socket
      |> assign(loading: false)
      |> stream(:groups, Groups.search(search))

    {:noreply, socket}
  end
end
