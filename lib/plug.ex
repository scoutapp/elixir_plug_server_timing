defmodule PlugServerTiming.Plug do
  @moduledoc """
  Documentation for PlugServerTiming.
  """

  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    start = System.monotonic_time()

    register_before_send(conn, fn conn ->
      stop = System.monotonic_time()
      diff = System.convert_time_unit(stop - start, :native, :micro_seconds) / 1000

      conn
      |> add_metrics()
      |> prepend_resp_headers([{"server-timing", "total;dur=#{diff}"}])
    end)
  end

  defp add_metrics(conn) do
    timing_header_value =
      PlugServerTiming.retrieve_and_clear_metrics()
      |> Enum.reduce("", fn metric, acc ->
        "#{acc},#{metric_to_header_value(metric)}"
      end)
      |> String.trim_trailing(",")

    prepend_resp_headers(conn, [{"server-timing", timing_header_value}])
  end

  defp metric_to_header_value({name, nil, time}), do: ~s/#{name};dur=#{time}/
  defp metric_to_header_value({name, "", time}), do: ~s/#{name};dur=#{time}/

  defp metric_to_header_value({name, _description, time}) do
    # Skip showing description for now, as Chrome doesn't handle name and description, or long text well: https://github.com/ChromeDevTools/devtools-frontend/issues/64
    # ~s/#{name};desc="#{description}";dur=#{time}/
    ~s/#{name};dur=#{time}/
  end
end
