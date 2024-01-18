defmodule Speedswapp.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :text
      add :description, :text

      timestamps()
    end
  end
end
