defmodule Sandbox.Interface do

    defmacro __using__(_opts) do
        quote do
            import unquote(__MODULE__)
            var!(conn) = "start"
        end
    end

    defmacro sandbox(val, clauses) do

        [do: action] = clauses
        IO.inspect action
        
        quote bind_quoted: [val: val, action: action] do
            var!(conn) = val
            def unquote(:"test_#{val}")() do
                unquote(action)
            end

        end
    end
    
end