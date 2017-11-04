defmodule Angle do
  defstruct ~w(d r g dms)a
  @moduledoc """
  Tired of forever converting back and forwards between degrees and radians?
  Well worry no more; Angle is here to make your life simple!

  ## Magic sigils

  Angle defines the `~a` sigil so that you can create an Angle easily.

  ### Examples

  Creating an Angle from decimal degrees:

      iex> use Angle
      ...> ~a(13.2)d
      #Angle<13.2°>

  Creating an Angle from radians:

      iex> use Angle
      ...> ~a(0.25)r
      #Angle<0.25㎭>

  Creating an Angle from gradians:

      iex> use Angle
      ...> ~a(40)g
      #Angle<40ᵍ>

  Create an Angle from degrees, minutes and seconds:

      iex> use Angle
      ...> ~a(90,30,50)dms
      #Angle<90° 30′ 50″>

  ## Lazy converstion

  Most functions in Angle return a potentially modified version of the angle,
  so that if the angle needs to be converted to radians or degrees for the
  underlying function to work, then it'll only be done once.

  ### Examples

  Returning the radian representation of an angle

        iex> use Angle
        ...> ~a(13)d
        ...> |> Angle.to_radians()
        ...> |> inspect()
        "{#Angle<13°>, 0.22689280275926282}"
  """

  @type maybe_number :: nil | number
  @type t :: %Angle{r: maybe_number, d: maybe_number, g: maybe_number}

  defmacro __using__(_opts) do
    quote do
      import Angle.Sigil
      Angle
    end
  end

  defdelegate degrees(n), to: Angle.Degree, as: :init
  defdelegate radians(n), to: Angle.Radian, as: :init
  defdelegate gradians(n), to: Angle.Gradian, as: :init
  defdelegate dms(d, m, s), to: Angle.DMS, as: :init

  @doc """
  Initialize and Angle with zero values

  ## Examples

        iex> Angle.zero()
        #Angle<0>
  """
  @spec zero() :: t
  def zero, do: %Angle{d: 0, r: 0, g: 0}

  defdelegate to_radians(angle), to: Angle.Radian
  defdelegate to_degrees(angle), to: Angle.Degree
  defdelegate to_gradians(angle), to: Angle.Gradian
  defdelegate to_dms(angle), to: Angle.DMS
end
