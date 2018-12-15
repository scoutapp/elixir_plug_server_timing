defmodule PlugServerTimingTest do
  use ExUnit.Case, async: true
  doctest PlugServerTiming
  import PlugServerTiming.Plug, only: [generate_metrics_header: 1]

  @instrumented_payload %{
    metrics: [
      %{
        call_count: 1,
        key: %{bucket: "chicken-wings", desc: nil, extra: nil, name: "all", scope: %{}},
        max_call_time: 6.0e-6,
        min_call_time: 6.0e-6,
        sum_of_squares: 0,
        total_call_time: 6.0e-6,
        total_exclusive_time: 6.0e-6
      }
    ],
    total_call_time: 6.0e-6
  }

  describe "#generate_metrics_header/1" do
    test "with instrumented response" do
      header = generate_metrics_header(@instrumented_payload)
      assert header == "chicken-wings;dur=0.006,total;dur=0.006"
    end

    test "with an non instrumented response" do
      assert generate_metrics_header(nil) == ""
    end
  end
end
