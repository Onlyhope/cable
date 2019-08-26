defmodule Cable.Server do
    
    def serve(client) do
        client
        |> read()
        |> parse()
        |> process()
        |> write(client)
    end

    defp read(socket) do

        {:ok, line} = :gen_tcp.recv(socket, 0)

        headers = read_headers(socket)
        |> Enum.map(fn {k, v} -> {String.trim(k), String.trim(v)} end)
        |> Enum.reduce(Map.new, fn ({k, v}, acc) -> Map.put(acc, k, v) end)

        IO.puts "Reading body..."

        body = read_body(socket)
        
        IO.puts "Request: #{inspect line}"
        IO.puts "Headers: #{inspect headers}"
        IO.puts "Body: #{inspect body}"

        {line, headers}
    end

    defp parse({line, headers}) do

        [verb, path, _version] = String.split(line)

        {path, query} = parse_uri(path)

        query_params = parse_params(query)
        
        %{
            verb: verb,
            path: path,
            query: query_params,
            headers: headers
        }
    end

    defp read_headers(socket, headers \\ []) do

        {:ok, line} = :gen_tcp.recv(socket, 0)

        IO.puts "H: #{inspect line}"

        case Regex.run(~r/(\w+):\s*(.*)/, line) do
            [_line, key, value] -> [{key, value}] ++ read_headers(socket, headers)
            _                   -> []
        end
    end

    defp read_body(socket, body \\ "") do
        case :gen_tcp.recv(socket, 0) do
            {:ok, line} -> line <> read_body(socket, body)
            _           -> body
        end
    end

    defp parse_uri(path) do
        case String.split(path, "?") do
            [path] -> {path, []}
            [path, query] -> {path, query}
        end
    end

    defp parse_params(_query) do
        IO.puts "Processing query params..."
    end

    defp process(_socket) do
        IO.puts "Delegating to application for processing..."
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