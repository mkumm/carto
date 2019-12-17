defmodule Carto.Sku do
  import Carto.Scrape

  defstruct msku: nil,
            name: "",
            map_price: 0.0,
            sources: [],
            scans: []


  def new(msku, name, map_price, sources, scans) do
    %__MODULE__{msku: msku, name: name, map_price: map_price, sources: sources, scans: scans}
  end

  def scan_all_sources(sku) do
    sku
    |> get_sources
    |> Enum.map(fn {source, _url} -> {source, get_current_price(sku, source)} end)
    |> Enum.map(fn {source, price} -> create_scan_record(source, price, sku.map_price) end)
    |> Enum.filter(& !is_nil(&1))
  end

  def create_scan_record(_source, 0.00, _map), do: nil

  def create_scan_record(source, price, map), do: {source, Date.utc_today, price, map}

  def get_sources(sku), do: Map.fetch!(sku, :sources)

  def add_source(sku, new_source) do
    Map.update(sku, :sources, sku.sources, fn c -> c ++ [new_source] end)
  end

  def add_scan(sku, new_scan) do
    Map.update(sku, :scans, sku.scans, fn c -> c ++ [new_scan] end)
  end

  def change_map(sku, map_price) do
    Map.replace!(sku, :map_price, map_price)
  end

  def change_name(sku, name) do
    Map.replace!(sku, :name, name)
  end

  def change_msku(sku, new_msku) do
    Map.replace!(sku, :msku, new_msku)
  end

  @spec get_current_price(%Carto.Sku{}, atom()) :: {atom(), Float}
  def get_current_price(sku, source) do
    get_source_url(sku, source)
    |> poison(source)
  end

  def get_scans(sku, date \\ nil) do
    Map.fetch!(sku, :scans)
    |> filter_scans(date)
  end

  def get_source_url(sku, source), do: Access.get(sku.sources, source)

  def filter_scans(scans, nil), do: scans
  def filter_scans(scans, date) do
    scans
    |> Enum.filter(fn {_, sdate, _} -> Date.diff(sdate, date) >= 0 end) 
  end

  def sample_data(:chair) do
    %__MODULE__{
      msku: "53347",
      name: "ACME Brancaster Chair, Retro Brown Top Grain Leather & Aluminum",
      map_price: 735.00,
      sources: [
        {:amazon,
         "https://www.amazon.com/Brancaster-Retro-Brown-Leather-Aluminum/dp/B073VQF96R/ref=sr_1_1?crid=RQSEIEIXJVRX&keywords=acme+furniture&qid=1575309574&sprefix=Acme+fur%2Caps%2C143&sr=8-1"},
        {:walmart,
          "https://www.walmart.com/ip/ACME-Brancaster-Chair-Retro-Brown-Top-Grain-Leather-Aluminum/193351271"},
        {:hayneedle,
          "https://www.hayneedle.com/product/acmefurniturebrancaster31inaccentchair.cfm"},
        {:allmodern, 
          "https://www.allmodern.com/Modern-Rustic-Interiors--Virgil-Barrel-Chair-STSS5817-L54-K~A000729188.html"},
        {:homary,
          "https://www.homary.com/zado-industrial-loft-upholstered-aviator-chair-brown-leather-barrel-chair.html"},
        {:cymax,
          "https://www.cymax.com/acme-brancaster-chair-in-retro-brown-top-grain-leather-and-aluminum-53547.htm"}
      ],
      scans: [
        {:walmart, ~D[2020-11-25], 699.69, 935.00},
        {:amazon, ~D[2019-12-01], 935.00, 935.00}
      ]
    }
  end


  def sample_data(_) do
    %__MODULE__{
      msku: "00114",
      map_price: 250.00,
      sources: [
        {:walmart, "https://www.walmart.com/ip/Acme-Willcox-Computer-Desk-Cherry/55065849"},
        {:furniturecart,
         "https://www.furniturecart.com/willcox-computer-desk-00114-acme-furniture.html"},
        {:classyhome,
         "https://www.theclassyhome.com/Product/ACM-00114/Acme+Furniture+Willcox+Cherry+Computer+Desk"},
        {:jet,
         "https://jet.com/product/Acme-Furniture-Willcox-Cherry-Corner-Computer-Desk/8462d9b63f0644fe83c829939a365534"}
      ],
      scans: [
        {:jet, ~D[2019-09-01], 227.15, 250.00},
        {:classyhome, ~D[2019-11-25], 178.16, 250.00},
        {:furniturecart, ~D[2019-11-25], 279.25, 250.00},
        {:walmart, ~D[2020-11-25], 120.69, 250.00}
      ]
    }
  end

  def sample_data(), do: sample_data(:none)
end
