defmodule TestHaDb do
  @moduledoc """
  Documentation for `TestHaDb`.
  """


  def info do
    errors =
    :ets.foldl(fn
      {_, {"error", result}}, acc -> [result | acc]
      _, acc -> acc
    end, [], :counter)

    IO.inspect(errors, label: "error rows")

    :ets.info(:counter) |> IO.inspect(label: "counter")

    count =
  :ets.foldl(fn
    {_, {"error", _}}, acc -> acc + 1
    _, acc -> acc
  end, 0, :counter)

    IO.inspect(count, label: "Total error rows")
  end
end
