defmodule Carto do
  import Carto.{Sku, Catalog}

  @spec get_current_price(%Carto.Sku{}, atom()) :: Float
  def get_current_price(sku, source) do
    headers = ["User-Agent": "Amber/0.11 (Macintosh; Intel Mac OS X 15.1)"]
    HTTPoison.get!(sku.sources[source], headers)
    |> Map.get(:body)
    |> Floki.parse()
    |> parse_price(source)
    |> Floki.text()
    |> String.to_float()
  end

  def parse_price(page, :walmart) do
    page
    |> Floki.find(".price-characteristic")
    |> Floki.attribute("content")
  end

  def parse_price(page, :classyhome) do
    page
    |> Floki.find("#finalPrice")
    |> Floki.text()
  end

end
