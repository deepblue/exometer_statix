defmodule ExometerStatix.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :exometer_statix,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp description do
    """
    StatsD reporter backend for exometer_core
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Moonsik Kang"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/deepblue/exometer_statix"}
    ]
  end

  defp deps do
    [
      {:statix, "~> 1.0"},
      {:ex_doc, "~> 0.14", only: :docs},
    ]
  end
end
