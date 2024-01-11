defmodule Speedswapp.Posts do
  @moduledoc false

  import Ecto.Query

  alias Speedswapp.Repo
  alias Speedswapp.Posts.Post

  def list(%{assigns: %{current_user: _user}}) do
    query =
      from p in Post,
        select: p,
        order_by: [desc: :inserted_at],
        preload: [:user, :group]

    Repo.all(query)
  end

  def save(params) do
    %Post{}
    |> Post.changeset(params)
    |> Repo.insert()
  end
end
