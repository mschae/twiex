defmodule Twiex.Receiver do
  def loop(total_chunk \\ "") do
    receive do
      message -> handle(message, total_chunk)
    end
  end

  def handle(%HTTPoison.AsyncStatus{ code: _code, id: _id }, _), do: loop
  def handle(%HTTPoison.AsyncHeaders{ headers: _headers, id: _id }, _), do: loop
  def handle(%HTTPoison.AsyncEnd{id: _id}, _), do: IO.puts 'the end'
  def handle(%HTTPoison.AsyncChunk{ id: _id, chunk: chunk }, total_chunk) do
    if String.ends_with?(chunk, "\n") do
      spawn Twiex.Handler, :handle, [(total_chunk <> chunk)]
      loop
    else
      loop(total_chunk <> chunk)
    end
  end

  def handle(message, _) do
    IO.puts "I received a message I don't know how to handle"
  end
end

