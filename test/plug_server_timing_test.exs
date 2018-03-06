defmodule PlugServerTimingTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest PlugServerTiming

  defp call(conn, opts) do
    PlugServerTiming.call(conn, PlugServerTiming.init(opts))
  end

  test "sets server-timing header" do
    conn =
      call(conn(:get, "/"), [])
      |> send_resp(200, "")

    [timing] = get_resp_header(conn, "server-timing")

    assert Regex.match?(~r/total;dur=\d+/, timing)
  end
end
