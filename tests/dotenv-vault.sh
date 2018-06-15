export DOTENV_VAULT_PASSPHRASE=foobarbaz

rm /tmp/dotenv.*

testcase_encrypt() {
    bin/dotenv-vault encrypt tests/dotenv > /tmp/dotenv.encrypted

    assert_equal 1 `cat /tmp/dotenv.encrypted | grep -c 'NODE_ENV=production'`
    assert_equal 0 `cat /tmp/dotenv.encrypted | grep -c 123456789`
    assert_equal 0 `cat /tmp/dotenv.encrypted | grep -c '1234=56789='`
}

testcase_decrypt() {
    bin/dotenv-vault decrypt tests/dotenv.encrypted > /tmp/dotenv.decrypted

    assert_equal 1 `cat /tmp/dotenv.decrypted | grep -c 'NODE_ENV=production'`
    assert_equal 1 `cat /tmp/dotenv.decrypted | grep -c 123456789`
    assert_equal 1 `cat /tmp/dotenv.decrypted | grep -c '1234=56789='`
}
