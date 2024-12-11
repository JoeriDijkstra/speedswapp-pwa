defmodule Speedswapp.Posts.UserPostLikes do
  use Ecto.Schema

  import Ecto.Changeset

  schema "user_post_likes" do
    belongs_to :user, User
    belongs_to :post, Post
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:user_id, :post_id])
    |> validate_required(:user_id, :post_id)
    |> unique_constraint([:user_id, :post_id], name: "user_post_likes_post_id_user_id_index")
  end
end
