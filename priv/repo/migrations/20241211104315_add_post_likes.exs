defmodule Speedswapp.Repo.Migrations.AddPostLikes do
  use Ecto.Migration

  def change do
    create table(:user_post_likes) do
      add :post_id, references(:posts, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create unique_index(:user_post_likes, [:post_id, :user_id])
  end
end
