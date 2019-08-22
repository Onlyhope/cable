defmodule CurrentTime do
    
    import Plug.Conn

    def init(options), do: options

    def call(conn, _opts) do
        conn
        |> put_resp_content_type("text/html")
        |> send_resp(200, "Hello world! The time is #{Time.utc_now |> Time.to_string}")
    end

    def play(conn, opts) do
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, "{ 'message' : 'Hello World!' }")
    end

end