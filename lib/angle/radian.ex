defmodule Angle.Radian do
  import Angle.Utils, only: [string_to_number: 1]

  @moduledoc """
  Functions relating to dealing with angles in Radians.
  """

  @two_pi 2 * :math.pi()

  @doc """
  Initialize an Angle from a number `n` of radians

  ## Examples

      iex> init(13)
      #Angle<13㎭>

      iex> init(13.2)
      #Angle<13.2㎭>

      iex> init(0)
      #Angle<0>

      iex> init(0.0)
      #Angle<0>
  """
  @spec init(number) :: Angle.t()
  def init(n) when n == 0, do: Angle.zero()
  def init(n) when is_number(n), do: %Angle{r: n}

  @doc """
  Attempt to parse decimal radians.

  ## Examples

      iex> "13" |> parse() |> inspect()
      "{:ok, #Angle<13㎭>}"

      iex> "13.2" |> parse() |> inspect()
      "{:ok, #Angle<13.2㎭>}"

      iex> "13㎭" |> parse() |> inspect()
      "{:ok, #Angle<13㎭>}"

      iex> "13.2㎭" |> parse() |> inspect()
      "{:ok, #Angle<13.2㎭>}"

      iex> "-13.2㎭" |> parse() |> inspect()
      "{:ok, #Angle<-13.2㎭>}"
  """
  @spec parse(String.t()) :: {:ok, Angle.t()} | {:error, term}
  def parse(value) do
    case Regex.run(~r/^-?[0-9]+(?:\.[0-9]+)?/, value) do
      [value] ->
        case string_to_number(value) do
          {:ok, n} -> {:ok, init(n)}
          {:error, _} -> {:error, "Unable to parse value as radians"}
        end

      _ ->
        {:error, "Unable to parse value as radians"}
    end
  end

  @doc """
  Ensure that a radian representation is present for this angle, otherwise
  calculate one.

  ## Examples

      iex> ~a(90)d
      ...> |> ensure()
      ...> |> Map.get(:r)
      1.5707963267948966

      iex> ~a(76.3944)g
      ...> |> ensure()
      ...> |> Map.get(:r)
      1.2000004290770006

      iex> ~a(90,0,0)dms
      ...> |> ensure()
      ...> |> Map.get(:r)
      1.5707963267948966
  """
  @spec ensure(Angle.t()) :: Angle.t()
  def ensure(%Angle{r: radians} = angle) when is_number(radians), do: angle

  def ensure(%Angle{d: degrees} = angle) when is_number(degrees) do
    radians = degrees / 180.0 * :math.pi()
    %{angle | r: radians}
  end

  def ensure(%Angle{g: gradians} = angle) when is_number(gradians) do
    radians = gradians * :math.pi() / 200
    %{angle | r: radians}
  end

  def ensure(%Angle{dms: {d, m, s}} = angle)
      when is_integer(d) and is_integer(m) and is_number(s) do
    degrees = d + m / 60.0 + s / 3600.0
    radians = degrees / 180.0 * :math.pi()
    %{angle | r: radians}
  end

  @doc """
  Return the radians representation of the Angle.

  ## Examples

      iex> ~a(90)d
      ...> |> to_radians()
      ...> |> inspect()
      "{#Angle<90°>, 1.5707963267948966}"
  """
  @spec to_radians(Angle.t()) :: {Angle.t(), number}
  def to_radians(%Angle{r: number} = angle) when is_number(number), do: {angle, number}

  def to_radians(angle) do
    angle
    |> ensure()
    |> to_radians()
  end

  @doc """
  Convert the angle to it's absolute value by discarding complete revolutions
  and converting negatives.

  ## Examples

      iex> ~a(-4.71238898038469)r
      ...> |> Angle.Radian.abs()
      #Angle<1.5707963267948966㎭>

      iex> ~a(20.420352248333657)r
      ...> |> Angle.Radian.abs()
      #Angle<1.5707963267948983㎭>
  """
  @spec abs(Angle.t()) :: Angle.t()
  def abs(%Angle{r: r}), do: init(calculate_abs(r))

  defp calculate_abs(r) when r >= 0 and r <= @two_pi, do: r
  defp calculate_abs(r) when r > @two_pi, do: calculate_abs(r - @two_pi)
  defp calculate_abs(r) when r < 0, do: calculate_abs(r + @two_pi)
end
