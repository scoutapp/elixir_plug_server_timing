defmodule PlugServerTiming.PhoenixInstrumenter do
  def phoenix_controller_render(:start, _compile, %{view: view, template: template}) do
    "#{view}##{template}"
    |> String.trim_leading("Elixir.")
  end

  def phoenix_controller_render(:stop, time_diff, description) do
    PlugServerTiming.record_metric(
      "template",
      description,
      convert_time_to_milliseconds(time_diff)
    )
  end

  defp convert_time_to_milliseconds(time) do
    System.convert_time_unit(time, :native, :millisecond)
  end
end
