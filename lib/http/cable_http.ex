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

    def loop_receive(socket) do
        
        case :gen_tcp.recv(socket, 0) do
            {:ok, :http_eoh} ->
                send_response(socket, build_response)
            {:ok, ""} ->
                IO.puts "Exiting..."
                send_response(socket, build_response)
            {:ok, line} ->
                IO.inspect line
            {:error, error} ->
                IO.puts "Error received: #{inspect error}"
                System.halt(0)
        end

        loop_receive(socket)
    end

    def build_response do

        body = "Hello from Aaron's Server!"

        """
        HTTP/1.1 200\r
        Content-Type: text/html\r
        Content-Length: #{byte_size(body)}\r
        \r
        #{body}\r\n
        """
        
    end

    def send_response(socket, response) do
        :gen_tcp.send(socket, response)
        :gen_tcp.close(socket)
    end

    def serve(_socket, %{awaiting: :response} = req), do: req 
    def serve(socket, req) do
        req = socket
        |> read_line()
        # |> parse(req)

        serve(socket, req)
    end

    defp read_line(socket) do
        packets = :gen_tcp.recv(socket, 0)
        IO.puts "Packets: #{inspect packets}"
    end

    def child_spec(opts) do
        %{
            id: Cable.Http,
            start: {Cable.Http, :start_link, [opts]}
        }
    end
    
end