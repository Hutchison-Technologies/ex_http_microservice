defmodule ExHttpMicroservice.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_http_microservice,
      version: String.trim(File.read!("VERSION")),
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "ExHttpMicroservice",
      source_url: "https://github.com/Hutchison-Technologies/ex_http_microservice",
      homepage_url: "https://github.com/Hutchison-Technologies/ex_http_microservice",
      dialyzer: [
        plt_file: {:no_warn, "dialyzer.plt"}
      ],
      test_coverage: [tool: :covertool]
    ]
  end

  defp description() do
    "Client library to wrap HTTP connection with common microservice implementation."
  end

  defp package() do
    [
      licenses: ["MIT"],
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE VERSION),
      links: %{"GitHub" => "https://github.com/Hutchison-Technologies/ex_http_microservice"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.5"},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:eliver, "~> 2.0.0", only: :dev},
      {:junit_formatter, "~> 3.0", only: [:test]},
      {:covertool, "~> 2.0", only: [:test]},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false}
    ]
  end
end
