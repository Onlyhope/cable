defmodule Cable.Http do
    
    require Logger

    @options [:binary, packet: :line, active: false, reuseaddr: true]
    
    def start_link(port: port) do

        {:ok, listener} = :gen_tcp.listen(port, @options)

        Logger.info "Accepting connections on port #{port}"

        pid = spawn_link(Cable.Http, :accept, [listener])

        {:ok, pid}

    end

    def accept(listener) do
        
        {:ok, client} = :gen_tcp.accept(listener)

        IO.puts "Accepted socket... #{inspect client}"

        spawn(fn -> Cable.Server.serve(client) end)

        accept(listener)

    end

    def send_response(socket, response) do
        :gen_tcp.send(socket, response)
        :gen_tcp.close(socket)
    end

    def child_spec(opts) do
        %{
            id: Cable.Http,
            start: {Cable.Http, :start_link, [opts]}
        }
    end
    
end