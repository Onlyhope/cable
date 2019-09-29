defmodule Cable.ConnAdapter do
    
    require Logger
    
    def dispatch(request, plug) do

        %{full_path: _full_path} = Http.read_request(request)
        |> IO.inspect
        
        %Plug.Conn{
            adapter: {Http.PlugAdapter, request},
            owner: self(),
        }
        |> plug.play([word: "abc", length: 10])

    end

    def child_spec(plug: _plug, port: port) do
        Cable.Http.child_spec(port: port)
    end
end