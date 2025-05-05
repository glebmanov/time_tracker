defmodule TimeTracker.TimeFormatter do
  @spec format(integer()) :: String.t()
  def format(seconds) when is_integer(seconds) and seconds >= 0 do
    hours = div(seconds, 3600)
    minutes = div(rem(seconds, 3600), 60)
    secs = rem(seconds, 60)

    Enum.map([hours, minutes, secs], &pad/1)
    |> Enum.join(":")
  end

  defp pad(unit) when unit < 10, do: "0#{unit}"
  defp pad(unit), do: Integer.to_string(unit)
end
