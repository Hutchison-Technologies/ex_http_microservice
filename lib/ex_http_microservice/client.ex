defmodule ExHttpMicroservice.Client do
  @moduledoc """
  Use this module to declare an interface to an external service.
  Specify the connection options by overriding functions (see individual functions for docs):

  ## Examples
      defmodule MyUserApiClient do
        use ExHttpMicroservice.Client

        # Determines whether requests are made over HTTP or HTTPS.
        @spec secure() :: boolean()
        def secure(), do: false

        # The host of the service to fire requests at.
        @spec host() :: String.t()
        def host(), do: "localhost"

        # The port of the service to fire requests at.
        @spec port() :: pos_integer()
        def port(), do: 8080
      end
  """
  defmacro __using__(_) do
    quote do
      use HTTPoison.Base

      @doc """
      Determines whether requests are made over HTTP or HTTPS.
      """
      @spec secure() :: boolean()
      def secure(), do: false

      @doc """
      The host of the service to fire requests at.
      """
      @spec host() :: String.t()
      def host(), do: "localhost"

      @doc """
      The port of the service to fire requests at.
      """
      @spec port() :: pos_integer()
      def port(), do: 8080

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

      @spec process_request_url(url) :: url
      def process_request_url(path) do
        [protocol() |> Atom.to_string(), "://", host(), ":", port(), path]
        |> Enum.join()
      end

      @spec process_request_headers(headers) :: headers
      def process_request_headers(headers) do
        [{"Content-Type", "application/json"} | headers]
        |> Enum.uniq_by(fn {k, _} -> k end)
        |> Enum.sort_by(fn {k, _} -> k end)
      end

      defoverridable secure: 0, host: 0, port: 0
    end
  end
end
