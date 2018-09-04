defmodule Angle do
  defstruct ~w(d r g dms)a
  alias Angle.{Degree, DMS, Gradian, Radian, Trig}

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

  defdelegate degrees(n), to: Degree, as: :init
  defdelegate radians(n), to: Radian, as: :init
  defdelegate gradians(n), to: Gradian, as: :init
  defdelegate dms(d, m, s), to: DMS, as: :init

  @doc """
  Initialize and Angle with zero values

  ## Examples

        iex> Angle.zero()
        #Angle<0>
  """
  @spec zero() :: t
  def zero, do: %Angle{d: 0, r: 0, g: 0}

  defdelegate to_radians(angle), to: Radian
  defdelegate to_degrees(angle), to: Degree
  defdelegate to_gradians(angle), to: Gradian
  defdelegate to_dms(angle), to: DMS

  defdelegate acos(x), to: Trig
  defdelegate acosh(x), to: Trig
  defdelegate asin(x), to: Trig
  defdelegate asinh(x), to: Trig
  defdelegate atan(x), to: Trig
  defdelegate atan2(x, y), to: Trig
  defdelegate cos(angle), to: Trig
  defdelegate cosh(angle), to: Trig
  defdelegate sin(angle), to: Trig
  defdelegate sinh(angle), to: Trig
  defdelegate tan(angle), to: Trig
  defdelegate tanh(angle), to: Trig

  @doc """
  Convert the angle to it's absolute value by discarding complete revolutions
  and converting negatives.

  ## Examples

      iex> ~a(-270)d
      ...> |> Angle.abs()
      #Angle<90°>

      iex> ~a(-4.71238898038469)r
      ...> |> Angle.abs()
      #Angle<1.5707963267948966㎭>

      iex> ~a(-270,15,45)dms
      ...> |> Angle.abs()
      #Angle<90° 45′ 15″>

      iex> ~a(-300)g
      ...> |> Angle.abs()
      #Angle<100ᵍ>
  """
  @spec abs(Angle.t()) :: Angle.t()
  def abs(%Angle{r: r} = angle) when is_number(r), do: Radian.abs(angle)
  def abs(%Angle{d: d} = angle) when is_number(d), do: Degree.abs(angle)
  def abs(%Angle{g: g} = angle) when is_number(g), do: Gradian.abs(angle)

  def abs(%Angle{dms: {d, m, s}} = angle) when is_number(d) and is_number(m) and is_number(s),
    do: DMS.abs(angle)
end
