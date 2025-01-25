defmodule SpeedswappWeb.CustomComponents do
  @moduledoc false

  use Phoenix.Component

  import SpeedswappWeb.CoreComponents

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
  attr :current_user, :map, required: true
  attr :comments, :list, required: false
  attr :selected_post, :map, required: false
  attr :form, :any, required: true

  def feed(assigns) do
    ~H"""
    <%= if(assigns.selected_post != nil) do %>
      <div class="w-full h-4/5 bottom-0 left-0 right-0 fixed p-6 text-white bg-zinc-900 flex flex-col z-50 rounded-lg">
        <!-- Header Section -->
        <div class="flex items-center h-8">
          <div class="flex-initial">
            <span phx-click="close-comments" class="hero-x-mark text-gray-100 h-6 w-6" />
          </div>
          <div class="flex-auto">
            <h2 class="ml-4 text-lg font-bold text-zinc-100"><%= assigns.selected_post.caption %></h2>
          </div>
        </div>
        <!-- Comments Section -->
        <div class="flex-1 overflow-y-auto mt-4 mb-12">
          <div
            :for={{dom_id, comment} <- @comments}
            id={dom_id}
            class="inline-flex items-center w-full px-4 py-4 font-bold text-zinc-100 bg-zinc-700 rounded-lg mb-2"
          >
            <div class="text-sm text-zinc-300 dark:text-gray-400">
              <div>
                <.link href={"/profile/" <> to_string(comment.user.handle)}>
                  <span class="text-blue-400 font-bold"><%= comment.user.handle %> </span>
                </.link>
                <span class="text-grey-100">
                  <%= comment.body %>
                </span>
              </div>
            </div>
          </div>
        </div>

        <div class="w-full flex items-center rounded-lg h-20 px-4 py-4 absolute bottom-0 left-0 flex items-center">
            <.form
                for={@form}
                phx-submit="submit-comment"
                phx-change="validate-comment"
                class="relative w-full"
            >
                <div class="relative w-full mb-4">
                    <.input field={@form[:body]} required />

                    <!-- Submit Button -->
                    <button
                        type="submit"
                        class="absolute right-0 text-blue-400 text-sm mr-3 mt-3 font-bold top-0"
                    >
                      Comment
                    </button>
                </div>
            </.form>
        </div>
      </div>
    <% end %>

    <div class="mb-24 max-w-full">
      <div class="mb-10" id="load-more" phx-update="stream" phx-viewport-bottom="load-more">
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
          <div class="flex items-center mt-4">
            <span phx-click="toggle-like" phx-value-id={post.id}>
              <%= if Enum.find(post.likes, & &1.id == @current_user.id) do %>
                <span class="hero-fire-solid text-orange-500 h-6 w-6 transition duration-500 ease-in-out hover:scale-110" />
              <% else %>
                <span class="hero-fire text-gray-100 h-6 w-6 transition duration-500 ease-in-out hover:scale-110 z-50" />
              <% end %>
            </span>
            <span class="ml-2 text-gray-100"><%= Enum.count(post.likes) %></span>
            <span
              phx-click="open-comments"
              phx-value-id={post.id}
              class="ml-4 hero-chat-bubble-left text-gray-100 h-6 w-6"
            />
            <span class="ml-2 text-gray-100"><%= Enum.count(post.comments) %></span>
          </div>
          <h5 class="text-lg font-semibold tracking-tight text-gray-100 pt-4">
            <%= post.caption %>
          </h5>
          <p class="text-slate-200 text-sm">
            <%= post.description %>
          </p>
        </div>
      </div>
      <div class=" text-gray-300 pt-4 text-center mb-20">
        <p>End of the road</p>
        <div class="animate-pulse text-blue-400 font-bold">
          <.link href="/search">Explore</.link>
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
