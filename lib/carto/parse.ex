defmodule Carto.Parse do

  def price(html, :walmart) do
    html
    |> Floki.find(".price-characteristic")
    |> Enum.at(0)
    |> Floki.attribute("content")
  end

  def price(html, :amazon) do
    html
    |> Floki.find("#price_inside_buybox")
    |> Floki.text()
    |> String.trim()
    |> String.replace("$","")
  end

  def price(html, :classyhome) do
    html
    |> Floki.find("#finalprice")
    |> Floki.text()
  end

  def parce_price(_html, source), do: IO.inspect("#{source} Not implemented")
end
