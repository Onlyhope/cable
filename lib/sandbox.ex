defmodule Sandbox do

    require Logger
    use Cable.Router

    def start_work(app_name) do
        
        Logger.info "Starting work..."
        
        Task.start_link(fn -> do_work(app_name) end)

        {:ok, self()}
    end

    def do_work(app_name) do

        Logger.info "#{app_name} doing work... for 2 seconds"
        :timer.sleep(2000)

        do_work(app_name)
    end

    def child_spec(opts) do
        IO.inspect opts
        [name: name] = opts
        %{
            id: __MODULE__,
            start: {__MODULE__, :start_work, [name]},
            type: :worker,
            restart: :permanent,
            shutdown: 500
        }
        # %{id: Http, start: {Http, :start_link, [opts]}}
    end

    get "path" do
        IO.puts "Executing GET /path ..."
        # TODO - Request is not defined... how do I use the request here?
        # IO.puts "Request: #{inspect request}" 
        2
    end

    def match("GET", ["foo"], _conn) do
        IO.puts "GET: /foo"
    end

    def match("GET", ["foo", "tasks"], _conn) do
        IO.puts "GET: users/tasks"
    end

    def match("GET", ["foo", "bar"], _conn) do
        IO.puts "GET: foo/bar"
    end

end