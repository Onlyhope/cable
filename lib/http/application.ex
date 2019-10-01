defmodule Cable.Application do

    @moduledoc false
    use Application

    def start(_type, _args) do
        
        # Starts a worker by calling: Cable.Worker.start_link(arg)
        # {Cable.Worker, arg}
        children = [
        #    {Http.PlugAdapter, plug: CurrentTime, port: 3000},
        #    {Http.PlugAdapter, plug: CurrentTime, port: 4000}
            Supervisor.child_spec({Http.PlugAdapter, [plug: CurrentTime, port: 3050]}, id: :server_2),
            Supervisor.child_spec({Http.PlugAdapter, [plug: CurrentTime, port: 3000]}, id: :server_1),
            {Cable.Http, [port: 3025]},
            # {Cable.ConnAdapter, [plug: CurrentTime, port: 4000]}
            # Supervisor.child_spec({Sandbox, [name: "Aaron"]}, id: :sandbox_1),
            # Supervisor.child_spec({Sandbox, [name: "Rania"]}, id: :sandbox_2),
        ]

        # See https://hexdocs.pm/elixir/Supervisor.html
        # for other strategies and supported options
        opts = [strategy: :one_for_one, name: Http.Supervisor]
        Supervisor.start_link(children, opts)

    end

end
