defmodule Angle.Degree do
  import Angle.Utils, only: [string_to_number: 1]
  @moduledoc """
  Functions relating to dealing with angles in real Degrees.
  """

  @doc """
  Initialize an Angle from a number `n` of degrees

  ## Examples

      iex> init(13)
      #Angle<13°>

      iex> init(13.2)
      #Angle<13.2°>
  """
  @spec init(number) :: Angle.t
  def init(0), do: Angle.zero()
  def init(n) when is_number(n), do: %Angle{d: n}

  @doc """
  Attempt to parse decimal degrees.

  ## Examples

      iex> "13" |> parse() |> inspect()
      "{:ok, #Angle<13°>}"

      iex> "13.2" |> parse() |> inspect()
      "{:ok, #Angle<13.2°>}"

      iex> "13°" |> parse() |> inspect()
      "{:ok, #Angle<13°>}"

      iex> "13.2°" |> parse() |> inspect()
      "{:ok, #Angle<13.2°>}"

      iex> "-13.2°" |> parse() |> inspect()
      "{:ok, #Angle<-13.2°>}"
  """
  @spec parse(String.t) :: {:ok, Angle.t} | {:error, term}
  def parse(value) do
    case Regex.run(~r/^-?[0-9]+(?:\.[0-9]+)?/, value) do
      [value] ->
        case string_to_number(value) do
          {:ok, n} -> {:ok, init(n)}
          {:error, _} -> {:error, "Unable to parse value as degrees"}
        end
      _ ->
        {:error, "Unable to parse value as degrees"}
    end
  end

  @doc """
  Ensure that a degree representation is present for this angle, otherwise
  calculate one.

  ## Examples

      iex> ~a(0.5)r
      ...> |> ensure()
      ...> |> Map.get(:d)
      28.64788975654116

      iex> ~a(76.3944)g
      ...> |> ensure()
      ...> |> Map.get(:d)
      68.75496000000001

      iex> ~a(77 50 56)dms
      ...> |> ensure()
      ...> |> Map.get(:d)
      77.84888888888888
  """
  @spec ensure(Angle.t) :: Angle.t
  def ensure(%Angle{d: degrees} = angle) when is_number(degrees), do: angle

  def ensure(%Angle{r: radians} = angle) when is_number(radians) do
    degrees = radians * 180.0 / :math.pi()
    %{angle | d: degrees}
  end

  def ensure(%Angle{g: gradains} = angle) when is_number(gradains) do
    degrees = gradains / 400.0 * 360.0
    %{angle | d: degrees}
  end

  def ensure(%Angle{dms: {d, m, s}} = angle) when is_integer(d) and is_integer(m) and is_number(s) do
    %{angle | d: d + (m / 60.0) + (s / 3600.0)}
  end

  @doc """
  Return the degrees representation of the Angle.

  ## Examples

      iex> ~a(0.5)r
      ...> |> to_degrees()
      ...> |> inspect()
      "{#Angle<28.64788975654116°>, 28.64788975654116}"
  """
  @spec to_degrees(Angle.t) :: {Angle.t, number}
  def to_degrees(%Angle{d: number} = angle) when is_number(number), do: {angle, number}
  def to_degrees(angle), do: angle |> ensure() |> to_degrees()

  @doc """
  Convert the angle to it's absolute value by discarding complete revolutions
  and converting negatives.

  ## Examples

      iex> ~a(-270)d
      ...> |> Angle.Degree.abs()
      #Angle<90°>

      iex> ~a(1170)d
      ...> |> Angle.Degree.abs()
      #Angle<90°>
  """
  @spec abs(Angle.t) :: Angle.t
  def abs(%Angle{d: d}), do: init(calculate_abs(d))

  defp calculate_abs(d) when d >= 0 and d <= 360, do: d
  defp calculate_abs(d) when d > 360, do: calculate_abs(d - 360)
  defp calculate_abs(d) when d < 0, do: calculate_abs(d + 360)
end
