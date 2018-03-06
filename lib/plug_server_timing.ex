defmodule PlugServerTiming do
  def record_metric(name, description, time) do
    metrics = Process.get(:plug_server_timing_metrics, [])
    Process.put(:plug_server_timing_metrics, [{name, description, time} | metrics])
  end

  def retrieve_and_clear_metrics do
    case Process.delete(:plug_server_timing_metrics) do
      metrics when is_list(metrics) ->
        metrics

      _ ->
        []
    end
  end
end
