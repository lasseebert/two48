defmodule Two48.Cli do
  alias Two48.Game

  def main(_args) do
    {:ok, game} = Game.start_link
    Port.open({:spawn, "tty_sl -c -e"}, [:binary, :eof])

    # Seed random on start
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a, b, c)

    loop(game)
  end

  defp loop(game) do
    IO.write [
      clear_screen,
      render(game)
    ]
    move(game)
    loop(game)
  end

  defp clear_screen do
    [
      IO.ANSI.home,
      IO.ANSI.clear
    ]
  end

  defp render(game) do
    Game.state(game) |> inspect
  end

  defp move(game) do
    receive do
      {_port, {:data, data}} ->
        data
        |> translate
        |> handle_key(game)
        :ok
      _ ->
        :ok
    end
  end

  defp translate("\e[A"), do: :up
  defp translate("\e[B"), do: :down
  defp translate("\e[C"), do: :right
  defp translate("\e[D"), do: :left
  defp translate(_other), do: nil

  defp handle_key(nil, _), do: :ok
  defp handle_key(key, game) do
    Game.move(game, key)
  end
end
