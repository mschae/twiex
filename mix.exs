defmodule Twiex.Mixfile do
  use Mix.Project

  def project do
    [app: :twiex,
     version: "0.0.1",
     elixir: "~> 0.13.3",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [],
     mod: {Twiex, []}]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      { :httpotion, github: "myfreeweb/httpotion" },
      { :oauthex,  github: "marcelog/oauthex" }
    ]
  end
end
