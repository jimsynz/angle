defmodule Angle.Gradian do
  import Angle.Utils, only: [string_to_number: 1]
  alias Angle.Degree
  @moduledoc """
  Functions relating to dealing with angles in Gradians.
  """

  @doc """
  Initialize an Angle from a number `n` of gradians

  ## Examples

      iex> init(13)
      #Angle<13ᵍ>

      iex> init(13.2)
      #Angle<13.2ᵍ>
  """
  @spec init(number) :: Angle.t
  def init(0), do: Angle.zero()
  def init(n) when is_number(n), do: %Angle{g: n}

  @doc """
  Attempt to arse decimal gradians.

  ## Examples

      iex> "13" |> parse() |> inspect()
      "{:ok, #Angle<13ᵍ>}"

      iex> "13.2" |> parse() |> inspect()
      "{:ok, #Angle<13.2ᵍ>}"

      iex> "13ᵍ" |> parse() |> inspect()
      "{:ok, #Angle<13ᵍ>}"

      iex> "13.2ᵍ" |> parse() |> inspect()
      "{:ok, #Angle<13.2ᵍ>}"
  """
  @spec parse(String.t) :: {:ok, Angle.t} | {:error, term}
  def parse(value) do
    case Regex.run(~r/^[0-9]+(?:\.[0-9]+)?/, value) do
      [value] ->
        case string_to_number(value) do
          {:ok, n} -> {:ok, init(n)}
          {:error, _} -> {:error, "Unable to parse value as gradians"}
        end
      _ ->
        {:error, "Unable to parse value as gradians"}
    end
  end

  @doc """
  Ensure that a gradian representation is present for this angle, otherwise
  calculate one.

  ## Examples

      iex> ~a(90)d
      ...> |> ensure()
      ...> |> Map.get(:g)
      100.0

      iex> ~a(1)r
      ...> |> ensure()
      ...> |> Map.get(:g)
      63.66197723675813

      iex> ~a(90 0 0)dms
      ...> |> ensure()
      ...> |> Map.get(:g)
      100.0
  """
  @spec ensure(Angle.t) :: Angle.t
  def ensure(%Angle{g: gradians} = angle) when is_number(gradians), do: angle

  def ensure(%Angle{r: radians} = angle) when is_number(radians) do
    gradians = radians * 200.0 / :math.pi()
    %{angle | g: gradians}
  end

  def ensure(%Angle{d: degrees} = angle) when is_number(degrees) do
    gradians = degrees / 360.0 * 400.0
    %{angle | g: gradians}
  end

  def ensure(%Angle{dms: {_, _, _}} = angle) do
    angle
    |> Degree.ensure()
    |> ensure()
  end

  @doc """
  Return the gradians representation of the Angle.

  ## Examples

      iex> use Angle
      ...> ~a(0.5)r
      ...> |> to_gradians()
      ...> |> inspect()
      "{#Angle<0.5㎭>, 31.830988618379067}"
  """
  @spec to_gradians(Angle.t) :: {Angle.t, number}
  def to_gradians(%Angle{g: number} = angle) when is_number(number), do: {angle, number}
  def to_gradians(angle) do
    angle
    |> ensure()
    |> to_gradians()
  end

end
