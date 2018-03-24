# Server Timing Response Headers for Elixir / Phoenix

Bring Phoenix server-side performance metrics 📈 to Chrome's Developer Tools (and other browsers that support the [Server Timing API](https://w3c.github.io/server-timing/)) via the `plug_server_timing` package. Production Safe™.

Metrics are collected from the [scout_apm](https://github.com/scoutapp/scout_apm_elixir) package. A [Scout](https://scoutapp.com) account is not required.

![image](https://s3-us-west-1.amazonaws.com/scout-blog/elixir_server_timing.png)

## Browser Support

- Chrome 65+ (Chrome 64 uses an [old format](https://github.com/scoutapp/ruby_server_timing/issues/5#issuecomment-370504687) of the server timing headers. This isn't supported by the gem).
- Firefox 59+
- Opera 52+

## Installation

To install and use `PlugServerTiming`, add it as a dependency in your Mixfile:

```diff
# mix.exs
  def deps do
    [
      # ...
+     {:plug_server_timing, "~> 0.0.2"}
    ]
  end
```

Add `PlugServerTiming.Plug` to your Plug pipeline: 

```diff
# lib/my_app_web/router.ex
defmodule MyAppWeb.Router do
  pipeline :browser do
    # ...
+   plug PlugServerTiming.Plug
  end
end
```

Whoa! We're not done yet ... we need to instrument our app's function calls.

## Instrumentation

Performance metrics are collected via the `scout_apm` gem, which requires a couple of steps to instrument your app.

__Instrument controllers:__

```diff
# lib/my_app_web.ex
defmodule MyAppWeb do
  # ...
  def controller do
    quote do
      use Phoenix.Controller, namespace: MyAppWeb
+     use ScoutApm.Instrumentation
      # ...
    end
  end
end
```

__Instrument Ecto queries:__

```diff
# config/dev.exs
+config :my_app, MyApp.Repo,
+ loggers: [{Ecto.LogEntry, :log, []}, {ScoutApm.Instruments.EctoLogger, :log, []}]
```

__Instrument templates:__

```diff
# config/dev.exs
+config :phoenix, :template_engines,
+ eex: ScoutApm.Instruments.EExEngine,
+ exs: ScoutApm.Instruments.ExsEngine
```

### Additional instrumentation

To instrument HTTPoison, MongoDB Ecto, and more see the [Scout docs](http://help.apm.scoutapp.com/#instrumenting-common-libraries).

### Custom instrumentation

Collect performance data on additional function calls by adding custom instrumentation via `scout_apm`. [See the docs for instructions](http://help.apm.scoutapp.com/#elixir-custom-instrumentation).

## Security

If you'd like to conditionally include Server-Timing headers depending on authorization, the Plug can be included in a `Plug.Builder` pipeline or you can directly use `PlugServerTiming.Plug.register_before_send_headers/1` in an existing `Plug`.

```elixir

defmodule MyExistingAuthPlug do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case AuthModule.verify_auth(conn) do
      {:ok, :admin} ->
        PlugServerTiming.Plug.register_before_send_headers(conn)
      {:ok, :user} ->
        conn
      {:error, _} ->
        conn
        |> put_status(:unauthorized)
        |> halt()
    end
  end
end
```

## Overhead

The `scout_apm` package, a dependency of `plug_server_timing`, applies low overhead instrumentation designed for production use.

## Thanks!

Special thank you goes to [@OleMchls](https://github.com/OleMchls) for writing up https://blog.dnsimple.com/2018/02/server-timing-with-phoenix/ and inspiring this package 💖

[Documentation on HexDocs](https://hexdocs.pm/plug_server_timing).
