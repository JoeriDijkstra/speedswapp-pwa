defmodule SpeedswappWeb.CustomComponents do
  @moduledoc false

  use Phoenix.Component

  slot :inner_block, required: true

  def container(assigns) do
    ~H"""
    <div class="mx-auto max-w-full px-4 py-4 bg-zinc-800 rounded-lg mb-32 mt-8">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot :inner_block, required: true

  def group_container(assigns) do
    ~H"""
    <div class="mx-auto max-w-full px-4 py-4 bg-zinc-800 rounded-lg mt-8">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def adsense(assigns) do
    ~H"""
    <ins
      class="adsbygoogle"
      style="display:block; text-align:center;"
      data-ad-layout="in-article"
      data-ad-format="fluid"
      data-ad-client="ca-pub-7783256035891270"
      data-ad-slot="6331846695"
    >
    </ins>
    """
  end

  slot :inner_block, required: true

  def container_header(assigns) do
    ~H"""
    <h5 class="text-xl font-semibold tracking-tight text-gray-100">
      <%= render_slot(@inner_block) %>
    </h5>
    """
  end

  attr :input, :map, required: true

  def file_input(assigns) do
    ~H"""
    <div class="flex items-center justify-center w-full phx-drop-target={@input.ref}">
      <label
        for={@input.ref}
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
            SVG, PNG, JPG or GIF (MAX. 800x400px)
          </p>
        </div>
        <.live_file_input id="dropzone-file" upload={@input} class="hidden" />
      </label>
    </div>
    """
  end

  attr :posts, :list, required: true

  def feed(assigns) do
    ~H"""
    <div class="mb-20 max-w-full">
      <div id="load-more" phx-update="stream" phx-viewport-bottom="load-more">
        <div
          :for={{dom_id, post} <- @posts}
          id={dom_id}
          class="width-100 bg-zinc-800 text-black m-h-64 border-b-1 border-zinc-800 mb-5 mt-5 p-4 rounded-lg"
        >
          <div class="flex items-center gap-4 mb-2">
            <img class="w-10 h-10 rounded-lg object-cover" src={post.user.avatar_path} />
            <div class="font-medium text-white">
              <div><%= post.user.handle || "Unhandled" %></div>
              <div class="text-sm text-zinc-300 dark:text-gray-400">
                Posted in
                <.link href={"/group/" <> to_string(post.group.id)}>
                  <span class="text-blue-400 font-bold"><%= post.group.name %></span>
                </.link>
              </div>
            </div>
          </div>
          <%= if post.image_path do %>
            <img class="rounded-lg w-full" src={post.image_path} />
          <% end %>
          <h5 class="text-xl font-semibold tracking-tight text-gray-100 pt-4">
            <%= post.caption %>
          </h5>
          <p class="text-slate-200 text-sm">
            <%= post.description %>
          </p>
          <div class="bg-zinc-700"></div>
        </div>
      </div>
    </div>
    """
  end

  def subscribe_button(assigns) do
    ~H"""
    <span class="text-blue-400 font-bold text-s">Unsubscribe</span>
    """
  end
end
