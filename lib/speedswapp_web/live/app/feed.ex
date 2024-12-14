defmodule SpeedswappWeb.FeedLive do
  use SpeedswappWeb, :live_view

  alias Speedswapp.Posts
  alias Speedswapp.Posts.Comment
  alias Speedswapp.Repo

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    <h1 class="text-2xl">Loading Speedswapp</h1>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.feed
      posts={@streams.posts}
      current_user={assigns.current_user}
      comments={@streams.comments}
      selected_post={assigns.selected_post}
      form={assigns.form}
    />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      form =
        %Comment{}
        |> Comment.changeset(%{})
        |> to_form(as: "comment")

      socket =
        socket
        |> assign(loading: false, selected_post: nil)
        |> assign(page: 1)
        |> assign(form: form)
        |> stream(:posts, Posts.list(socket, 1))
        |> stream(:comments, [])

      {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("load-more", _, %{assigns: %{page: page}} = socket) do
    if connected?(socket) do
      socket =
        socket
        |> assign(page: page + 1)
        |> stream_insert_many(:posts, Posts.list(socket, page + 1))

      {:noreply, socket}
    end
  end

  def handle_event("toggle-like", %{"id" => post_id}, %{assigns: %{current_user: user}} = socket) do
    if connected?(socket) do
      case Posts.like(post_id, user) do
        {:ok, post} ->
          {:noreply, stream_insert(socket, :posts, post, at: -1)}

        _ ->
          {:noreply, put_flash(socket, :error, "Liking post failed")}
      end
    end
  end

  def handle_event("open-comments", %{"id" => post_id}, socket) do
    selected_post =
      case Posts.fetch_post(post_id) do
        {:ok, post} -> post
        _ -> nil
      end

    socket =
      socket
      |> stream(:comments, Posts.fetch_comments(post_id))
      |> assign(selected_post: selected_post)

    {:noreply, socket}
  end

  def handle_event("close-comments", _, socket) do
    socket =
      socket
      |> assign(selected_post: nil)

    {:noreply, socket}
  end

  def handle_event("validate-comment", _, socket), do: {:noreply, socket}

  def handle_event("submit-comment", %{"comment" => %{"body" => comment_body}}, %{assigns: %{current_user: user, selected_post: selected_post}} = socket) do
    case Repo.insert(Comment.changeset(%{body: comment_body, user_id: user.id, post_id: selected_post.id})) do
      {:ok, _comment} ->
        socket =
            socket
            |> stream(:comments, Posts.fetch_comments(selected_post.id))
            |> put_flash(:info, "You commented succesfully")

        {:noreply, socket}

      _res ->
        {:noreply, put_flash(socket, :error, "Something went wrong while processing your comment")}
    end
  end

  defp stream_insert_many(socket, key, array) do
    Enum.reduce(array, socket, fn a, socket ->
      stream_insert(socket, key, a)
    end)
  end
end
