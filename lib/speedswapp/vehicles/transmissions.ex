defmodule Speedswapp.Vehicles.Transmission do
  use Ecto.Schema
  import Ecto.Changeset

  @permitted_fields [:name, :tooltip]
  @required_fields [:name, :tooltip]

  schema "vehicle_transmissions" do
    field :name, :string
    field :tooltip, :string

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, attrs) do
    model
    |> cast(attrs, @permitted_fields)
    |> validate_required(@required_fields)
  end
end
