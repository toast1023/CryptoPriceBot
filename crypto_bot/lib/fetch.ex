defmodule Fetch do
	def data_url(ticker) do
      # IO.puts(ticker)
      # https://data.messari.io/api/v1/assets/eth/metrics
      data_api = "https://data.messari.io/api/v1/assets/"
      # IO.puts("#{data_api}#{ticker}/metrics")
      coin = "#{data_api}#{ticker}/metrics"
    end

	def data(ticker) do
      %{body: body} = HTTPoison.get!(data_url(ticker))
      coin = Poison.decode!(body, keys: :atoms)
      price = ("#{coin.data.market_data.price_usd}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(3)
      priceBTC = ("#{coin.data.market_data.price_btc}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(5)
      changeHour = ("#{coin.data.market_data.percent_change_usd_last_1_hour}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(5)
      change24 = ("#{coin.data.market_data.percent_change_usd_last_24_hours}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(5)
      volume24 = ("#{coin.data.market_data.volume_last_24_hours}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(5)
      marketPercentage = ("#{coin.data.marketcap.marketcap_dominance_percent}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(3)
      open = ("#{coin.data.market_data.ohlcv_last_24_hour.open}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(5)
      high = ("#{coin.data.market_data.ohlcv_last_1_hour.high}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(5)
      low = ("#{coin.data.market_data.ohlcv_last_1_hour.low}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(5)
      close = ("#{coin.data.market_data.ohlcv_last_1_hour.close}") |> Float.parse() |> elem(0) |> Decimal.from_float() |> Decimal.round(5)
      myString = ("```elixir\n~#{coin.data.name}~\n")
      <> ("Symbol: #{coin.data.symbol}\n\n")
      <> ("Market data:\n")
      <> ("   Price USD: #{price}\n")
      <> ("   Price BTC: #{priceBTC}\n")
      <> ("   Change last hour: #{changeHour}\n")
      <> ("   Change 24 hours: #{change24}\n")
      <> ("   Volume 24 hours: #{volume24}\n")
      <> ("   Open: #{open}\n")
      <> ("   High: #{high}\n")
      <> ("   Low: #{low}\n")
      <> ("   Close: #{close}\n\n")

      <> ("Market cap:\n")
      <> ("   Current rank: #{coin.data.marketcap.rank}\n")
      <> ("   Market percentage: #{marketPercentage}%\n\n")

      <> ("Supply:\n")
      <> ("   Circulating: #{coin.data.supply.circulating}\n")
      <> ("   Annual inflation: #{coin.data.supply.annual_inflation_percent}\n\n")

      <> ("All time high: #{coin.data.all_time_high.price} on #{coin.data.all_time_high.at}\n\n```")
    end

    def price(ticker) do
      %{body: body} = HTTPoison.get!(data_url(ticker))
      coin = Poison.decode!(body, keys: :atoms)
      myString = ("#{coin.data.market_data.price_usd}")
                |> Float.parse()
                |> elem(0)
    end
    def tickerCheck(ticker) do
      %{body: body} = HTTPoison.get!(data_url(ticker))
      coin = Poison.decode!(body, keys: :atoms)
      case coin do
        {:badkey, _somethingelse} -> "boom"
        _ -> coin
      end
    end
end