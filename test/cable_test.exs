defmodule CableTest do
  use ExUnit.Case
  doctest Cable

  test "greets the world" do
    assert Cable.hello() == :world
  end
end
