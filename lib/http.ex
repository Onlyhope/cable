defmodule Http do
    
    require Logger

    def start_link(port: port) do
        
        {:ok, socket} = :gen_tcp.listen(port, active: false, pocket: :http_bin, reuseaddr: true)
        Logger.info("Accepting connections on port #{port}")

        {:ok, spawn_link(Http, :accept, [socket])}

    end

    def accept(socket) do
        
        {:ok, request} = :gen_tcp.accept(socket)

        spawn(fn -> 
            body = "Hello World! The time is #{Time.utc_now |> Time.to_string}"

            response = """
            HTTP/1.1 200\r
            Content-Type text/html\r
            \r
            #{body}
            """

            send(request, response)

        end)

        accept(socket)
    end

    def send_response(socket, response) do
        :gen_tcp.send(socket, response)
        :gen_tcp.close(socket)
    end
    
    def child_spec(opts) do
        %{id: Http, start: {Http, :start_link, [opts]}}
    end

end