defmodule PlugServerTiming.Plug do
  @moduledoc """
  Documentation for PlugServerTiming.
  """

  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    register_before_send_headers(conn)
  end

  def register_before_send_headers(conn) do
    register_before_send(conn, &add_metrics_header_from_scout/1)
  end

  defp add_metrics_header_from_scout(conn) do
    server_timing = generate_metrics_header(ScoutApm.DirectAnalysisStore.payload())
    put_resp_header(conn, "server-timing", server_timing)
  end

  def generate_metrics_header(%{total_call_time: total_time} = payload) do
    inner_metrics =
      payload
      |> Map.get(:metrics)
      |> Enum.filter(fn metric ->
        get_in(metric, [:key, :name]) == "all"
      end)
      |> Enum.reduce("", fn metric, acc ->
        bucket = get_in(metric, [:key, :bucket])

        total_call_time =
          Map.get(metric, :total_exclusive_time)
          |> Kernel.*(1000)

        "#{acc}#{metric_to_header_value({bucket, nil, total_call_time})},"
      end)

    "#{inner_metrics}total;dur=#{total_time * 1000}"
  end

  def generate_metrics_header(_payload), do: ""

  defp metric_to_header_value({name, nil, time}), do: ~s/#{name};dur=#{time}/
  defp metric_to_header_value({name, "", time}), do: ~s/#{name};dur=#{time}/

  defp metric_to_header_value({name, _description, time}) do
    # Skip showing description for now, as Chrome doesn't handle name and description, or long text well: https://github.com/ChromeDevTools/devtools-frontend/issues/64
    # ~s/#{name};desc="#{description}";dur=#{time}/
    ~s/#{name};dur=#{time}/
  end
end
