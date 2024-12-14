defmodule Speedswapp.Posts.Comment do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Speedswapp.Posts.Post
  alias Speedswapp.Accounts.User

  schema "comments" do
    field :body, :string

    belongs_to :user, User
    belongs_to :post, Post

    timestamps()
  end

  def changeset(post \\ %__MODULE__{}, attrs) do
    post
    |> cast(attrs, [:body, :user_id, :post_id])
    |> validate_required([:body, :user_id, :post_id])
  end

  def for_post(post_id) do
    from c in __MODULE__,
      where: c.post_id == ^post_id,
      preload: :user,
      order_by: [desc: c.id]
  end
end
