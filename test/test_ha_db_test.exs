defmodule TestHaDbTest do
  use ExUnit.Case
  doctest TestHaDb

  test "greets the world" do
    assert TestHaDb.hello() == :world
  end
end
