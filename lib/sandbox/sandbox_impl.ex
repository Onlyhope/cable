defmodule Sandbox.Impl do
    
    use Sandbox.Interface

    sandbox("foo") do
        IO.inspect conn
    end

    sandbox("bar") do
        IO.inspect conn
    end

end