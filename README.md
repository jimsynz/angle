# Angle

[![pipeline status](https://gitlab.com/jimsy/angle/badges/main/pipeline.svg)](https://gitlab.com/jimsy/angle/commits/main)
[![Hex.pm](https://img.shields.io/hexpm/v/angle.svg)](https://hex.pm/packages/angle)
[![Hippocratic License HL3-FULL](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-FULL&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/full.html)

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
    {:angle, "~> 1.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/angle](https://hexdocs.pm/angle).

## License

This software is licensed under the terms of the
[HL3-FULL](https://firstdonoharm.dev), see the `LICENSE.md` file included with
this package for the terms.

This license actively proscribes this software being used by and for some
industries, countries and activities.  If your usage of this software doesn't
comply with the terms of this license, then [contact me](mailto:james@harton.nz)
with the details of your use-case to organise the purchase of a license - the
cost of which may include a donation to a suitable charity or NGO.
