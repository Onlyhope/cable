defmodule Cable.Router do

    defmacro __using__(_opts) do
        quote do
            import unquote(__MODULE__)
        end
    end
    
    defmacro get(path, clauses) do

        IO.puts "Path #{inspect path}"
        IO.inspect path

        IO.puts "Clauses #{inspect clauses}"
        IO.inspect clauses

        method_name = "get"

        quote do 
            def unquote(:"#{method_name}")() do
                IO.puts "Inside method"
            end
        end
    end
    
    defmacro post(code) do
        IO.puts "Hello World"
    end

end