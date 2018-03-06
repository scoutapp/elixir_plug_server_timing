# PlugServerTiming

[Documentation](https://hexdocs.pm/plug_server_timing).

PlugServerTiming is a set of utilities to include the [Server Timing header](https://w3c.github.io/server-timing/) in your Plug-based application. It also includes instrumentation for [Phoenix](https://hex.pm/phoenix) templates and [Ecto](https://hex.pm/ecto) queries.

## Installation

To install and use PlugServerTiming, add it as a dependency to your application in your Mixfile:

```elixir
def deps do
  [
    {:plug_server_timing, "~> 0.0.1"}
  ]
end
```

If you're using Phoenix or another Plug-based application, PlugServerTiming can be added to your router pipeline:

```diff
# lib/my_app_web/router.ex
defmodule MyAppWeb.Router do
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
+   plug PlugServerTiming.Plug
  end

  # ...
end
```

It will then include the server-timing header for how long it takes the app to send a response. Chrome should show something like this:


If you'd like to include timings for rendering Phoenix templates, add the `PlugServerTiming.PhoenixInstrumenter` to your Endpoint's instrumenters:

```elixir
# config/dev.exs

config :phoenix, MyAppWeb.Endpoint
  instrumenters: [PlugServerTiming.PhoenixInstrumenter]
```

If you'd like to include Ecto metrics for queuing, querying and decoding, the `PlugServerTiming.EctoLogger` can be added as well:


```elixir
# config/dev.exs
config :my_app, MyApp.Repo,
  loggers: [{Ecto.LogEntry, :log, []}, {PlugServerTiming.EctoLogger, :log, []}]
```

With those included, Chrome server timing should look something like this:

