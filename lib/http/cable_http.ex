defmodule Cable.Http do
    
    require Logger
    
    def start_link(port: port) do

        {:ok, socket} = :gen_tcp.listen(port,
            [:binary, packet: :line, active: false, reuseaddr: true])

        Logger.info "Accepting connections on port #{port}"

        {:ok, spawn_link(Cable.Http, :accept, [socket])}

    end

    def accept(socket) do
        
        {:ok, client} = :gen_tcp.accept(socket)

        IO.puts "Accepted socket..."

        spawn(fn -> loop_receive(client) end)

        accept(socket)

    end

    def loop_receive(socket) do

        result = :gen_tcp.recv(socket, 0)
        |> IO.inspect

        loop_receive(socket)
    end

    def serve(socket, %{awaiting: :response} = req), do: req 
    def serve(socket, req) do
        req = socket
        |> read_line()

        serve(socket, req)
    end

    defp read_line(socket) do
        packets = :gen_tcp.recv(socket, 0)
        IO.puts "Packets: #{inspect packets}"
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