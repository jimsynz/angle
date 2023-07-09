defmodule Angle.Sigil do
  alias Angle
  alias Angle.{Degree, DMS, Gradian, InvalidAngle, Radian}

  @moduledoc """
  This module defines the `~a` macros.  To use it just `use Angle`.
  """

  @doc """
  Defines a `~a` shortcut for inputting angles.

  ## Examples

  Creating an Angle from degrees:

      iex> use Angle
      ...> ~a(13.2)d
      #Angle<13.2°>

      iex> use Angle
      ...> ~a(13)d
      #Angle<13°>

  Creating an Angle from radians:

      iex> use Angle
      ...> ~a(0.25)r
      #Angle<0.25㎭>

      iex> use Angle
      ...> ~a(13)r
      #Angle<13㎭>

  An angle of zero is the same in both degrees and radians do doesn't need a modifier

      iex> use Angle
      ...> ~a(0)
      #Angle<0>
  """
  @spec sigil_a(String.t(), list) :: Angle.t()
  def sigil_a("0", _modifiers), do: Angle.zero()

  def sigil_a(value, ~c"d") do
    case Degree.parse(value) do
      {:ok, angle} -> angle
      {:error, msg} -> raise InvalidAngle, message: msg
    end
  end

  def sigil_a(value, ~c"r") do
    case Radian.parse(value) do
      {:ok, angle} -> angle
      {:error, msg} -> raise InvalidAngle, message: msg
    end
  end

  def sigil_a(value, ~c"g") do
    case Gradian.parse(value) do
      {:ok, angle} -> angle
      {:error, msg} -> raise InvalidAngle, message: msg
    end
  end

  def sigil_a(value, ~c"dms") do
    case DMS.parse(value) do
      {:ok, angle} -> angle
      {:error, msg} -> raise InvalidAngle, message: msg
    end
  end

  def sigil_a(_value, _modifier) do
    raise InvalidAngle, message: "Unable to parse angle"
  end
end
