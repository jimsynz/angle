defmodule Angle.Trig do
  import Angle.Radian, only: [ensure: 1]

  @moduledoc """
  Wraps Erlang's `:math` module to provide versions of it's trigonomic
  functions which work with the `Angle` type.

  Erlang's `:math` module relies on your libc implementation.  Which return
  potentially different values for these functions based on the approximations
  they use.  Specifally you may see small differences between values computed
  by macOS' libc and GNU libc.  This can lead to surprising test failures; you
  most likely want to limit accuracy in tests to a few decimal places.
  """

  @doc """
  Calculate the inverse trigonometric cosine (also known as arccosine) angle
  of a real value `x` between -1 and 1.

  ## Examples:

      iex> Angle.Trig.acos(1)
      ...> |> inspect()
      "{:ok, #Angle<0.0㎭>}"

      iex> Angle.Trig.acos(-1)
      ...> |> inspect()
      "{:ok, #Angle<3.141592653589793㎭>}"
  """
  @spec acos(number) :: {:ok, Angle.t} | {:error, term}
  def acos(x) when x >= -1 and x <= 1, do: x |> :math.acos() |> r()
  def acos(_), do: {:error, "Invalid function domain"}

  @doc """
  Calculate the inverse hyperbolic cosine angle of a real value `x` between 1
  and +∞.

  ## Examples

      iex> Angle.Trig.acosh(1)
      ...> |> inspect()
      "{:ok, #Angle<0.0㎭>}"

      iex> Angle.Trig.acosh(2)
      ...> |> inspect()
      "{:ok, #Angle<1.3169578969248166㎭>}"
  """
  @spec acosh(number) :: {:ok, Angle.t} | {:error, term}
  def acosh(x) when x >= 1, do: x |> :math.acosh() |> r()
  def acosh(_), do: {:error, "Invalid function domain"}

  @doc """
  Calculate the inverse trigonometric sine (also known as arcsine) angle of a
  real value `x` between -1 and 1.

  ## Examples

      iex> Angle.Trig.asin(0)
      ...> |> inspect()
      "{:ok, #Angle<0.0㎭>}"

      iex> Angle.Trig.asin(1)
      ...> |> inspect()
      "{:ok, #Angle<1.5707963267948966㎭>}"
  """
  @spec asin(number) :: {:ok, Angle.t} | {:error, term}
  def asin(x) when x >= -1 and x <= 1, do: x |> :math.asin() |> r()
  def asin(_), do: {:error, "Invalid function domain"}

  @doc """
  Calculate the inverse hyperbolic sine angle of a real value `x`.

  ## Examples

      iex> Angle.Trig.asinh(-1)
      ...> |> inspect()
      "{:ok, #Angle<-0.881373587019543㎭>}"

      iex> Angle.Trig.asinh(1)
      ...> |> inspect()
      "{:ok, #Angle<0.881373587019543㎭>}"
  """
  @spec asinh(number) :: {:ok, Angle.t} | {:error, term}
  def asinh(x) when is_number(x), do: x |> :math.asinh() |> r()
  def asinh(_x), do: {:error, "Invalid function domain"}

  @doc """
  Calculate the inverse trigonometric tangent (also known as arctangent) angle
  of any real value `x`.

  ## Examples

      iex> Angle.Trig.atan(-1)
      ...> |> inspect()
      "{:ok, #Angle<-0.7853981633974483㎭>}"

      iex> Angle.Trig.atan(1)
      ...> |> inspect()
      "{:ok, #Angle<0.7853981633974483㎭>}"
  """
  @spec atan(number) :: {:ok, Angle.t} | {:error, term}
  def atan(x) when is_number(x), do: x |> :math.atan() |> r()
  def atan(_x), do: {:error, "Invalid function domain"}

  @doc """
  Calculate the inverse trigonometric tangent (also known as arctangent) angle
  between the positive x-axis and the coordinates `x`, `y`.

  ## Examples

      iex> Angle.Trig.atan2(-1, -2)
      ...> |> inspect()
      "{:ok, #Angle<-2.677945044588987㎭>}"

      iex> Angle.Trig.atan2(1, 2)
      ...> |> inspect()
      "{:ok, #Angle<0.4636476090008061㎭>}"
  """
  @spec atan2(number, number) :: {:ok, Angle.t} | {:error, term}
  def atan2(x, y) when is_number(x) and is_number(y), do: x |> :math.atan2(y) |> r()
  def atan2(_x, _y), do: {:error, "Invalid function domain"}

  @doc """
  Calculate the cosine (sine complement) of `angle`.

  The cosine is the ratio of the length of the adjacent side to the length of
  the hypotenuse of a right angle triangle.

  Returns a `float` between `-1.0` and `1.0`

  ## Example

      iex> ~a(180)d
      ...> |> cos()
      ...> |> inspect()
      "{#Angle<180°>, -1.0}"
  """
  @spec cos(Angle.t) :: {Angle.t, float}
  def cos(%Angle{r: nil} = angle), do: angle |> ensure() |> cos()
  def cos(%Angle{r: r} = angle), do: {angle, :math.cos(r)}

  @doc """
  Calculate the hyperbolic cosine of `angle`.

  Returns a `float` between `1.0` and +∞.

  ## Example

      iex> ~a(0)
      ...> |> cosh()
      ...> |> inspect()
      "{#Angle<0>, 1.0}"
  """
  @spec cosh(Angle.t) :: {Angle.t, float}
  def cosh(%Angle{r: nil} = angle), do: angle |> ensure() |> cosh()
  def cosh(%Angle{r: r} = angle), do: {angle, :math.cosh(r)}

  @doc """
  Calculate the sine of `angle`.

  The sine of an angle is the ratio of the length of the opposite side to the
  length of the hypotenuse of a right angle triangle.

  Returns a `float` between -∞ and +∞.

  ## Example

      iex> ~a(90)d
      ...> |> sin()
      ...> |> inspect()
      "{#Angle<90°>, 1.0}"
  """
  @spec sin(Angle.t) :: {Angle.t, float}
  def sin(%Angle{r: nil} = angle), do: angle |> ensure() |> sin()
  def sin(%Angle{r: r} = angle), do: {angle, :math.sin(r)}

  @doc """
  Calculate the hyperbolic sine of `angle`.

  Returns a `float` between -∞ and +∞.

  ## Example

      iex> ~a(0)
      ...> |> sinh()
      ...> |> inspect()
      "{#Angle<0>, 0.0}"
  """
  @spec sinh(Angle.t) :: {Angle.t, float}
  def sinh(%Angle{r: nil} = angle), do: angle |> ensure() |> sinh()
  def sinh(%Angle{r: r} = angle), do: {angle, :math.sinh(r)}

  @doc """
  Caculate the tangent of `angle`.

  The tangent of an angle is the ratio of the length of the opposite side to
  the length of the adjacent side of a right angle triangle.

  Returns a `float` between -∞ and +∞.

  ## Example

      iex> ~a(0)
      ...> |> tan()
      ...> |> inspect()
      "{#Angle<0>, 0.0}"
  """
  @spec tan(Angle.t) :: {Angle.t, float}
  def tan(%Angle{r: nil} = angle), do: angle |> ensure() |> tan()
  def tan(%Angle{r: r} = angle), do: {angle, :math.tan(r)}

  @doc """
  Calculate the hyperbolic tangent of `angle`.

  Returns a `float` between `-1.0` and `1.0`

  ## Example

      iex> ~a(0)
      ...> |> tanh()
      ...> |> inspect()
      "{#Angle<0>, 0.0}"
  """
  @spec tanh(Angle.t) :: {Angle.t, float}
  def tanh(%Angle{r: nil} = angle), do: angle |> ensure() |> tanh()
  def tanh(%Angle{r: r} = angle), do: {angle, :math.tanh(r)}

  defp r(value), do: {:ok, Angle.radians(value)}
end
