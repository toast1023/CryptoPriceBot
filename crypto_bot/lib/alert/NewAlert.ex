defmodule CryptoBot.Alert.NewAlert do
	use GenServer

	defstruct [:ticker, :num]
    def start_link({ticker, num}) do
        GenServer.start_link(__MODULE__, {ticker, num})
    end

    def init({ticker,num}) do
        schedule_work() # Schedule work to be performed on start
        {:ok, %CryptoBot.Alert.NewAlert{ticker: ticker, num: num}}
    end

    def handle_info(:work,state) do
    	ticker = state.ticker
    	num = state.num
        real_time_price = get_price(ticker,num)
        # IO.puts(real_time_price)
    	if (real_time_price > num) do
    		IO.puts("#{ticker} has surpassed price of #{num}!")
    		Process.exit(__MODULE__, :normal)
    	end
		IO.puts("#{state.ticker}: #{real_time_price}, Target: #{num}")

        schedule_work() # Reschedule once more
        {:noreply, state}
    end

  	# def handle_info(:work,state) do
  	# 	IO.inspect(state.num)
  	# 	schedule_work() # Reschedule once more
   #      {:noreply, state}
  	# end

    defp schedule_work() do
        Process.send_after(self(), :work, 20*1000) # 20 seconds
    end

    def get_price(ticker,num) do
      # Call API & Persist
      # IO.puts "#{ticker} #{num}"
      hello = Fetch.price(ticker)
    end
end