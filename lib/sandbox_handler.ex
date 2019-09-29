defmodule Sandbox.Handler do
    
    def process(request) do
        IO.puts "Processing request... #{inspect request}"
    end

end