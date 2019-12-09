defmodule Carto.Scrape do
  alias Carto.Parse, as: Parse
  require Logger
  @headers [
    "User-Agent": "Amber/0.11 (Macintosh; Intel Mac OS X 15.1)",
    Accept: "Application/json; Charset=utf-8"
  ]

  def poison(nil, source), do: IO.puts("#{source} does not exist")

  def poison(source_url, source) do
    case HTTPoison.get(source_url, @headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        try do
          body
          |> Floki.parse()
          |> Parse.price(source)
          |> Floki.text()
          |> string_to_float()
        rescue
          _ -> 0.00
        end
      {:ok, _} ->
        Logger.info("Product Not Found")
        nil
      {:error, _} ->
        Logger.info("General Error")
        nil
    end
  end

  def headers(), do: @headers

  def string_to_float(str) do
    {n, _} = Float.parse(str)
    n
  end
end
