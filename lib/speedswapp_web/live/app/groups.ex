defmodule SpeedswappWeb.GroupsLive do
  use SpeedswappWeb, :live_view

  alias Speedswapp.Groups.Group
  alias Speedswapp.Groups

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    <h1 class="text-2xl">Loading Speedswapp</h1>
    """
  end

  def render(assigns) do
    ~H"""
    <.modal id="create-group-modal">
      <h2 class="text-xl font-bold text-zinc-100">Create a group</h2>
      <.simple_form for={@form} phx-submit="create_group" phx-change="validate_group">
        <.input field={@form[:name]} label="Name" required />
        <.input field={@form[:description]} label="Description" type="textarea" required />
        <p class="text-zinc-400 text-sm mb-0 mt-0">
          If you make your group public, everyone can post in your group. Otherwise only
          promoted users can post in your group.
        </p>
        <.input field={@form[:public]} label="Public" type="checkbox" />

        <%= for entry <- @uploads.image.entries do %>
          <.live_img_preview entry={entry} class="rounded-lg w-full" />
        <% end %>
        <div class="flex items-center justify-center w-full phx-drop-target={@uploads.image.ref}">
          <label
            for={@uploads.image.ref}
            class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-500 border-dashed rounded-lg cursor-pointer bg-zinc-700"
          >
            <div class="flex flex-col items-center justify-center pt-5 pb-6">
              <svg
                class="w-8 h-8 mb-4 text-gray-300"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 20 16"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"
                />
              </svg>
              <p class="mb-2 text-sm text-gray-300">
                <span class="font-semibold">Click to upload</span>
              </p>
              <p class="text-xs text-gray-300">
                PNG, JPG
              </p>
            </div>
            <.live_file_input id="dropzone-file" upload={@uploads.image} class="hidden" />
          </label>
        </div>
        <:actions>
          <.button phx-disable-with="Creating...">Create group</.button>
        </:actions>
      </.simple_form>
    </.modal>

    <.container>
      <h5 class="text-xl font-semibold tracking-tight text-gray-100">Your groups</h5>
      <p class="text-zinc-400 text-sm mb-4">Manage your groups, you can find new groups here</p>
      <.button phx-click={show_modal("create-group-modal")}>Create a new group</.button>
      <div class="mt-8 mb-8 rounded-lg">
        <div :for={{dom_id, group} <- @streams.groups} id={dom_id}>
          <button
            type="button"
            class="inline-flex items-center w-full px-4 py-4 font-bold text-zinc-100 bg-zinc-700"
          >
            <img
              class="w-10 h-10 rounded-full mr-4"
              src={group.image_path || "https://cdn-icons-png.flaticon.com/512/3626/3626507.png"}
            />
            <%= group.name %>
          </button>
        </div>
      </div>
    </.container>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if(connected?(socket)) do
      form =
        %Group{}
        |> Group.changeset(%{})
        |> to_form(as: "group")

      socket =
        socket
        |> assign(form: form, loading: false)
        |> allow_upload(:image, accept: ~w(.jpg .jpeg .png), max_entries: 1)
        |> stream(:groups, Groups.list(socket.assigns.current_user))

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("validate_group", %{"group" => group}, socket) do
    form =
      %Group{}
      |> Group.changeset(group)
      |> to_form(as: "group")

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("create_group", %{"group" => group_params}, socket) do
    group_params
    |> Map.put("image_path", List.first(consume_files(socket)))
    |> Groups.save()
    |> case do
      {:ok, _post} ->
        socket =
          socket
          |> put_flash(:info, "Group created succesfully")
          |> push_navigate(to: ~p"/groups")

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:speedswapp), "static", "uploads", Path.basename(path)])
      File.cp!(path, dest)

      {:postpone, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end
end
