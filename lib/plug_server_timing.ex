defmodule PlugServerTiming do
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
      |> prepend_resp_headers([{"server-timing", ~s|total;dur=#{diff}|}])
    end)
  end
end
