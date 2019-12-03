defmodule Carto do
  import Carto.{Sku, Catalog}
  alias Carto.Parse, as: Parse

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
          |> Parse.price(source)
          |> Floki.text()
          |> String.to_float()
      {:ok, _} -> 
        IO.puts("Not Found")
      {:error, _} ->
        IO.puts("General Error")
    end
  end

  def get_source_url(sku, source), do: Access.get(sku.sources, source)

  def headers(), do: @headers

end
