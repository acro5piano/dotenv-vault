export DOTENV_VAULT_PASSPHRASE=foobarbaz

rm /tmp/dotenv.*

testcase_encrypt() {
    bin/dotenv-vault encrypt tests/assets/dotenv > /tmp/dotenv.encrypted

    assert_equal 1 `grep -c 'NODE_ENV=production' /tmp/dotenv.encrypted`
    assert_equal 0 `grep -c 123456789 /tmp/dotenv.encrypted`
    assert_equal 0 `grep -c '1234=56789=' /tmp/dotenv.encrypted`
}

testcase_decrypt() {
    bin/dotenv-vault decrypt tests/assets/dotenv.encrypted > /tmp/dotenv.decrypted

    assert_equal 1 `grep -c 'NODE_ENV=production' /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c 123456789 /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c '1234=56789=' /tmp/dotenv.decrypted`
}
