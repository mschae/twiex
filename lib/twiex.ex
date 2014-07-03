defmodule Twiex do
  use Application

  # See http://elixir-lang.org/docs/stable/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Code.load_file "config/twitter.exs"

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Twiex.Worker, [arg1, arg2, arg3])
      worker(Twiex.Listener, []),
    ]

    # See http://elixir-lang.org/docs/stable/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Twiex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
