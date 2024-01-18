defmodule Speedswapp.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :description, :string
    field :name, :string
    field :image_path, :string
    field :public, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :description, :public, :image_path])
    |> validate_required([:name, :description, :image_path])
  end
end
