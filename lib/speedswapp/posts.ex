defmodule Speedswapp.Posts do
  @moduledoc false

  import Ecto.Query

  alias Speedswapp.Repo
  alias Speedswapp.Posts.Post

  def list(%{assigns: %{current_user: user}}, page \\ 1, per_page \\ 5) do
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
        preload: [:user, :group],
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
        preload: [:user, :group],
        where: p.group_id == ^group_id,
        limit: ^per_page,
        offset: ^offset

    Repo.all(query)
  end

  def save(params) do
    %Post{}
    |> Post.changeset(params)
    |> Repo.insert()
  end
end
