defmodule Cable.Router do

    @get "GET"
    @post "POST"
    @put "PUT"
    @delete "DELETE"

    defmacro __using__(_opts) do
        quote do
            import unquote(__MODULE__)
        end
    end
    
    defmacro inspect_code(code) do
        IO.inspect code
        code
    end
    
    defmacro get(path, handler, func) do
        String.split(path, "/")
        |> compile(handler, @get, func)
    end

    defmacro post(path, handler, func) do
        String.split(path, "/")
        |> compile(handler, @post, func)
    end

    defmacro put(path, handler, func) do
        String.split(path, "/")
        |> compile(handler, @put, func)
    end

    defmacro delete(path, handler, func) do
        String.split(path, "/")
        |> compile(handler, @delete, func)
    end

    defp compile(path, handler, method, func) do
        
        IO.puts "Inspecting handler..."
        IO.inspect handler

        quote bind_quoted: [method: method, path: path, handler: handler, func: func] do
            def match(unquote(method), unquote(path), request) do
                unquote(handler).unquote(func)(request)
            end
        end
        |> IO.inspect
        
    end

end