defmodule Carto do

  def ping(), do: :pong

  def demo(), do: Carto.Demo.run()

  def get_prices(sku), do: Carto.Sku.scan_all_sources(sku)

end
