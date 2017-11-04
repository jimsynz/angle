# Angle

[![pipeline status](https://gitlab.com/jimsy/angle/badges/master/pipeline.svg)](https://gitlab.com/jimsy/angle/commits/master)
[![Hex.pm](https://img.shields.io/hexpm/v/angle.svg)](https://hex.pm/packages/angle)

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

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `angle` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:angle, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/angle](https://hexdocs.pm/angle).

