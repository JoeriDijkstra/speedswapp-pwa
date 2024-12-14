defmodule Speedswapp.Posts do
  @moduledoc false

  import Ecto.Query

  alias Speedswapp.Repo
  alias Speedswapp.Posts.Post
  alias Speedswapp.Posts.UserPostLikes
  alias Speedswapp.Posts.Comment

  def list(%{assigns: %{current_user: user}}, page \\ 1, per_page \\ 10) do
    offset = (page - 1) * per_page

    user_memberships =
      user
      |> Repo.preload(:group_memberships)
      |> Map.get(:group_memberships, [])
      |> Enum.map(& &1.group_id)

    query =
      from p in Post,
        select: p,
        where: p.group_id in ^user_memberships,
        order_by: [desc: :inserted_at],
        preload: [:user, :group, :likes],
        limit: ^per_page,
        offset: ^offset

    Repo.all(query)
  end

  def list_for_group(%{id: group_id}, page \\ 1, per_page \\ 5) do
    offset = (page - 1) * per_page

    query =
      from p in Post,
        select: p,
        order_by: [desc: :inserted_at],
        preload: [:user, :group, :likes],
        where: p.group_id == ^group_id,
        limit: ^per_page,
        offset: ^offset

    Repo.all(query)
  end

  def like(post_id, user) do
    like = Repo.get_by(UserPostLikes, user_id: user.id, post_id: post_id)

    case toggle_like(like, post_id, user) do
      {:ok, _} ->
        fetch_post(post_id)

      error ->
        error
    end
  end

  defp toggle_like(like, post_id, user) do
    if like do
      Repo.delete(like)
    else
      %{post_id: post_id, user_id: user.id}
      |> UserPostLikes.changeset()
      |> Repo.insert()
    end
  end

  def fetch_comments(post_id) do
    post_id
    |> Comment.for_post()
    |> Repo.all()
  end

  def fetch_post(post_id, preload \\ [:user, :group, :likes]) do
    query =
      from p in Post,
        where: p.id == ^post_id,
        preload: ^preload

    query
    |> Repo.one()
    |> case do
      %Post{} = post -> {:ok, post}
      error -> error
    end
  end

  def save(params) do
    %Post{}
    |> Post.changeset(params)
    |> Repo.insert()
  end
end
