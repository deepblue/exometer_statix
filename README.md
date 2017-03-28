# exometer_statix

StatsD reporter backend for exometer_core Edit

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exometer_statix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exometer_statix, "~> 0.1.0"}]
end
```

## How to use

```elixir
prefix           = :myapp
polling_interval = 1_000
memory_stats     = ~w(atom binary ets processes total)a
reporter         = Elixir.ExometerStatix
reporter_opts    = [port: 9125, prefix: prefix]

config :exometer_core,
  predefined: [
    {~w(erlang memory)a, {:function, :erlang, :memory, [], :proplist, memory_stats}, []},
    {~w(erlang statistics)a, {:function, :erlang, :statistics, [:'$dp'], :value, [:run_queue]}, []},
  ],
  report: [
    reporters: [{reporter, reporter_opts}],
    subscribers: [
      {reporter, [:erlang, :memory], memory_stats, polling_interval, true},
      {reporter, [:erlang, :statistics], :run_queue, polling_interval, true},
    ]
  ]

config :elixometer,
  reporter: reporter,
  update_frequency: polling_interval,
  env: Mix.env,
  metric_prefix: prefix
````

### Logger setting

Exometer depends on lager. To unify logging in a elixir project, you can use [lagger_logger](https://github.com/PSPDFKit-labs/lager_logger) or [logger_lager_backend](https://github.com/jonathanperret/logger_lager_backend)

```elixir
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :application, :module, :function, :file, :line]

config :lager, :error_logger_redirect, false
config :lager, :error_logger_whitelist, [Logger.ErrorHandler]
config :lager, :crash_log, false
config :lager, :handlers, [{LagerLogger, [level: :info]}]
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exometer_statix](https://hexdocs.pm/exometer_statix).

