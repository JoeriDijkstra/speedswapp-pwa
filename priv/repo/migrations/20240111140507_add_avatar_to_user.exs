defmodule Speedswapp.Repo.Migrations.AddAvatarToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :avatar_path, :string
    end
  end
end
