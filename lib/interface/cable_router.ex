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
        compile(path, @get, handler, func)
    end

    defmacro post(path, handler, func) do
        compile(path, @post, handler, func)
    end

    defmacro put(path, handler, func) do
        compile(path, @put, handler, func)
    end

    defmacro delete(path, handler, func) do
        compile(path, @delete, handler, func)
    end

    defp compile(path, method, handler, func) do

        path = path 
        |> String.split("/") 
        |> Enum.filter(fn (s) -> s != "" end)

        quote bind_quoted: [method: method, path: path, handler: handler, func: func] do
            def match(unquote(method), unquote(path), request) do
                unquote(handler).unquote(:"#{func}")(request)
            end
        end
        
    end

end