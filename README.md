[![Hex version badge](https://img.shields.io/hexpm/v/crc_64.svg)](https://hex.pm/packages/crc_64)
[![Test](https://github.com/MikaAK/crc_64/actions/workflows/test.yml/badge.svg)](https://github.com/MikaAK/crc_64/actions/workflows/test.yml)
[![Credo](https://github.com/MikaAK/crc_64/actions/workflows/credo.yml/badge.svg)](https://github.com/MikaAK/crc_64/actions/workflows/credo.yml)
[![Dialyzer](https://github.com/MikaAK/crc_64/actions/workflows/dialyzer.yml/badge.svg)](https://github.com/MikaAK/crc_64/actions/workflows/dialyzer.yml)
[![Coverage](https://github.com/MikaAK/crc_64/actions/workflows/coverage.yml/badge.svg)](https://github.com/MikaAK/crc_64/actions/workflows/coverage.yml)


Implements AWS S3 compatible CRC64-NVME checksum calculation.
Pure Elixir implementation with no external dependencies.

CRC64 is a 64-bit cyclic redundancy check algorithm used for error detection.
This implementation uses the polynomial 0x9A6C9329AC4BC9B5 which is compatible
with AWS S3's CRC64 implementation.

## Installation

[Available in Hex](https://hex.pm/packages/crc_64), the package can be installed
by adding `crc_64` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:crc_64, "~> 0.1.0"}
  ]
end
```

## Usage

### Calculate CRC64 Checksum (as integer)

```elixir
# Calculate checksum for a binary
checksum = Crc64.calculate("Hello, world!")
# Returns a non-negative integer
```

### Calculate CRC64 Checksum (as Base64 string)

```elixir
# Calculate Base64-encoded checksum
base64_checksum = Crc64.calculate_base64("Hello, world!")
# Returns a Base64 string like "Ik7A4/gH+LE="
```

### Validate Data against Checksum

```elixir
# Check if data matches a checksum
data = "Important content"
checksum = "dGhlIGNoZWNrc3VtIGhlcmU=" # previously calculated Base64 checksum
is_valid = Crc64.valid_checksum?(data, checksum)
# Returns true if the calculated checksum matches
```

### Validate File against Checksum

```elixir
# Validate a file against a known checksum
file_path = "path/to/your/file.txt"
checksum = "dGhlIGNoZWNrc3VtIGhlcmU=" # previously calculated Base64 checksum
is_valid = Crc64.valid_file_checksum?(file_path, checksum)
# Returns true if the file's checksum matches
```

Documentation can be found at <https://hexdocs.pm/crc_64>.

