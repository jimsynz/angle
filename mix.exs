defmodule Angle.Mixfile do
  use Mix.Project

  @description """
  Tired of forever converting back and forwards between degrees and radians?
  Well worry no more; Angle is here to make your life simple!
  """
  @version "0.3.0"

  def project do
    [
      app: :angle,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: @description,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      maintainers: ["James Harton <james@automat.nz>"],
      licenses: ["MIT"],
      links: %{
        "Source" => "https://gitlab.com/jimsy/angle"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:credo, "~> 0.10", only: ~w(dev test)a, runtime: false},
      {:inch_ex, "~> 1.0", only: ~w(dev test)a, runtime: false},
      {:dialyxir, "~> 0.5", only: ~w(dev test)a, runtime: false}
    ]
  end
end
