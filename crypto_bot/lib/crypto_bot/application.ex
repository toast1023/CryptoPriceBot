defmodule CryptoBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{id: CryptoBot.Alert.AlertSupervisor, start: {CryptoBot.Alert.AlertSupervisor, :start_link, []}},
      %{id: CryptoBot.Alert.Server, start: {CryptoBot.Alert.Server, :start_link, []}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CryptoBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
