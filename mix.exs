defmodule ExometerStatix.Mixfile do
  use Mix.Project

  @description """
  StatsD reporter backend for exometer_core
  """
  @project_url "https://github.com/deepblue/exometer_statix"
  @version "0.1.1"

  def project do
    [app: :exometer_statix,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: @description,
     source_url: @project_url,
     homepage_url: @project_url,
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    []
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Moonsik Kang"],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_url},
    ]
  end

  defp deps do
    [
      {:statix, "~> 1.0"},
      {:ex_doc, "~> 0.14", only: :dev},
    ]
  end
end
