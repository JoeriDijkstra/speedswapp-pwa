defmodule Speedswapp.Repo.Migrations.AddGroupProperties do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :image_path, :string
      add :public, :boolean, null: false, default: false
    end
  end
end
