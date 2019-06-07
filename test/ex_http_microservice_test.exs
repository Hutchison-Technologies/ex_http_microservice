defmodule ExHttpMicroserviceTest do
  use ExUnit.Case
  doctest ExHttpMicroservice

  test "greets the world" do
    assert ExHttpMicroservice.hello() == :world
  end
end
