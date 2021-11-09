defmodule CryptoBot.Alert.Server do
	use GenServer

	defp auto_increment(tracked) when tracked == %{}, do: 1
	# get next id in sequence by converting keys of map to list, getting the last key 
	# and adding 1 to it
	defp auto_increment(tracked) do
		Map.keys(tracked)
		|> List.last()
		|> Kernel.+(1)
	end
	def start_link do
		GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
	end

	def init(:ok) do
		tracked = %{}
		refs = %{}
		{:ok, {tracked,refs}}
	end

	def add(ticker, num) when is_binary(ticker) and is_number(num) do
		GenServer.cast(__MODULE__, {:add, ticker, num})
	end

	def handle_cast({:add, ticker, num}, {tracked, refs}) do
		{:ok, pid} = CryptoBot.Alert.AlertSupervisor.new_alert(ticker, num)
		ref = Process.monitor(pid)
		id = auto_increment(tracked)
		refs = Map.put(refs, ref, id)
		tracked = Map.put(tracked, id, {ticker, pid, ref})
		{:noreply, {tracked, refs}}
	end

	def remove(id) do
		GenServer.cast(__MODULE__, {:remove, id})
	end

	def handle_cast({:remove, id}, {tracked, refs}) do
		with {{_name, pid, _ref}, tracked}<-Map.pop(tracked, id)
		do
			Process.exit(pid,:shutdown)
			{:noreply,{tracked,refs}}
		else 
			_->
				IO.puts("	Please input a valid id. \n	To see a list of valid ids, use command list()")
				{:noreply,{tracked,refs}}
		end
	end

	def list do
		GenServer.call(__MODULE__, {:list})
	end

	def handle_call({:list}, _from, {tracked, _refs} = state) do
		list = 
			Enum.map(tracked, fn{id, {ticker, pid, _ref}} ->
				%{id: id, ticker: ticker} 
			end)
		{:reply, list, state}
	end
end