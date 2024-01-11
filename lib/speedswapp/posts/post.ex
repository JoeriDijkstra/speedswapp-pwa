defmodule Speedswapp.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Speedswapp.Groups.Group
  alias Speedswapp.Accounts.User

  schema "posts" do
    field :caption, :string
    field :description, :string
    field :image_path, :string

    belongs_to :user, User
    belongs_to :group, Group

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:caption, :image_path, :description, :user_id, :group_id])
    |> validate_required([:caption, :image_path, :description, :user_id, :group_id])
  end
end
