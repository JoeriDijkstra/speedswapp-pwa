defmodule SpeedswappWeb.SearchGroupsLive do
  use SpeedswappWeb, :live_view

  alias Speedswapp.Groups

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    <h1 class="text-2xl">Loading Speedswapp</h1>
    """
  end

  def render(assigns) do
    ~H"""
    <.group_container>
      <.back navigate={~p"/search"}>Search</.back>
      <form phx-change="search" phx-submit="search">
        <.input type="text" name="search" value="" phx-debounce="2000" />
      </form>
      <div class="mt-8 mb-8 rounded-lg">
        <div :for={{dom_id, group} <- @streams.groups} id={dom_id}>
          <div class="inline-flex items-center w-full px-4 py-4 font-bold text-zinc-100 bg-zinc-700 rounded-lg mb-2">
            <img class="w-10 h-10 rounded-lg mr-4 object-cover" src={group.image_path} />
            <.link type="button" href={"/group/" <> to_string(group.id)} class="grow h-full">
              <span><%= group.name %></span>
            </.link>
          </div>
        </div>
      </div>
    </.group_container>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      socket =
        socket
        |> assign(loading: false)
        |> stream(:groups, Groups.list_all())

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    socket =
      if connected?(socket) do
        socket
        |> assign(loading: false)
        |> stream(:groups, Groups.search(search))
      end

    {:noreply, socket}
  end
end
