# Server Timing Response Headers for Elixir / Phoenix

Bring Phoenix server-side performance metrics 📈 to Chrome's Developer Tools (and other browsers that support the [Server Timing API](https://w3c.github.io/server-timing/)) via the `plug_server_timing` package. 

Metrics are collected from the [scout_apm](https://github.com/scoutapp/scout_apm_elixir) package. A [Scout](https://scoutapp.com) account is not required.

![image](https://user-images.githubusercontent.com/1430443/37060338-947833d2-2155-11e8-82c8-aaf6d1a9d8cb.png)

## Browser Support

- Chrome 65+ (Chrome 64 uses an [old format](https://github.com/scoutapp/ruby_server_timing/issues/5#issuecomment-370504687) of the server timing headers. This isn't supported by the gem).
- Firefox 59+
- Opera 52+

## Installation

To install and use PlugServerTiming, add it as a dependency in your Mixfile:

```diff
# mix.exs
  def deps do
    [
      # ...
+     {:plug_server_timing, "~> 0.0.1"}
    ]
  end
```

## Instrumentation

Add Scout instrumentation to your Plug pipeline or Phoenix web module and Router:

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

# lib/my_app_web/router.ex
defmodule MyAppWeb.Router do
  pipeline :browser do
    # ...
+   plug PlugServerTiming.Plug
  end
end
```

### Ecto

If you'd like to include Ecto metrics, add `ScoutApm.Instruments.EctoLogger` to your Repo's loggers:

```diff
# config/dev.exs
+config :my_app, MyApp.Repo,
+ loggers: [{Ecto.LogEntry, :log, []}, {ScoutApm.Instruments.EctoLogger, :log, []}]
```

### Template Rendering

To include Phoenix template rendering metrics, add the following your config:

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

## Overhead

The `scout_apm` package, a dependency of `plug_server_timing`, applies low overhead instrumentation designed for production use.

## Thanks!

Special thank you goes to [@OleMchls](https://github.com/OleMchls) for writing up https://blog.dnsimple.com/2018/02/server-timing-with-phoenix/ and inspiring this package 💖

[Documentation](https://hexdocs.pm/plug_server_timing).
