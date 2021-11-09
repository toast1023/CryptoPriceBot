defmodule CryptoBot.Alert.AlertSupervisor do
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def new_alert(ticker, num) do
  	spec = %{id: CryptoBot.Alert.NewAlert, 
            restart: :temporary,
            start: {CryptoBot.Alert.NewAlert, :start_link, [{ticker, num}]}}
  	DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
    )
  end
end