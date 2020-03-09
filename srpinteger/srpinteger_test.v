import srpinteger
import arrays

fn test_zero() {
	z := srpinteger.zero

	assert z.hex_length == 1
	assert z.value.hexstr() == '0'
	assert z.value.is_zero()
}

fn test_normalize_whitespace() {
	assert "hellothere" == srpinteger.normalize_whitespace(" hello \t there ")
	assert "cool" == srpinteger.normalize_whitespace(" c o\r\tol\r\n")
}

fn test_parse() {
	assert srpinteger.parse("0").hexstr() == "0"
	assert srpinteger.parse("123").hexstr() == "123"
	assert srpinteger.parse("cafebabe").hexstr() == "cafebabe"
	assert srpinteger.parse("EEAF0AB9ADB38DD69C33F80AFA8FC5E86072618775FF3C0B9EA2314C9C256576D674DF7496EA81D3383B4813D692C6E0E0D5D8E250B98BE48E495C1D6089DAD15DC7D7B46154D6B6CE8EF4AD69B15D4982559B297BCF1885C529F566660E57EC68EDBC3C05726CC02FD4CBF4976EAA9AFD5138FE8376435B9FC61D2FC0EB06E3").hexstr() ==
		"eeaf0ab9adb38dd69c33f80afa8fc5e86072618775ff3c0b9ea2314c9c256576d674df7496ea81d3383b4813d692c6e0e0d5d8e250b98be48e495c1d6089dad15dc7d7b46154d6b6ce8ef4ad69b15d4982559b297bcf1885c529f566660e57ec68edbc3c05726cc02fd4cbf4976eaa9afd5138fe8376435b9fc61d2fc0eb06e3"
}

fn test_create() {
	s := srpinteger.create("1234abcd", 0)
	assert s.hex_length == 8
	assert s.value.hexstr() == "1234abcd"
}

fn test_str() {
	mut s := srpinteger.create("2", 0)
	assert "<SrpInteger: 2>" == s.str()

	// 512-bit prime number
	s = srpinteger.create("D4C7F8A2B32C11B8FBA9581EC4BA4F1B04215642EF7355E37C0FC0443EF756EA2C6B8EEB755A1C723027663CAA265EF785B8FF6A9B35227A52D86633DBDFCA43", 0)
	assert "<SrpInteger: 0d4c7f8a2b32c11b...>" == s.str()
}

fn test_from_hex_to_hex() {
	mut si := srpinteger.from_hex("02")
	assert "02" == si.to_hex()

	// 512-bit prime number
	si = srpinteger.from_hex("D4C7F8A2B32C11B8FBA9581EC4BA4F1B04215642EF7355E37C0FC0443EF756EA2C6B8EEB755A1C723027663CAA265EF785B8FF6A9B35227A52D86633DBDFCA43")
	assert "d4c7f8a2b32c11b8fba9581ec4ba4f1b04215642ef7355e37c0fc0443ef756ea2c6b8eeb755a1c723027663caa265ef785b8ff6a9b35227a52d86633dbdfca43" == si.to_hex()

	// should keep padding when going back and forth
	assert "a" == srpinteger.from_hex("a").to_hex()
	assert "0a" == srpinteger.from_hex("0a").to_hex()
	assert "00a" == srpinteger.from_hex("00a").to_hex()
	assert "000a" == srpinteger.from_hex("000a").to_hex()
	assert "0000a" == srpinteger.from_hex("0000a").to_hex()
	assert "00000a"  == srpinteger.from_hex("00000a").to_hex()

	// zero
	si = srpinteger.from_hex("")
	assert si.value.is_zero()
	assert srpinteger.zero.eq(si)
}

fn test_normalized_length() {
	hex := srpinteger.from_hex("
		7E273DE8 696FFC4F 4E337D05 B4B375BE B0DDE156 9E8FA00A 9886D812
		9BADA1F1 822223CA 1A605B53 0E379BA4 729FDC59 F105B478 7E5186F5
		C671085A 1447B52A 48CF1970 B4FB6F84 00BBF4CE BFBB1681 52E08AB5
		EA53D15C 1AFF87B2 B9DA6E04 E058AD51 CC72BFC9 033B564E 26480D78
		E955A5E2 9E7AB245 DB2BE315 E2099AFB").to_hex()

	assert hex.starts_with("7e27") && hex.ends_with("9afb")
	assert 256 == hex.len
}

fn test_range() {
	start_pos := 3
	end_pos := 10

	arr1 := arrays.range<int>(start_pos, end_pos)
	assert arr1.len == end_pos - start_pos
	for i, c in arr1 {
		assert c == i + start_pos
	}

	arr2 := arrays.range<f32>(start_pos, end_pos)
	assert arr2.len == end_pos - start_pos
	for i, c in arr2 {
		assert c == f32(i + start_pos)
	}

	arr3 := arrays.range<int>(start_pos, start_pos - 1)
	assert arr3.len == 0

	arr4 := arrays.range<int>(start_pos, start_pos)
	assert arr4.len == 0

	arr5 := arrays.range<int>(start_pos, start_pos + 1)
	assert arr5.len == 1
	assert arr5[0] == start_pos

	println("Hello!")
}
