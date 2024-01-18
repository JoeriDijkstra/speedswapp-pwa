defmodule Speedswapp.Vehicles.Fuel do
  use Ecto.Schema
  import Ecto.Changeset

  @permitted_fields [:name]
  @required_fields [:name]

  schema "vehicle_fuels" do
    field :name, :string

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, attrs) do
    model
    |> cast(attrs, @permitted_fields)
    |> validate_required(@required_fields)
  end
end
