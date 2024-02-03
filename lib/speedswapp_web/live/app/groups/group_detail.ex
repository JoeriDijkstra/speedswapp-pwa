defmodule SpeedswappWeb.GroupDetailLive do
  use SpeedswappWeb, :live_view

  alias Speedswapp.Groups.Group
  alias Speedswapp.Groups
  alias Speedswapp.Posts

  def render(%{loading: true} = assigns) do
    ~H"""
    Loading...
    """
  end

  def render(assigns) do
    ~H"""
    <.group_container>
      <div class="flex items-center">
        <.back navigate={~p"/groups"}>Groups</.back>
        <div class="grow" />
        <.subscribe_button/>
      </div>
      <div class="flex items-center gap-4 mb-2 mt-4">
        <img class="w-12 h-12 rounded-lg object-cover" src={@group.image_path} />
        <div class="text-white">
          <h5 class="text-2xl font-semibold tracking-tight text-gray-100"><%= @group.name %></h5>
          <div class="text-lg text-zinc-300 dark:text-gray-400">
            <%= @group.description %>
          </div>
        </div>
      </div>
    </.group_container>
    <.feed posts={@streams.posts}/>
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
      |> stream(:posts, Posts.list_for_group(group))

    {:ok, socket}
  end
end
