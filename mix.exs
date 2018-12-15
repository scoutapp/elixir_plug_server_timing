defmodule PlugServerTiming.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_server_timing,
      version: "0.0.3",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "A package to include Server-Timing headers for Plug or Phoenix projects"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:scout_apm, "~> 0.4.1"},
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "LICENSE", "mix.exs", "README.md"],
      maintainers: ["Mitchell Henke"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/scoutapp/elixir_plug_server_timing"
      }
    ]
  end
end
