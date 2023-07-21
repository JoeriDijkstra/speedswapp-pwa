defmodule Speedswapp.Repo do
  use Ecto.Repo,
    otp_app: :speedswapp,
    adapter: Ecto.Adapters.MyXQL
end
