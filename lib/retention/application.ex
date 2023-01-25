defmodule Retention.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      # Start the Commanded application
      Retention.App,

      # Start the Ecto Repo
      Retention.Repo,

      # Supervisor
      Retention.EventHandlerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Retention.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
