defmodule Carto.Demo do

  alias Carto.Sku

  def run() do
    IO.puts("Starting test... Loading Test Chair")
    p = Sku.sample_data(:chair)
    IO.puts(p.name)
    IO.puts("Fetch current price from known online sellers")
    Sku.scan_all_sources(p)
    |> Enum.each(fn {seller, _, scan, map} -> 
      case scan < map do
        true ->
          IO.puts("  #{seller} MAP violation [#{scan} / #{map}]")
        _ ->
          IO.puts("  #{seller} ok [#{scan} / #{map}]")
      end
    end)
  end


end
