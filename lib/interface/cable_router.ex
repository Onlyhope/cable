defmodule Cable.Router do
    
    defmacro get(arg1, arg2) do
        quote do: IO.puts "Arg 1"
        IO.inspect arg1
        quote do: IO.puts "Arg 2"
        IO.inspect arg2
    end
    
    defmacro post(code) do
        IO.inspect code
    end

end