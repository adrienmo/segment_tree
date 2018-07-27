defmodule SegmentTree.MixProject do
  use Mix.Project

  def project do
    [
      app: :segment_tree,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      test_coverage: [
        tool: ExCoveralls
      ],
      package: package(),
      name: "segment_tree",
      source_url: "https://github.com/adrienmo/segment_tree",
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp description() do
    "Give a data structure to efficiently compute an operation on ranges."
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
      {:excoveralls, "~> 0.9", only: :test},
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "postgrex",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Adrien Moreau"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/adrienmo/segment_tree"
      }
    ]
  end
end
