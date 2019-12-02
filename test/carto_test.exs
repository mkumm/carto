defmodule CartoTest do
  use ExUnit.Case
  doctest Carto

  test "greets the world" do
    assert Carto.hello() == :world
  end
end
