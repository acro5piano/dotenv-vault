source src/dotenv-vault.sh

set +eu

testcase_encrypt_specific_key() {
    bin/dotenv-vault -e API_KEY -k foobarbaz encrypt tests/assets/dotenv > /tmp/dotenv.encrypted

    assert_equal 1 `grep -c 'NODE_ENV=production' /tmp/dotenv.encrypted`
    assert_equal 0 `grep -c 'API_KEY=123456789' /tmp/dotenv.encrypted`
    assert_equal 1 `grep -c 'INCLUDE_EQUAL_KEY=1234=56789=' /tmp/dotenv.encrypted`
}

testcase_decrypt_specific_key() {
    bin/dotenv-vault -e API_KEY -k foobarbaz encrypt tests/assets/dotenv > /tmp/dotenv.encrypted-asset
    bin/dotenv-vault -e API_KEY -k foobarbaz decrypt /tmp/dotenv.encrypted-asset > /tmp/dotenv.decrypted

    assert_equal 1 `grep -c 'NODE_ENV=production' /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c 'API_KEY=123456789' /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c 'INCLUDE_EQUAL_KEY=1234=56789=' /tmp/dotenv.decrypted`
}
