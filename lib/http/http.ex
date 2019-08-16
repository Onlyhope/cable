defmodule Http do
    
    require Logger

    def start_link(port: port) do
        
        {:ok, socket} = :gen_tcp.listen(port, [:binary])
        Logger.info("Accepting connections on port #{port}")

        # {:ok, spawn_link(Http, :hello, [self()])}
        {:ok, spawn_link(Http, :accept, [socket, self()])}

    end

    def accept(socket, pid) do
        
        {:ok, request} = :gen_tcp.accept(socket)
        
        IO.inspect request
        IO.puts "Received request: #{inspect request}"

        spawn(fn -> 
            body = "Hello World! The time is #{Time.utc_now |> Time.to_string}"

            response = """
            HTTP/1.1 200\r
            Content-Type text/html\r
            \r
            #{body}
            """

            send_response(request, response)

        end)

        accept(socket, pid)

    end

    def hello(pid) do
        send(pid, "Hello World!")
    end


    def send_response(socket, response) do
        :gen_tcp.send(socket, response)
        :gen_tcp.close(socket)
    end
    
    def child_spec(opts) do
        %{id: Http, start: {Http, :start_link, [opts]}}
    end

end