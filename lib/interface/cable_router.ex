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
    
    defmacro get(path, handler) do
        String.split(path, "/")
        |> compile(handler, @get)
    end

    defmacro post(path, handler) do
        String.split(path, "/")
        |> compile(handler, @post)
    end

    defmacro put(path, handler) do
        String.split(path, "/")
        |> compile(handler, @put)
    end

    defmacro delete(path, handler) do
        String.split(path, "/")
        |> compile(handler, @delete)
    end

    defp compile(path, handler, method) do
        
        IO.puts "Inspecting handler..."
        IO.inspect handler

        quote bind_quoted: [method: method, path: path, handler: handler] do
            def dispatch(unquote(method), unquote(path), request) do
                unquote(handler).match(unquote(method), unquote(path), request)
            end
        end
        |> IO.inspect
        
    end

end