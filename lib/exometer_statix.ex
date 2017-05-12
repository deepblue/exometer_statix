defmodule ExometerStatix do
  @moduledoc """
  Documentation for ExometerStatix.
  """
  alias ExometerStatix.Client

  @type_map [
    :gauge, ~w(gauge gauges),
    :counter, ~w(count counter counters),
    :timer, ~w(timer timers timing timings),
    :histogram, ~w(histogram histograms),
  ]
  @defalut_type :gauge

  @host "127.0.0.1"
  @port 8_125
  @prefix nil

  # @spec exometer_init(term) :: {:ok, nil} | {:error, binary}
  def exometer_init(opts) do
    init_statix(opts)

    case Client.connect() do
      :ok  -> {:ok, %{type_map: invert_type_map(@type_map)}}
      _    -> {:error, "connection failure"}
    end
  end

  @doc false
  def exometer_report(metric, datapoint, _extra, value, %{type_map: type_map} = state) do
    key = metric ++ [datapoint]
    name = Enum.join(key, ".")
    type = report_type(key, type_map)

    report(type, name, value)
    {:ok, state}
  end

  @doc false
  def exometer_subscribe(_metric, _datapoint, _interval, _opts, state) do
    {:ok, state}
  end

  @doc false
  def exometer_unsubscribe(_metric, _datapoint, _extra, state) do
    {:ok, state}
  end

  @doc false
  def exometer_call(_msg, _from, state) do
    {:ok, state}
  end

  @doc false
  def exometer_cast(_msg, state) do
    {:ok, state}
  end

  @doc false
  def exometer_info(_msg, state) do
    {:ok, state}
  end

  @doc false
  def exometer_newentry(_entry, state) do
    {:ok, state}
  end

  @doc false
  def exometer_setopts(_metric, _options, _status, state) do
    {:ok, state}
  end

  @doc false
  def exometer_terminate(_reason, _state) do
    :ignore
  end

  defp init_statix(opts) do
    Application.put_env(:statix, Client,
      host: Keyword.get(opts, :host, @host),
      port: Keyword.get(opts, :port, @port),
      prefix: ensure_string(Keyword.get(opts, :prefix, @prefix)),
    )
  end

  defp invert_type_map(type_map) do
    type_map
    |> Enum.chunk(2)
    |> Enum.map(fn([k,v]) -> Enum.map(v, fn(vv) -> {vv, k} end) end)
    |> List.flatten
    |> Enum.into(%{})
  end

  defp report_type(key, type_map) do
    case Enum.find(key, fn(k) -> type_map[ensure_string(k)] end) do
      nil -> @defalut_type
      t -> type_map[ensure_string(t)]
    end
  end

  defp report(:gauge, n, v), do: Client.gauge(n, v)
  defp report(:timer, n, v), do: Client.timing(n, v)
  defp report(:counter, n, v) when is_number(v) and v != 0, do: Client.increment(n, v)
  defp report(:histogram, n, v), do: Client.histogram(n, v)
  defp report(_, _, _), do: nil

  def ensure_string(nil), do: nil
  def ensure_string(k) when is_atom(k), do: Atom.to_string(k)
  def ensure_string(k), do: k
end
