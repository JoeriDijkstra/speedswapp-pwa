defmodule Speedswapp.Repo.Migrations.AddHandleToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :handle, :string, size: 16
    end

    create unique_index(:users, [:handle])
  end
end
