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
      Determines whether requests are made over HTTP or HTTPS.
      """
      @spec secure() :: boolean
      def secure(), do: false

      @spec protocol() :: :http | :https
      defp protocol() do
        cond do
          secure() ->
            :https

          true ->
            :http
        end
      end

      # --------------------------------------------------------------------------------
      # From here and below the module is simply an HTTPoison.Base wrapper, see
      # https://hexdocs.pm/httpoison/readme.html#wrapping-httpoison-base
      # --------------------------------------------------------------------------------

      @spec process_request_url(String.t()) :: String.t()
      def process_request_url(url) do
        [protocol() |> Atom.to_string(), "://", url]
        |> Enum.join()
      end

      defoverridable secure: 0
    end
  end
end
