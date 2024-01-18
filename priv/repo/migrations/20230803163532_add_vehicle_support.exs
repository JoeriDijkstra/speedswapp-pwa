defmodule Speedswapp.Repo.Migrations.AddVehicleSupport do
  use Ecto.Migration

  def change do
    create table(:vehicle_transmissions) do
      add :name, :string, null: false
      add :tooltip, :string, null: false

      timestamps()
    end

    create table(:vehicle_types) do
      add :name, :string, null: false
      add :description, :string, null: false

      timestamps()
    end

    create table(:vehicle_fuels) do
      add :name, :string, null: false

      timestamps()
    end

    create table(:vehicles) do
      add :name, :string, null: false
      add :description, :string, null: false
      add :horsepower, :integer
      add :body_type, :string
      add :vehicle_type_id, references(:vehicle_types), null: false
      add :vehicle_fuel_id, references(:vehicle_fuels)

      timestamps()
    end

    create table(:personal_vehicles) do
      add :vehicle_id, references(:vehicles), null: false
      add :vehicle_transmission_id, references(:vehicle_transmissions)

      add :description, :string, null: false
      add :horsepower, :integer
      add :colour, :string
      add :odometer, :integer

      timestamps()
    end

    create index(:personal_vehicles, [:vehicle_id])
  end
end
