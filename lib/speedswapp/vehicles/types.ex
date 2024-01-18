defmodule Speedswapp.Vehicles.Types do
  use Ecto.Schema
  import Ecto.Changeset

  @permitted_fields [:name, :description]
  @required_fields [:name, :description]

  schema "vehicle_types" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, attrs) do
    model
    |> cast(attrs, @permitted_fields)
    |> validate_required(@required_fields)
  end
end
