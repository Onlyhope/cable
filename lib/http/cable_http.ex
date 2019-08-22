defmodule Cable.Http do
    
    require Logger
    
    def start_link(port: port) do

        {:ok, socket} = :gen_tcp.listen(port,
            [:binary, packet: :line, active: false, reuseaddr: true])

        Logger.info "Accepting connections on port #{port}"

        {:ok, spawn_link(Http, :accept, [socket, dispatch])}
        
    end

    def accept(socket) do
        
        {:ok, socket} = :gen_tcp.accept(socket)

        spawn(fn -> 
            IO.puts "Read request here..."
        end)

        accept(socket)

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