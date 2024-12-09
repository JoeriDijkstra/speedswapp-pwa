defmodule Speedswapp.Repo.Migrations.AddGroupMembership do
  use Ecto.Migration

  def change do
    create table(:group_memberships) do
      add :promoted, :boolean, null: false, default: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :group_id, references(:groups, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:group_memberships, [:user_id, :group_id])
  end
end
