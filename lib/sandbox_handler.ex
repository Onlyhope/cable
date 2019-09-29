defmodule Sandbox.Handler do
    
    def process_path(request) do
        IO.puts "Processing path's request... #{inspect request}"
    end

    def process_users(request) do
        IO.puts "Processing user's request... #{inspect request}"
    end

end