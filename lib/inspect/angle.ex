defimpl Inspect, for: Angle do
  import Inspect.Algebra

  @moduledoc """
  Defines the inspect protocol for Angles so that they can look pretty.
  """

  @degrees "\u00b0"
  @radians "\u33ad"
  @gradians "\u1d4d"
  @prime "\u2032"
  @double_prime "\u2033"

  @doc false
  @spec inspect(Angle.t(), any) :: String.t()
  def inspect(%Angle{d: 0}, _opts), do: "#Angle<0>"
  def inspect(%Angle{r: 0}, _opts), do: "#Angle<0>"
  def inspect(%Angle{g: 0}, _opts), do: "#Angle<0>"
  def inspect(%Angle{dms: {0, 0, 0}}, _opts), do: "#Angle<0>"

  def inspect(%Angle{d: n}, opts) when is_number(n),
    do: concat(["#Angle<", to_doc(n, opts), @degrees, ">"])

  def inspect(%Angle{r: n}, opts) when is_number(n),
    do: concat(["#Angle<", to_doc(n, opts), @radians, ">"])

  def inspect(%Angle{g: n}, opts) when is_number(n),
    do: concat(["#Angle<", to_doc(n, opts), @gradians, ">"])

  def inspect(%Angle{dms: {d, 0, 0}}, opts) when is_integer(d),
    do: concat(["#Angle<", to_doc(d, opts), @degrees, ">"])

  def inspect(%Angle{dms: {d, m, 0}}, opts) when is_integer(d) and is_integer(m) do
    concat(["#Angle<", to_doc(d, opts), @degrees, " ", to_doc(m, opts), @prime, ">"])
  end

  def inspect(%Angle{dms: {d, m, s}}, opts)
      when is_integer(d) and is_integer(m) and is_number(s) do
    concat([
      "#Angle<",
      to_doc(d, opts),
      @degrees,
      " ",
      to_doc(m, opts),
      @prime,
      " ",
      to_doc(s, opts),
      @double_prime,
      ">"
    ])
  end
end
