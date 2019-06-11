defmodule ExampleClient do
  use ExHttpMicroservice.Client

  # If no override functions are present, the client falls back to the default values

  # defaults to false
  def secure?(), do: false

  # defaults to localhost
  def host(), do: "shop-microservice"

  # defaults to 8080
  def port(), do: 4000

  def list_vegetables() do
    case get("/vegetables") do
      {:ok,
       %HTTPoison.Response{
         body: %{"data" => vegetables},
         status_code: 200
       }} ->
        {:ok, vegetables}

      error ->
        error
    end
  end

  def create_vegetable(vegetable) do
    case post("/vegetables", %{"vegetable" => vegetable}) do
      {:ok,
       %HTTPoison.Response{
         body: %{"data" => created_vegetable},
         status_code: 201
       }} ->
        {:ok, created_vegetable}

      error ->
        error
    end
  end
end
