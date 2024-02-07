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
        <%= if(@subscribed?) do %>
          <a class="text-blue-400 font-bold text-s" phx-click="unsubscribe" phx-value-group={@group.id}>Unsubscribe</a>
        <% else %>
          <.button phx-click="subscribe" class="w-32" phx-value-group={@group.id}>Subscribe</.button>
        <% end %>
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

  def handle_event("unsubscribe", %{"group" => group_id}, %{assigns: %{current_user: current_user}} = socket) do
    {parsed_group_id, _} = Integer.parse(group_id)
    case Groups.unsubscribe(parsed_group_id, current_user) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Succesfully unsubscribed")
          |> push_navigate(to: ~p"/group/#{group_id}")

        {:noreply, socket}

      {:error, :not_found_error} ->
        {:noreply, put_flash(socket, :error, "You are not subscribed to the group")}
    end
  end

  def handle_event("subscribe", %{"group" => group_id}, %{assigns: %{current_user: current_user}} = socket) do
    {parsed_group_id, _} = Integer.parse(group_id)
    case Groups.subscribe(parsed_group_id, current_user) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Succesfully subscribed")
          |> push_navigate(to: ~p"/group/#{group_id}")

        {:noreply, socket}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Something went wrong")}
    end
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
      |> assign(loading: false, group: group, subscribed?: Groups.is_subscribed?(group.id, socket.assigns.current_user))
      |> stream(:posts, Posts.list_for_group(group))

    {:ok, socket}
  end
end
