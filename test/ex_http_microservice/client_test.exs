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
      def secure(), do: false
    end

    test "process_request_url/1 returns an http url" do
      uri = DefaultClient.process_request_url("") |> URI.parse()
      assert uri.scheme == "http"
    end
  end

  describe "when client secure" do
    defmodule SecureClient do
      use ExHttpMicroservice.Client
      def secure(), do: true
    end

    test "process_request_url/1 returns an https url" do
      uri = SecureClient.process_request_url("") |> URI.parse()
      assert uri.scheme == "https"
    end
  end
end
