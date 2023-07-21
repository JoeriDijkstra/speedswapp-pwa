defmodule Speedswapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SpeedswappWeb.Telemetry,
      # Start the Ecto repository
      Speedswapp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Speedswapp.PubSub},
      # Start Finch
      {Finch, name: Speedswapp.Finch},
      # Start the Endpoint (http/https)
      SpeedswappWeb.Endpoint
      # Start a worker by calling: Speedswapp.Worker.start_link(arg)
      # {Speedswapp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Speedswapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpeedswappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
