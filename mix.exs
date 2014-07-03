defmodule Twiex.Mixfile do
  use Mix.Project

  def project do
    [app: :twiex,
     version: "0.0.1",
     elixir: "~> 0.14.2",
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
      { :httpoison, github: "edgurgel/httpoison" },
      { :exauth,    path: "../exauth" },
      { :jsex,      github: "talentdeficit/jsex" },
      { :exlager,   github: "khia/exlager" },
    ]
  end
end
