defmodule ExHttpMicroservice.ClientTest do
  use ExUnit.Case, async: true

  defmodule DefaultClient do
    use ExHttpMicroservice.Client
  end

  describe "when client doesn't specify secure" do
    test "process_request_url/1 returns a string prefixed with http://" do
      assert "http://" <> _ = DefaultClient.process_request_url("")
    end
  end

  describe "when client insecure" do
    defmodule InsecureClient do
      use ExHttpMicroservice.Client
      def secure(), do: false
    end

    test "process_request_url/1 returns a string prefixed with http://" do
      assert "http://" <> _ = InsecureClient.process_request_url("")
    end
  end

  describe "when client secure" do
    defmodule SecureClient do
      use ExHttpMicroservice.Client
      def secure(), do: true
    end

    test "process_request_url/1 returns a string prefixed with https://" do
      assert "https://" <> _ = SecureClient.process_request_url("")
    end
  end
end
