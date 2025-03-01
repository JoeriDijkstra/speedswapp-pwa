defmodule Speedswapp.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Speedswapp.Groups.Group
  alias Speedswapp.Accounts.User
  alias Speedswapp.Posts.Comment
  alias Speedswapp.Posts.UserPostLikes

  schema "posts" do
    field :caption, :string
    field :description, :string
    field :image_path, :string

    belongs_to :user, User
    belongs_to :group, Group

    has_many :comments, Comment

    many_to_many :likes, User, join_through: UserPostLikes

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:caption, :image_path, :description, :user_id, :group_id])
    |> validate_required([:caption, :description, :user_id, :group_id])
  end

  def base_query() do
    from p in __MODULE__,
      select: p,
      order_by: [desc: :inserted_at],
      preload: [:user, :group]
  end
end
