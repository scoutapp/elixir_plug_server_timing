# PlugServerTiming

[Documentation](https://hexdocs.pm/plug_server_timing).

PlugServerTiming is a set of utilities to include the [Server Timing header](https://w3c.github.io/server-timing/) in your Plug-based application. It depends on [scout\_apm\_elixir](https://github.com/scoutapp/scout_apm_elixir) to collect metrics. A [Scout](https://scoutapp.com) account is not required.

## Installation

To install and use PlugServerTiming, add it as a dependency in your Mixfile and enable devtrace for Scout:

```diff
# mix.exs
  def deps do
    [
      # ...
+     {:plug_server_timing, "~> 0.0.1"}
    ]
  end
```

```diff
# config/dev.exs
+config :scout_apm,
+ dev_trace: true
```

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

If you'd like to include Ecto metrics, add `ScoutApm.Instruments.EctoLogger` to your Repo's loggers:


```diff
# config/dev.exs
+config :my_app, MyApp.Repo,
+ loggers: [{Ecto.LogEntry, :log, []}, {ScoutApm.Instruments.EctoLogger, :log, []}]
```

To include Phoenix template rendering metrics, add the following your config:

```diff
# config/dev.exs
+config :phoenix, :template_engines,
+ eex: ScoutApm.Instruments.EExEngine,
+ exs: ScoutApm.Instruments.ExsEngine
```

With those included, Chrome server timing should look something like this:

![image](https://user-images.githubusercontent.com/1430443/37060338-947833d2-2155-11e8-82c8-aaf6d1a9d8cb.png)

Special thank you goes to [@OleMchls](https://github.com/OleMchls) for writing up https://blog.dnsimple.com/2018/02/server-timing-with-phoenix/ and inspiring this package 💖
