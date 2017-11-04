defmodule AngleSigilTest do
  use ExUnit.Case
  doctest Angle.Sigil
  import Angle.Sigil
  alias Angle.InvalidAngle

  test "a non number raises an exception" do
    assert_raise InvalidAngle, ~r/unable to parse/i, fn -> ~a(WAT)d end
  end

  test "an angle with no representation raises an exception" do
    assert_raise InvalidAngle, ~r/unable to parse/i, fn -> ~a(13) end
  end

  test "an angle with bogus modifiers raises an exception" do
    assert_raise InvalidAngle, ~r/unable to parse/i, fn -> ~a(13)z end
  end
end
