defmodule TestHaDb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      {MessageLogWriter, "message_history_full.log"},
      TestHaDb.Repo,
      TenMilionSpamer.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TestHaDb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
