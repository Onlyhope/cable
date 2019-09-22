defmodule Cable.Server do

    def serve(client) do
        client
        |> read()
        |> parse()
        |> process()
        |> write(client)
    end

    defp read(socket) do

        case :gen_tcp.recv(socket, 0) do
            {:ok, http_request} ->
                [protocol | headers_and_body] = http_request |> String.split("\r\n")
                [body | headers] = Enum.reverse(headers_and_body)
                {protocol, headers, body}
            {_, error} ->
                IO.puts "Error: #{inspect error}"
                System.halt(0)
        end
        
    end

    defp parse({protocol, headers, body}) do

        [verb, path, _version] = String.split(protocol)
        
        headers = read_headers(headers)
        |> Enum.reduce(Map.new, fn ({k, v}, acc) -> Map.put(acc, k, v) end)

        %{
            verb: verb,
            path: path,
            headers: headers,
            body: body
        }

    end

    defp read_headers(headers) do

        headers
        |> Enum.reject(fn header -> header == "" end)
        |> Enum.map(fn header ->
            [_line, key, value] = Regex.run(~r/(\w+):\s*(.*)/, header)
            {String.trim(key), String.trim(value)}
        end)

    end

    defp parse_uri(path) do
        case String.split(path, "?") do
            [path] -> {path, []}
            [path, query] -> {path, query}
        end
    end

    defp process(parsed_request) do
        IO.puts "Delegating to application for processing..."
        IO.inspect parsed_request
    end

    defp write(response, socket) do

        IO.puts "Sending response back..."

        body = "Hello from Aaron's Server!"

        response = 
        """
        HTTP/1.1 200\r
        Content-Type: text/html\r
        Content-Length: #{byte_size(body)}\r
        \r
        #{body}\r\n
        """

        :gen_tcp.send(socket, response)
        :gen_tcp.close(socket)
        
    end

end