defmodule Twiex.Listener do
  use GenServer

  @method :post
  @url    "https://stream.twitter.com/1.1/statuses/filter.json"
  @params [track: "google"]

  def params_string do
    @params
    |> Enum.map(fn({key, value}) -> {key, String.to_char_list(value)} end)
    |> :oauth.params_encode
  end

  def headers do
    %{
      "Authorization" => Exauth.sign_header(@method, @url, @params),
      "Content-Type"  => "application/x-www-form-urlencoded"
    }
  end

  def init(_) do
    HTTPoison.start

    response = HTTPoison.request(
      @method,
      @url,
      params_string,
      headers,
      stream_to: spawn_link(Twiex.Receiver, :loop, []),
      timeout: :infinity
    )

    {:ok, []}
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end
end
