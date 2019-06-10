defmodule ExHttpMicroservice.Client do
  @moduledoc """
  Use this module to declare an interface to an external service.
  Specify the connection options by overriding functions (see individual functions for docs):

  - `secure()`


  ## Examples
      defmodule MyUserApiClient do
        use ExHttpMicroservice.Client

        def secure(), do: false
      end
  """
  defmacro __using__(_) do
    quote do
      use HTTPoison.Base

      @doc """
      Returns a boolean determining whether requests are made over HTTP or HTTPS.
      """
      @spec secure() :: boolean
      def secure(), do: false

      defp protocol() do
        cond do
          secure() ->
            "https://"

          true ->
            "http://"
        end
      end

      def process_request_url(url) do
        protocol()
      end

      defoverridable secure: 0
    end
  end
end
