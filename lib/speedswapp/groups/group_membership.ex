defmodule Speedswapp.Groups.GroupMembership do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Speedswapp.Groups.Group
  alias Speedswapp.Accounts.User

  schema "group_memberships" do
    field :promoted, :boolean, default: false

    belongs_to :user, User
    belongs_to :group, Group

    timestamps()
  end

  @doc false
  def changeset(group_membership \\ %__MODULE__{}, attrs) do
    group_membership
    |> cast(attrs, [:promoted, :user_id, :group_id])
    |> validate_required([:user_id, :group_id])
    |> unique_constraint([:user_id, :group_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:group)
  end
end
