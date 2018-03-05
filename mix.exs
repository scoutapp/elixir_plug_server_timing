defmodule PlugServerTiming.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_server_timing,
      version: "0.0.1",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, git: "git@github.com:elixir-plug/plug.git", branch: "master"},
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
