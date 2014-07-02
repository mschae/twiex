defmodule Twiex.Listener do
  use GenServer

  @method          :get
  @url             'https://api.twitter.com/1.1/statuses/user_timeline.json'
  @params          [screen_name: 'mschae']
  #@method          :post
  #@url             'https://stream.twitter.com/1.1/statuses/filter.json'
  #@params          [track: 'apple']
  @consumer_key    ''
  @consumer_secret ''
  @token           ''
  @token_secret    ''

  ## Server callbacks

  def sign do
    method = @method|> to_string |> String.upcase |> to_char_list
    :oauth.sign(method,
                @url,
                @params,
                {@consumer_key, @consumer_secret, :hmac_sha1},
                @token,
                @token_secret)
    |> :oauth.header_params_encode
    |> IO.chardata_to_string
  end

  def params_string do
    list = @params
           |> Enum.map fn({key, value}) -> to_string(key) <> "=" <> to_string(value) end

    if Enum.count(list) == 1 do
      Enum.fetch! list, 0
    else
      Enum.join! list, "&"
    end
  end

  def url_with_params do
    to_string(@url) <> "?" <> params_string
  end

  def init(_) do
    HTTPotion.start

    IO.puts sign

    pid = spawn __MODULE__, :loop, []

    spawn HTTPotion, @method, [url_with_params, [Authorization: "OAuth " <> sign], [stream_to: pid, timeout: :infinity]]

    {:ok, []}
  end

  def loop do
    receive do
      message ->
        handle_receive message
        loop
    end
  end

  def handle_receive(%HTTPotion.AsyncHeaders{ id: id, status_code: status_code, headers: _headers }) do
    IO.puts 'header received'
    IO.puts status_code
  end

  def handle_receive(%HTTPotion.AsyncChunk{ chunk: chunk, id: id }) do
    IO.puts chunk
  end

  def handle_receive(%HTTPotion.AsyncEnd{ id: id }) do
    IO.puts 'end received'
  end

  def start_link(opts \\ []) do
    IO.puts 'test'
    GenServer.start_link(__MODULE__, opts)
  end
end
