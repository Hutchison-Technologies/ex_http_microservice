defmodule ExHttpMicroservice.ClientTest do
  use ExUnit.Case, async: true

  defmodule DefaultClient do
    use ExHttpMicroservice.Client
  end

  describe "when client doesn't specify secure" do
    test "process_request_url/1 returns an http url" do
      uri = DefaultClient.process_request_url("") |> URI.parse()
      assert uri.scheme == "http"
    end
  end

  describe "when client doesn't specify host" do
    test "process_request_url/1 returns a localhost url" do
      uri = DefaultClient.process_request_url("") |> URI.parse()
      assert uri.host == "localhost"
    end
  end

  describe "when client doesn't specify port" do
    test "process_request_url/1 returns a url with port 8080" do
      uri = DefaultClient.process_request_url("") |> URI.parse()
      assert uri.port == 8080
    end
  end

  describe "when DEPLOYED_ENV is set to staging" do
    test "process_request_url/1 returns a url with staging- prefixed" do
      uri = DefaultClient.process_request_url("", %{"DEPLOYED_ENV" => "staging"}) |> URI.parse()
      assert uri.host == "staging-localhost"
    end
  end

  describe "when DEPLOYED_ENV is set to prod" do
    test "process_request_url/1 returns a url with prod- prefixed" do
      uri = DefaultClient.process_request_url("", %{"DEPLOYED_ENV" => "prod"}) |> URI.parse()
      assert uri.host == "prod-localhost"
    end
  end

  describe "when client specifies port" do
    defmodule PortClient do
      use ExHttpMicroservice.Client
      def port(), do: 9999
    end

    test "process_request_url/1 returns a url with port #{PortClient.port()}" do
      uri = PortClient.process_request_url("") |> URI.parse()
      assert uri.port == PortClient.port()
    end
  end

  describe "when client specifies host" do
    defmodule HostClient do
      use ExHttpMicroservice.Client
      def host(), do: "my-host"
    end

    test "process_request_url/1 returns a #{HostClient.host()} url" do
      uri = HostClient.process_request_url("") |> URI.parse()
      assert uri.host == HostClient.host()
    end
  end

  describe "when client insecure" do
    defmodule InsecureClient do
      use ExHttpMicroservice.Client
      def secure?(), do: false
    end

    test "process_request_url/1 returns an http url" do
      uri = DefaultClient.process_request_url("") |> URI.parse()
      assert uri.scheme == "http"
    end
  end

  describe "when client secure" do
    defmodule SecureClient do
      use ExHttpMicroservice.Client
      def secure?(), do: true
    end

    test "process_request_url/1 returns an https url" do
      uri = SecureClient.process_request_url("") |> URI.parse()
      assert uri.scheme == "https"
    end
  end

  describe "process_request_url/1 when given a path" do
    test "returns a url ending with the given path" do
      some_path = "/stairway/to/heaven"
      uri = DefaultClient.process_request_url(some_path) |> URI.parse()
      assert uri.path == some_path
    end
  end

  describe "process_request_headers/1 when given headers" do
    test "returns given list plus content-type application/json header" do
      headers = [{"Accept", "application/json"}, {"Authorization", "Bearer mememe"}]
      actual = DefaultClient.process_request_headers(headers)

      assert actual ==
               [{"Content-Type", "application/json"} | headers]
               |> Enum.sort_by(fn {k, _} -> k end)
    end

    test "returns unique list" do
      headers = [{"Content-Type", "application/json"}, {"Content-Type", "application/jsonp"}]
      actual = DefaultClient.process_request_headers(headers)

      assert actual == [{"Content-Type", "application/json"}]
    end
  end

  describe "process_request_headers/1 when given empty list" do
    test "returns list containing content-type application/json header" do
      headers = []
      actual = DefaultClient.process_request_headers(headers)

      assert actual == [{"Content-Type", "application/json"}]
    end
  end

  describe "process_request_body/1 when given JSON encodable value" do
    test "returns JSON encoded value" do
      body = %{"some" => "request"}
      actual = DefaultClient.process_request_body(body)

      assert actual == body |> Poison.encode!()
    end
  end

  describe "process_request_body/1 when given non JSON encodable value" do
    test "raises an error" do
      body = {"some", "request"}

      assert_raise(Poison.EncodeError, fn ->
        DefaultClient.process_request_body(body)
      end)
    end
  end

  describe "process_response_body/1 when given JSON encoded value" do
    test "returns JSON decoded value" do
      body = %{"some" => "request"}
      actual = DefaultClient.process_response_body(body |> Poison.encode!())
      assert actual == body
    end
  end

  describe "process_response_body/1 when given non JSON encoded value" do
    test "returns raw value" do
      body = "# Some non json value here"
      actual = DefaultClient.process_response_body(body)
      assert actual == body
    end

    test "returns empty map for empty body" do
      body = ""
      actual = DefaultClient.process_response_body(body)
      assert actual == %{}
    end
  end
end
