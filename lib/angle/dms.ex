defmodule Angle.DMS do
  import Angle.Utils, only: [string_to_integer: 1, string_to_number: 1]
  alias Angle.Degree
  @moduledoc """
  Functions relating to dealing with angles in Degrees, Minutes and Seconds.
  """

  @parser ~r/(-?[0-9]+)
             (?:[\x{00b0},\ ]?\ *)
             ([0-9]+)
             (?:[\x{2032}',\ ]?\ *)
             ([0-9]+(?:\.[0-9]+)?)
             [\x{2033}"]?/ux

  @doc """
  Initialize an Angle from integer `d` degrees.

  ## Examples

      iex> init(13)
      #Angle<13°>
  """
  @spec init(integer) :: Angle.t
  def init(d) when is_integer(d), do: %Angle{dms: {d, 0, 0}}

  @doc """
  Initialize an Angle from integer `d` degrees, optionally followed by integer
  `m` minutes.

  ## Examples

      iex> init(13, 30)
      #Angle<13° 30′>
  """
  @spec init(integer, integer) :: Angle.t
  def init(d, m) when is_integer(d) and is_integer(m), do: %Angle{dms: {d, m, 0}}

  @doc """
  Initialize an Angle from integer `d` degrees, followed by integer
  `m` minutes and `s` seconds.

  ## Examples

      iex> init(13, 30, 45)
      #Angle<13° 30′ 45″>
  """
  @spec init(integer, integer, number) :: Angle.t
  def init(d, m, s) when is_integer(d) and is_integer(m) and is_number(s), do: %Angle{dms: {d, m, s}}

  @doc """
  Attempt to parse a string of degrees, minutes and seconds.

  ## Examples

      iex> "166 45 58.46" |> parse() |> inspect()
      "{:ok, #Angle<166° 45′ 58.46″>}"

      iex> "166,45,58.46" |> parse() |> inspect()
      "{:ok, #Angle<166° 45′ 58.46″>}"

      iex> "166° 45′ 58.46″" |> parse() |> inspect()
      "{:ok, #Angle<166° 45′ 58.46″>}"

      iex> "166°45′58.46″" |> parse() |> inspect()
      "{:ok, #Angle<166° 45′ 58.46″>}"

      iex> "-166° 45′ 58.46″" |> parse() |> inspect()
      "{:ok, #Angle<-166° 45′ 58.46″>}"
  """
  @spec parse(String.t) :: {:ok, Angle.t} | {:error, term}
  def parse(value) do
    case Regex.run(@parser, value) do
      [_, d, m, s] ->
        with {:ok, d} <- string_to_integer(d),
             {:ok, m} <- string_to_integer(m),
             {:ok, s} <- string_to_number(s)
        do
          {:ok, init(d, m, s)}
        end
      _ -> {:error, "Unable to parse value as DMS"}
    end
  end

  @doc """
  Ensure that a DMS representation is present for this angle, otherwise
  calculate one.

  ## Examples

      iex> ~a(90.5)d
      ...> |> ensure()
      ...> |> Map.get(:dms)
      {90, 30, 0.0}

      iex> ~a(166.7662400)d
      ...> |> ensure()
      ...> |> Map.get(:dms)
      {166, 45, 58.464000000037686}

      iex> ~a(1.579522973054868)r
      ...> |> ensure()
      ...> |> Map.get(:dms)
      {90, 30, 0.0}

      iex> ~a(100.55555555555556)g
      ...> |> ensure()
      ...> |> Map.get(:dms)
      {90, 30, 0.0}
  """
  @spec ensure(Angle.t) :: Angle.t
  def ensure(%Angle{dms: {d, m, s}} = angle)
  when is_integer(d) and is_integer(m) and is_number(s), do: angle

  def ensure(%Angle{d: real_degrees} = angle) when is_number(real_degrees) do
    d = trunc(real_degrees)
    fractional_part = real_degrees - d
    real_minutes = fractional_part * 60
    m = trunc(real_minutes)
    s = (real_minutes - m) * 60
    %{angle | dms: {d, m, s}}
  end

  def ensure(%Angle{} = angle) do
    angle
    |> Degree.ensure()
    |> ensure()
  end

  @doc """
  Returns the DMS representation of the Angle.

  ## Examples

      iex> ~a(0.5)r
      ...> |> to_dms()
      ...> |> inspect()
      "{#Angle<28.64788975654116°>, {28, 38, 52.403123548181156}}"
  """
  @spec to_dms(Angle.t) :: {Angle.t, {integer, integer, number}}
  def to_dms(%Angle{dms: {d, m, s}} = angle), do: {angle, {d, m, s}}
  def to_dms(%Angle{} = angle), do: angle |> ensure() |> to_dms()

  @doc """
  Convert the angle to it's absolute value by discarding complete revolutions
  and converting negatives.

  ## Examples

      iex> ~a(-270,15,45)dms
      ...> |> Angle.DMS.abs()
      #Angle<90° 45′ 15″>

      iex> ~a(1170,0,0)dms
      ...> |> Angle.DMS.abs()
      #Angle<90°>
  """
  @spec abs(Angle.t) :: Angle.t
  def abs(%Angle{dms: {d, m, s}}), do: %Angle{dms: calculate_abs(d, m, s)}

  defp calculate_abs(d, m, s) when d >= 0 and d <= 360, do: {d, m, s}
  defp calculate_abs(d, m, s) when d > 360, do: calculate_abs(d - 360, m, s)
  defp calculate_abs(d, m, s) when d < -360, do: calculate_abs(d + 360, m, s)
  defp calculate_abs(d, m, s) when d < 0, do: calculate_abs(d + 360, 60 - m, 60 - s)
end
