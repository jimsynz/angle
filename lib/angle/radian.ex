defmodule Angle.Radian do
  import Angle.Utils, only: [string_to_number: 1]
  @moduledoc """
  Functions relating to dealing with angles in Radians.
  """

  @doc """
  Initialize an Angle from a number `n` of radians

  ## Examples

      iex> init(13)
      #Angle<13㎭>

      iex> init(13.2)
      #Angle<13.2㎭>
  """
  @spec init(number) :: Angle.t
  def init(0), do: Angle.zero()
  def init(n) when is_number(n), do: %Angle{r: n}

  @doc """
  Attempt to arse decimal radians.

  ## Examples

      iex> "13" |> parse() |> inspect()
      "{:ok, #Angle<13㎭>}"

      iex> "13.2" |> parse() |> inspect()
      "{:ok, #Angle<13.2㎭>}"

      iex> "13㎭" |> parse() |> inspect()
      "{:ok, #Angle<13㎭>}"

      iex> "13.2㎭" |> parse() |> inspect()
      "{:ok, #Angle<13.2㎭>}"
  """
  @spec parse(String.t) :: {:ok, Angle.t} | {:error, term}
  def parse(value) do
    case Regex.run(~r/^[0-9]+(?:\.[0-9]+)?/, value) do
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
  @spec ensure(Angle.t) :: Angle.t
  def ensure(%Angle{r: radians} = angle) when is_number(radians), do: angle

  def ensure(%Angle{d: degrees} = angle) when is_number(degrees) do
    radians = degrees / 180.0 * :math.pi()
    %{angle | r: radians}
  end

  def ensure(%Angle{g: gradians} = angle) when is_number(gradians) do
    radians = gradians * :math.pi() / 200
    %{angle | r: radians}
  end

  def ensure(%Angle{dms: {d, m, s}} = angle) when is_integer(d) and is_integer(m) and is_number(s) do
    degrees = d + (m / 60.0) + (s / 3600.0)
    radians = degrees / 180.0 * :math.pi()
    %{angle | r: radians}
  end

  @doc """
  Return the radians representation of the Angle.

  ## Examples

      iex> use Angle
      ...> ~a(90)d
      ...> |> Angle.Radian.to_radians()
      ...> |> inspect()
      "{#Angle<90°>, 1.5707963267948966}"
  """
  def to_radians(%Angle{r: number} = angle) when is_number(number), do: {angle, number}
  def to_radians(angle) do
    angle
    |> ensure()
    |> to_radians()
  end

end
