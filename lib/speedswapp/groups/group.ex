defmodule Speedswapp.Groups.Group do
  alias Speedswapp.Groups.GroupMembership
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :description, :string
    field :name, :string
    field :search, :string
    field :image_path, :string
    field :public, :boolean, default: false

    has_many :group_memberships, GroupMembership

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :description, :public, :image_path])
    |> maybe_put_search(attrs)
    |> validate_required([:name, :description, :image_path])
  end

  defp maybe_put_search(changeset, %{"name" => name}) do
    put_change(changeset, :search, String.downcase(name))
  end

  defp maybe_put_search(changeset, %{name: name}) do
    put_change(changeset, :search, String.downcase(name))
  end

  defp maybe_put_search(changeset, _), do: changeset
end
