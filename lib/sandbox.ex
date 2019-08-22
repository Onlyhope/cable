defmodule Sandbox do
    
    def do_work do
        IO.puts "Doing work..."
        :timer.sleep(2000)
        IO.puts "Finish work!"
    end

    def start do
        {:ok, socket} = :gen_tcp.listen(9000,
            [:binary, packet: :http_bin, active: false, reuseaddr: true])

        IO.puts "Socket: #{inspect socket}"
        {:ok, client} = :gen_tcp.accept(socket)
        
    end

    def child_spec(opts) do
        IO.inspect opts
        %{
            id: __MODULE__,
            start: {__MODULE__, :start, []},
            type: :worker,
            restart: :permanent,
            shutdown: 500
        }
        # %{id: Http, start: {Http, :start_link, [opts]}}
    end
    
end