defmodule Twiex.Handler do
  def handle(string) do
    if JSEX.is_json?(string) do
      case JSEX.decode(string) do
        {:ok, hash} ->
          username = hash |> Dict.fetch!("user") |> Dict.fetch!("screen_name")
          IO.puts username <> ": " <>  Dict.fetch!(hash, "text") <> " " <> Dict.fetch!(hash, "lang")
        {:error, reason} ->
          IO.puts "ERROR"
          IO.puts reason
      end
    else
      IO.puts 'something is wrong'
      IO.puts string
    end
  end
end
