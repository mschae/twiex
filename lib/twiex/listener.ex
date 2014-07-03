defmodule Twiex.Listener do
  use GenServer

  @method :post
  @url    "https://stream.twitter.com/1.1/statuses/filter.json"
  @params [track: "google"]

  def params_string do
    list = @params
           |> Enum.map fn({key, value}) -> to_string(key) <> "=" <> to_string(value) end

    case Enum.count(list) do
    0 -> ""
    1 -> Enum.fetch! list, 0
    _ -> Enum.join! list, "&"
    end
  end

  def headers do
    %{
      "Authorization" => Exauth.sign_header(@method, @url, @params),
      "Content-Type"  => "application/x-www-form-urlencoded"
    }
  end

  def init(_) do
    HTTPoison.start

    loop_pid = spawn_link __MODULE__, :loop, []
    response = HTTPoison.request(
      @method,
      @url,
      params_string,
      headers,
      stream_to: loop_pid, timeout: :infinity
    )

    {:ok, []}
  end

  def loop(total_chunk \\ "") do
    receive do
      %HTTPoison.AsyncStatus{ code: code, id: _id} ->
        IO.puts code
        loop
      %HTTPoison.AsyncHeaders{ headers: _headers, id: id } ->
        IO.puts 'Received headers'
        loop
      %HTTPoison.AsyncChunk{ id: id, chunk: chunk } ->
        if String.ends_with?(chunk, "\n") do
          if JSEX.is_json?(total_chunk <> chunk) do
            case JSEX.decode(total_chunk <> chunk) do
              {:ok, hash} ->
                username = hash |> Dict.fetch!("user") |> Dict.fetch!("screen_name")
                IO.puts username <> ": " <>  Dict.fetch!(hash, "text")
              {:error, reason} ->
                IO.puts "ERROR"
                IO.puts reason
            end
          else
            IO.puts "Something's strange:"
            IO.puts chunk
          end
          loop
        else
          loop(total_chunk <> chunk)
        end
      message ->
        IO.puts 'test'
        loop
    end
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end
end
