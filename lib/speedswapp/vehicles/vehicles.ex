defmodule Speedswapp.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  @permitted_fields [:name, :description, :horsepower, :body_type, :vehicle_type_id, :vehicle_fuel_id]
  @required_fields [:name, :description, :vehicle_type_id]

  schema "vehicles" do
    field :name, :string
    field :description, :string
    field :horsepower, :integer
    field :body_type, :string

    belongs_to :vehicle_type, Speedswapp.Vehicles.Types
    belongs_to :vehicle_fuel, Speedswapp.Vehicles.Fuel

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @permitted_fields)
    |> validate_required(@required_fields)
  end
end
