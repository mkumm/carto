defmodule Carto do
  import Carto.{Sku, Catalog}

  @headers ["User-Agent": "Amber/0.11 (Macintosh; Intel Mac OS X 15.1)", "Accept": "Application/json; Charset=utf-8"]

  @spec get_current_price(%Carto.Sku{}, atom()) :: Float
  def get_current_price(sku, source) do
    get_source_url(sku, source) 
    |> poison(source)
  end

  def poison(nil, source), do: IO.puts("#{source} does not exist")
  def poison(source_url, source) do
    case HTTPoison.get(source_url, @headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
          |> Floki.parse()
          |> parse_price(source)
          |> Floki.text()
          |> String.to_float()
      {:ok, _} -> 
        IO.puts("Not Found")
      {:error, _} ->
        IO.puts("General Error")
    end
  end

  def parse_price(page, :walmart) do
    page
    |> Floki.find(".price-characteristic")
    |> Enum.at(0)
    |> Floki.attribute("content")
  end

  def parse_price(page, :classyhome) do
    page
    |> Floki.find("#finalPrice")
    |> Floki.text()
  end

  def parse_price(page, :amazon) do
    page
    |> Floki.find("#priceblock_ourprice")
    |> Floki.text()
    |> String.replace("$","")
  end

  def parse_price(page, source), do: IO.inspect("#{source} Not Implemented")

  def get_source_url(sku, source), do: Access.get(sku.sources, source)

  def headers(), do: @headers

end
