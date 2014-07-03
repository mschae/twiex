defmodule Twiex.Receiver do
  def handle( chunk ) do
    IO.puts "---"
    IO.puts chunk
    IO.puts "---"

    if is_bitstring(chunk) do
      IO.puts 'bistring'
    else
      IO.puts 'no bitstring'
    end


    {:ok, map} = JSEX.decode chunk

    IO.puts 'ok'
  end
end
