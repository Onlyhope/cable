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
    
    defmacro get(path, clauses) do
        String.split(path, "/")
        |> compile(clauses, @get)
    end

    defmacro post(path, clauses) do
        String.split(path, "/")
        |> compile(clauses, @post)
    end

    defmacro put(path, clauses) do
        String.split(path, "/")
        |> compile(clauses, @put)
    end

    defmacro delete(path, clauses) do
        String.split(path, "/")
        |> compile(clauses, @delete)
    end

    defp compile(path, clauses, method) do

        [do: action] = clauses

        IO.puts "Clauses #{inspect clauses}"
        IO.inspect action

        quote do
            def match(method, path, request) do
                fn () -> unquote(action) end
            end
        end
        
    end

end