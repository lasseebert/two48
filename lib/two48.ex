defmodule Two48 do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    IO.puts "Starting Two48 application"

    import Supervisor.Spec, warn: false

    children = [
      # Here you could define other workers and supervisors as children
      # worker(Two48.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Two48.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
