defmodule Carto.Sku do
  defstruct msku: nil,
    name: "",
    map_price: 0.0,
    sources: [],
    scans: []

  def new(msku, name, map_price, sources, scans) do 
    %__MODULE__{msku: msku, name: name, map_price: map_price, sources: sources, scans: scans}
  end

  def add_source(sku, _new_source) do
    sku
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

  def sample_data(:chair) do
    %__MODULE__{
      msku: "53347",
      name: "ACME Brancaster Chair, Retro Brown Top Grain Leather & Aluminum",
      map_price: 935.00,
      sources: [
        {:amazon, "https://www.amazon.com/Brancaster-Retro-Brown-Leather-Aluminum/dp/B073VQF96R/ref=sr_1_1?crid=RQSEIEIXJVRX&keywords=acme+furniture&qid=1575309574&sprefix=Acme+fur%2Caps%2C143&sr=8-1"},
        {:walmart, "https://www.walmart.com/ip/ACME-Brancaster-Chair-Retro-Brown-Top-Grain-Leather-Aluminum/193351271"}
      ],
      scans: [
        {:walmart, ~D[2020-11-25], 699.69},
        {:amazon, ~D[2019-12-01], 935.00}
      ]
    }
  end

  def sample_data(_) do
    %__MODULE__{
      msku: "00114",
      map_price: 250.00,
      sources: [
        {:walmart, "https://www.walmart.com/ip/Acme-Willcox-Computer-Desk-Cherry/55065849"},
        {:furniturecart, "https://www.furniturecart.com/willcox-computer-desk-00114-acme-furniture.html"},
        {:classyhome, "https://www.theclassyhome.com/Product/ACM-00114/Acme+Furniture+Willcox+Cherry+Computer+Desk"},
        {:jet, "https://jet.com/product/Acme-Furniture-Willcox-Cherry-Corner-Computer-Desk/8462d9b63f0644fe83c829939a365534"}
      ],
      scans: [
        {:jet, ~D[2019-09-01], 227.15},
        {:classyhome, ~D[2019-11-25], 178.16},
        {:furniturecart, ~D[2019-11-25], 279.25},
        {:walmart, ~D[2020-11-25], 120.69}
      ]
    }
  end

end
