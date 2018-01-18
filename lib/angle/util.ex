defmodule Angle.Utils do
  @moduledoc false

  @doc """
  Convert strings to integers without raising an exception.

  ## Examples

      iex> "13" |> string_to_integer()
      {:ok, 13}

      iex> "13.2" |> string_to_integer()
      {:error, "Unable to convert value to integer"}
  """
  @spec string_to_integer(String.t()) :: {:ok, integer} | {:error, term}
  def string_to_integer(value) do
    {:ok, String.to_integer(value)}
  rescue
    ArgumentError -> {:error, "Unable to convert value to integer"}
  end

  @doc """
  Convert strings to floats without raising an exception.

  ## Examples

      iex> "13.2" |> string_to_float()
      {:ok, 13.2}

      iex> "13" |> string_to_float()
      {:error, "Unable to convert value to float"}
  """
  @spec string_to_float(String.t()) :: {:ok, float} | {:error, term}
  def string_to_float(value) do
    {:ok, String.to_float(value)}
  rescue
    ArgumentError -> {:error, "Unable to convert value to float"}
  end

  @doc """
  Convert strings to numbers without raising an exception.
  ## Examples

      iex> "13" |> string_to_number()
      {:ok, 13}

      iex> "13.2" |> string_to_number()
      {:ok, 13.2}

      iex> "Marty McFly" |> string_to_number()
      {:error, "Unable to convert value to number"}

  """
  @spec string_to_number(String.t()) :: {:ok, float | integer} | {:error, term}
  def string_to_number(value) do
    case string_to_float(value) do
      {:ok, value} ->
        {:ok, value}

      {:error, _} ->
        case string_to_integer(value) do
          {:ok, value} -> {:ok, value}
          {:error, _} -> {:error, "Unable to convert value to number"}
        end
    end
  end
end
