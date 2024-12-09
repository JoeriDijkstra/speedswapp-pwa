defmodule Speedswapp.Groups do
  @moduledoc false

  import Ecto.Query

  alias Speedswapp.Accounts.User
  alias Speedswapp.Groups.Group
  alias Speedswapp.Groups.GroupMembership
  alias Speedswapp.Repo

  def list(%User{id: user_id}) do
    query =
      from g in Group,
        select: g,
        order_by: [asc: :name],
        join: gm in assoc(g, :group_memberships),
        where: gm.user_id == ^user_id

    Repo.all(query)
  end

  def list_all() do
    Repo.all(Group)
  end

  def search(""), do: []

  def search(search) do
    search = "%#{String.downcase(search)}%"

    query =
      from g in Group,
        where: like(g.search, ^search),
        order_by: [asc: :name],
        limit: 5

    Repo.all(query)
  end

  def is_subscribed?(group_id, %User{id: user_id}) do
    Repo.get_by(GroupMembership, group_id: group_id, user_id: user_id)
  end

  def subscribe(group_id, %User{id: user_id}, promoted \\ false) do
    %{
      group_id: group_id,
      user_id: user_id,
      promoted: promoted
    }
    |> GroupMembership.changeset()
    |> Repo.insert()
  end

  def unsubscribe(group_id, %User{} = user) do
    case is_subscribed?(group_id, user) do
      nil ->
        {:error, :not_found_error}

      %GroupMembership{} = membership ->
        Repo.delete(membership)
    end
  end

  def get(id) do
    Repo.get(Group, id)
  end

  def list_for_select(%User{} = user) do
    user
    |> list()
    |> Enum.map(fn group ->
      {group.name, group.id}
    end)
  end

  def save(params, user) do
    case do_create(params) do
      {:ok, group} ->
        %{
          user_id: user.id,
          group_id: group.id,
          promoted: true
        }
        |> GroupMembership.changeset()
        |> Repo.insert()
    end
  end

  defp do_create(params) do
    %Group{}
    |> Group.changeset(params)
    |> Repo.insert()
  end
end
