defmodule SpeedswappWeb.PageController do
  use SpeedswappWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
