module srpinteger
import bignum
import strconv

pub struct SrpInteger {
pub mut:
    value bignum.Number
    hex_length int
}

pub const (
	zero = SrpInteger {
		value: bignum.new_bignum()
		hex_length: 1
	}
)

pub fn normalize_whitespace(hex string) string {
	return hex.replace_each([
		' ', '',
		'\r', '',
		'\n', '',
		'\t', '',
		'\v', '',
		'-', '',
		'_', ''
	])
}

pub fn parse(hex string) bignum.Number {
	h := normalize_whitespace(hex)

	mut result := bignum.new_bignum()
	if h.len <= 0 {
		return result
	}

	hex_bits := 4
	part_size := 64 / hex_bits

	for i := 0; i < h.len; i += part_size {
		mut end := i + part_size
		if end > h.len {
			end = h.len
		}

		part := h[i..end]
		parsed := strconv.parse_uint(part, 16, 64)
		result = result.lshift(part.len * hex_bits) + bignum.from_u64(parsed)
	}

	return result
}

pub fn create(hex string, hex_length int) SrpInteger {
	h := normalize_whitespace(hex)

	mut l := hex_length
	if l <= 0 {
		l = h.len
	}

	return SrpInteger {
		value: parse(h),
		hex_length: l
	}
}

pub fn from_hex(hex string) SrpInteger {
	mut h := hex
	if h.len == 0 {
		h = "0"
	}

	return create(hex, 0)
}

pub fn (si SrpInteger) to_hex() string {
	h := si.value.hexstr()
	pad := si.hex_length - h.len
	if (pad > 0) {
		return "0".repeat(pad) + h
	}

	return h
}

pub fn (si SrpInteger) str() string {
	mut hex := si.value.hexstr()
	if hex[0..1] > "8" {
		hex = "0" + hex
	}

	if hex.len > 16 {
		hex = hex.substr(0, 16) + "..."
	}

	return "<SrpInteger: $hex>"
}

pub fn (a SrpInteger) eq(b SrpInteger) bool {
	return bignum.cmp(a.value, b.value) == 0
}

fn max(a, b int) int {
	return if a > b {
		a
	} else {
		b
	}
}

pub fn (a SrpInteger) + (b SrpInteger) SrpInteger {
	return SrpInteger {
		value: a.value + b.value
		hex_length: max(a.hex_length, b.hex_length)
	}
}

pub fn (a SrpInteger) - (b SrpInteger) SrpInteger {
	return SrpInteger {
		value: a.value - b.value
		hex_length: max(a.hex_length, b.hex_length)
	}
}

pub fn (a SrpInteger) * (b SrpInteger) SrpInteger {
	return SrpInteger {
		value: a.value * b.value
		hex_length: max(a.hex_length, b.hex_length)
	}
}

pub fn (a SrpInteger) / (b SrpInteger) SrpInteger {
	return SrpInteger {
		value: a.value / b.value
		hex_length: max(a.hex_length, b.hex_length)
	}
}

pub fn (a SrpInteger) % (b SrpInteger) SrpInteger {
	return SrpInteger {
		value: a.value % b.value
		hex_length: max(a.hex_length, b.hex_length)
	}
}

pub fn (a SrpInteger) b_xor (b SrpInteger) SrpInteger {
	return SrpInteger {
		value: bignum.b_xor(a.value, b.value)
		hex_length: max(a.hex_length, b.hex_length)
	}
}

pub fn range<T>(start, end T) []T {
	mut res := []T
	for i := start; i < end; i++ {
		res << i
	}
	return res
}
