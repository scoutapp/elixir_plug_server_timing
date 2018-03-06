defmodule PlugServerTiming.EctoLogger do
  def log(entry) do
    escaped_query = String.replace(entry.query, ~s("), ~s(\\"))
    description = ~s("#{escaped_query}")

    if entry.queue_time do
      time = convert_time_to_milliseconds(entry.queue_time)
      PlugServerTiming.record_metric("ecto_queue", description, time)
    end

    if entry.decode_time do
      time = convert_time_to_milliseconds(entry.decode_time)
      PlugServerTiming.record_metric("ecto_decode", description, time)
    end

    time = convert_time_to_milliseconds(entry.query_time)
    PlugServerTiming.record_metric("ecto_query", description, time)

    entry
  end

  defp convert_time_to_milliseconds(time) do
    System.convert_time_unit(time, :native, :millisecond)
  end
end
