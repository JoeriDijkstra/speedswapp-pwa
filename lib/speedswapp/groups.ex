defmodule Speedswapp.Groups do
  @moduledoc false

  import Ecto.Query

  alias Speedswapp.Accounts.User
  alias Speedswapp.Groups.Group
  alias Speedswapp.Repo

  def list(%User{}) do
    query =
      from g in Group,
        select: g,
        order_by: [asc: :name]

    Repo.all(query)
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

  def save(params) do
    %Group{}
    |> Group.changeset(params)
    |> Repo.insert()
  end
end
