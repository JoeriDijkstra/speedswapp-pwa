defmodule Speedswapp.Groups do
  @moduledoc false

  import Ecto.Query

  alias Speedswapp.Groups.Group
  alias Speedswapp.Repo

  def list(%{assigns: %{current_user: _user}}) do
    query =
      from g in Group,
        select: g,
        order_by: [asc: :name]

    Repo.all(query)
  end

  def save(params) do
    %Group{}
    |> Group.changeset(params)
    |> Repo.insert()
  end
end
