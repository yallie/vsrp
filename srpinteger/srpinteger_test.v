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

// note: it breaks due to fixed buffer size in bignum
fn notest_parse_many() {
	parts := ["3a", "ca", "16", "f5", "a3", "22", "95", "ec",
		"ee", "af", "0a", "b9", "ad", "b3", "8d", "d6", "9c",
		"33", "f8", "0a", "fa", "8f", "c5", "e8", "60", "72",
		"61", "87", "75", "ff", "3c", "0b", "9e", "a2", "31",
		"4c", "9c", "25", "65", "76", "d6", "74", "df", "74",
		"96", "ea", "81", "d3", "38", "3b", "48", "13", "d6",
		"92", "c6", "e0", "e0", "d5", "d8", "e2", "50", "b9",
		"8b", "e4", "8e", "49", "5c", "1d", "60", "89", "da",
		"d1", "5d", "c7", "d7", "b4", "61", "54", "d6", "b6",
		"ce", "8e", "f4", "ad", "69", "b1", "5d", "49", "82",
		"55", "9b", "29", "7b", "cf", "18", "85", "c5", "29",
		"f4", "56", "66", "60", "e5", "7e", "c6", "8e", "db",
		"c3", "c0", "57", "26", "cc", "02", "fd", "4c", "bf",
		"49", "76", "ea", "a9", "af", "d5", "13", "8f", "e8",
		"37", "64", "35", "b9", "fc", "61", "d2", "fc", "0e"]

	mut x := ""
	for i := 0; i < parts.len; i++ {
		x = x + parts[i]
		h := srpinteger.parse(x).hexstr()
		println("h = " + h + ", x = " + x)
		assert x == h
	}
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

	// doesn't work because bignum overflows
//	si = srpinteger.from_hex("32510bfbacfbb9befd54415da243e1695ecabd58c519cd4bd90f1fa6ea5ba47b01c909ba7696cf606ef40c04afe1ac0aa8148dd066592ded9f8774b529c7ea125d298e8883f5e9305f4b44f915cb2bd05af51373fd9b4af511039fa2d96f83414aaaf261bda2e97b170fb5cce2a53e675c154c0d9681596934777e2275b381ce2e40582afe67650b13e72287ff2270abcf73bb028932836fbdecfecee0a3b894473c1bbeb6b4913a536ce4f9b13f1efff71ea313c8661dd9a4ce")
//	println("si.to_hex() == " + si.to_hex())
//	assert "32510bfbacfbb9befd54415da243e1695ecabd58c519cd4bd90f1fa6ea5ba47b01c909ba7696cf606ef40c04afe1ac0aa8148dd066592ded9f8774b529c7ea125d298e8883f5e9305f4b44f915cb2bd05af51373fd9b4af511039fa2d96f83414aaaf261bda2e97b170fb5cce2a53e675c154c0d9681596934777e2275b381ce2e40582afe67650b13e72287ff2270abcf73bb028932836fbdecfecee0a3b894473c1bbeb6b4913a536ce4f9b13f1efff71ea313c8661dd9a4ce" == si.to_hex()

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

fn test_negative_numbers_not_supported() {
	assert "123" == (srpinteger.create("-123", 0).value).hexstr()
	assert "321" == (srpinteger.from_hex("-3-2-1").value).hexstr()
}

fn test_add() {
	result := srpinteger.from_hex("353") + srpinteger.from_hex("181")
	assert "4d4" == result.to_hex()
}

fn test_subtract() {
	result := srpinteger.from_hex("5340") - srpinteger.from_hex("5181")
	assert "01bf" == result.to_hex()
}

fn test_multiply() {
	result := srpinteger.from_hex("CAFE") * srpinteger.from_hex("babe")
	assert "94133484" == result.to_hex()
}

fn test_divide() {
	result := srpinteger.from_hex("faced") / srpinteger.from_hex("BABE")
	assert "00015" == result.to_hex()
}

fn test_modulo() {
	result := srpinteger.from_hex("10") % srpinteger.from_hex("09")
	assert "07" == result.to_hex()
}

// doesn't work because bignum overflows
fn notest_xor() {
	left := srpinteger.from_hex("32510bfbacfbb9befd54415da243e1695ecabd58c519cd4bd90f1fa6ea5ba47b01c909ba7696cf606ef40c04afe1ac0aa8148dd066592ded9f8774b529c7ea125d298e8883f5e9305f4b44f915cb2bd05af51373fd9b4af511039fa2d96f83414aaaf261bda2e97b170fb5cce2a53e675c154c0d9681596934777e2275b381ce2e40582afe67650b13e72287ff2270abcf73bb028932836fbdecfecee0a3b894473c1bbeb6b4913a536ce4f9b13f1efff71ea313c8661dd9a4ce")
	println("left = " + left.to_hex())

	right := srpinteger.from_hex("71946f9bbb2aeadec111841a81abc300ecaa01bd8069d5cc91005e9fe4aad6e04d513e96d99de2569bc5e50eeeca709b50a8a987f4264edb6896fb537d0a716132ddc938fb0f836480e06ed0fcd6e9759f40462f9cf57f4564186a2c1778f1543efa270bda5e933421cbe88a4a52222190f471e9bd15f652b653b7071aec59a2705081ffe72651d08f822c9ed6d76e48b63ab15d0208573a7eef027")
	xored := srpinteger.from_hex("32510bfbacfbb9befd54415da243e1695ecabd58c519cd4bd90f1fa6ea5ba3624730b208d83b237176b5a41e13d1a2c0080f55d6fb05e4fd9a6e8aff84a9eec74ec0e3115dd0808c011baa15b2c29edad06d6c319976fc7c7eb6a8727e79906c96397dd14594a17511e2ba018c3267935877b5c2c1750f28b2d5bf55faa6c2218c30e58f17542717ad6f8622dd0069a4886d20d3d657a80a869c8f6025399f914f23e5ccd3a999c271a50994c7db959c5c0b73334d15ba3754e9")

	result := left.b_xor(right)
	println("result = " + result.to_hex())
	println("xored  = " + xored.to_hex())

	assert xored.eq(result)
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
