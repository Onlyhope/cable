defmodule Cable.Application do

    @moduledoc false
    use Application

    def start(_type, _args) do
        
        # Starts a worker by calling: Cable.Worker.start_link(arg)
        # {Cable.Worker, arg}
        children = [
            {Http.PlugAdapter, plug: CurrentTime, port: 3000}
        ]

        # See https://hexdocs.pm/elixir/Supervisor.html
        # for other strategies and supported options
        opts = [strategy: :one_for_one, name: Http.Supervisor]
        Supervisor.start_link(children, opts)

    end

end
