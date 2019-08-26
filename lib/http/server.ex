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
        
        IO.puts "Line: #{inspect line}"
        IO.inspect headers

        {line, headers}
    end

    defp parse({line, headers}) do

        [verb, path, _version] = String.split(line)

        {path, query} = parse_uri(path)
        
        %{
            verb: verb,
            path: path,
            query: query,
            headers: headers
        }
    end

    defp read_headers(socket, headers \\ []) do

        {:ok, line} = :gen_tcp.recv(socket, 0)

        result = Regex.run(~r/(\w+): (.*)/, line)

        IO.puts "Result of regex: "
        IO.inspect result

        case result do
            [_line, key, value] -> [{key, value}] ++ read_headers(socket, headers)
            _                   -> []
        end
    end

    defp parse_uri(path) do
        case String.split(path, "?") do
            [path] -> {path, []}
            [path, query] -> {path, query}
        end
    end

    defp process(socket) do
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