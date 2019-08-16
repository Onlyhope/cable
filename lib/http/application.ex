defmodule Cable.Application do

    @moduledoc false
    use Application

    def start(_type, _args) do
        
        children = [
            {Http, port: 3000}
        ]

        opts = [strategy: :one_for_one, name: Http.Supervisor]
        Supervisor.start_link(children, opts)

    end

end
