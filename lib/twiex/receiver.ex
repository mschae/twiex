defmodule Twiex.Receiver do
  def init(_) do
    receive do
      {:ok, {_, chunk, _}} -> IO.puts chunk.chunk
    end

    {:ok, []}
  end

  def start_link(opts \\ []) do
    IO.puts 'test1'
    GenServer.start_link(__MODULE__, opts)
  end
end
