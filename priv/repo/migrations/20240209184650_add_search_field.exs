defmodule Speedswapp.Repo.Migrations.AddSearchField do
  use Ecto.Migration

  def change do
    alter table :groups do
      add :search, :string
    end
  end
end
