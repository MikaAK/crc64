defmodule Crc64Test do
  use ExUnit.Case
  doctest Crc64

  describe "calculate/1" do
    test "returns correct checksum for standard test string" do
      assert Crc64.calculate("123456789") == 0xAE8B14860A799888
    end

    test "returns correct checksum for AWS example 'Hello World!'" do
      assert Crc64.calculate_base64("Hello World!") == "AuUcyF784aU="
    end

    test "returns correct checksum for empty string" do
      assert Crc64.calculate("") == 0x0000000000000000
    end
  end
end
