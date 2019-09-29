defmodule Sandbox.Handler do
    
    def process(request) do
        IO.puts "Processing request... #{inspect request}"
    end

    def match("GET", ["path"], request) do
        IO.puts "Executing GET /path ..."
        IO.puts "Processing request... #{inspect request}"
    end

end