defmodule Two48.Cli do
  alias Two48.Game

  def main(_args) do
    {:ok, game} = Game.start_link
    loop(game)
  end

  defp loop(game) do
    game
    |> render
    |> move
    |> loop
  end

  defp render(game) do
    Game.state(game) |> IO.inspect
    game
  end

  defp move(game) do
    dir = IO.gets("Direction? ")
          |> String.strip
          |> direction

    {:ok, _} = Game.move(game, dir)
    game
  end

  def direction("w"), do: :up
  def direction("a"), do: :left
  def direction("s"), do: :down
  def direction("d"), do: :right

  def direction(input), do: String.to_atom(input)
end
