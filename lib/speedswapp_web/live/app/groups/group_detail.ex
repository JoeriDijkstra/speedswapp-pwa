defmodule SpeedswappWeb.GroupDetailLive do
  alias Speedswapp.Groups.Group
  alias Speedswapp.Groups
  use SpeedswappWeb, :live_view

  def render(%{loading: true} = assigns) do
    ~H"""
    Loading...
    """
  end

  def render(assigns) do
    ~H"""
    <.container>
      <h5 class="text-xl font-semibold tracking-tight text-gray-100">Your group</h5>
    </.container>
    """
  end

  def mount(%{"group_id" => group_id}, _, socket) do
    if connected?(socket) do
      case Groups.get(group_id) do
        %Group{} = group ->
          do_mount(socket, group)

        nil ->
          socket =
            socket
            |> put_flash(:info, "Group not found")
            |> push_navigate(to: ~p"/groups")

          {:ok, socket}
      end
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  defp do_mount(socket, group) do
    socket =
      socket
      |> assign(loading: false, group: group)

    {:ok, socket}
  end
end
