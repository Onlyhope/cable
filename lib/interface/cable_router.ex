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

    end
    
    defmacro post(code) do
        IO.puts "Hello World"
    end

end