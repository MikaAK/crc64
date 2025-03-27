defmodule Crc64 do
    @moduledoc """
  Implements AWS S3 compatible CRC64-NVME checksum calculation.
  Pure Elixir implementation with no external dependencies.

  CRC64 is a 64-bit cyclic redundancy check algorithm used for error detection.
  This implementation uses the polynomial 0x9A6C9329AC4BC9B5 which is compatible
  with AWS S3's CRC64 implementation.
  """

  import Bitwise

  @poly 0x9A6C9329AC4BC9B5
  @init 0xFFFFFFFFFFFFFFFF
  @xor_out 0xFFFFFFFFFFFFFFFF

  @doc """
  Calculates the CRC64 checksum for the given binary data.

  Returns the checksum as an integer value.

  ## Examples

      iex> Crc64.calculate("123456789")
      0xAE8B14860A799888
  """
  @spec calculate(binary()) :: non_neg_integer()
  def calculate(data) when is_binary(data) do
    data
    |> :binary.bin_to_list()
    |> Enum.reduce(@init, &update_crc(&1, &2))
    |> finalize()
  end

  @doc """
  Calculates the CRC64 checksum for the given binary data and returns it as a Base64 encoded string.

  This format is compatible with the AWS S3 CRC64 checksums.

  ## Examples

      iex> Crc64.calculate_base64("Hello World!")
      "AuUcyF784aU="
  """
  @spec calculate_base64(binary()) :: String.t()
  def calculate_base64(data) when is_binary(data) do
    data
    |> calculate()
    |> to_base64()
  end

  @doc """
  Validates if the given checksum matches the calculated checksum for the data.

  Returns `true` if the checksum is valid, `false` otherwise.

  ## Examples

      iex> Crc64.valid_checksum?("Hello World!", "AuUcyF784aU=")
      true

      iex> Crc64.valid_checksum?("Hello World!", "u5WU6IUEP4mKJw==")
      false
  """
  @spec valid_checksum?(binary(), String.t()) :: boolean()
  def valid_checksum?(data, checksum) when is_binary(data) and is_binary(checksum) do
    calculate_base64(data) === checksum
  end

  @doc """
  Validates if the given checksum matches the calculated checksum for the file contents.

  Returns `true` if the checksum is valid, `false` otherwise.
  Raises an error if the file does not exist or cannot be read.

  ## Examples

      iex> File.write!("test.txt", "Hello World!")
      :ok
      iex> Crc64.valid_file_checksum?("test.txt", "AuUcyF784aU=")
      true
      iex> File.rm!("test.txt")
      :ok
  """
  @spec valid_file_checksum?(String.t(), String.t()) :: boolean()
  def valid_file_checksum?(file_path, checksum) when is_binary(file_path) and is_binary(checksum) do
    file_path
    |> File.read!()
    |> valid_checksum?(checksum)
  end

  @spec update_crc(byte(), non_neg_integer()) :: non_neg_integer()
  defp update_crc(byte, crc) do
    crc = bxor(crc, byte)

    Enum.reduce(1..8, crc, fn _, acc ->
      if (acc &&& 1) == 1 do
        bxor((acc >>> 1), @poly)
      else
        acc >>> 1
      end
    end)
  end

  @spec finalize(non_neg_integer()) :: non_neg_integer()
  defp finalize(crc), do: bxor(crc, @xor_out)

  @spec to_base64(non_neg_integer()) :: String.t()
  defp to_base64(crc) do
    crc
    |> :binary.encode_unsigned(:big)
    |> Base.encode64()
  end
end
