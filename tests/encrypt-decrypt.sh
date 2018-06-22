source src/dotenv-vault.sh

set +eu

testcase_encrypt() {
    bin/dotenv-vault -k foobarbaz encrypt tests/assets/dotenv > /tmp/dotenv.encrypted

    assert_equal 0 `grep -c 'NODE_ENV=production' /tmp/dotenv.encrypted`
    assert_equal 0 `grep -c 'API_KEY=123456789' /tmp/dotenv.encrypted`
    assert_equal 0 `grep -c 'INCLUDE_EQUAL_KEY=1234=56789=' /tmp/dotenv.encrypted`
}

testcase_decrypt() {
    bin/dotenv-vault -k foobarbaz decrypt tests/assets/dotenv.encrypted > /tmp/dotenv.decrypted

    assert_equal 1 `grep -c 'NODE_ENV=production' /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c 'API_KEY=123456789' /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c 'INCLUDE_EQUAL_KEY=1234=56789=' /tmp/dotenv.decrypted`
}
