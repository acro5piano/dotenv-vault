rm /tmp/dotenv.*

source src/dotenv-vault.sh

set +eu

testcase_encrypt() {
    export DOTENV_PASSWORD=foobarbaz

    bin/dotenv-vault encrypt tests/assets/dotenv > /tmp/dotenv.encrypted

    assert_equal 1 `grep -c 'NODE_ENV=production' /tmp/dotenv.encrypted`
    assert_equal 2 `grep -c '# decrypt-me' /tmp/dotenv.encrypted`
    assert_equal 0 `grep -c '123456789' /tmp/dotenv.encrypted`
    assert_equal 0 `grep -c '1234=56789=' /tmp/dotenv.encrypted`
}

testcase_decrypt() {
    export DOTENV_PASSWORD=foobarbaz

    bin/dotenv-vault decrypt tests/assets/dotenv.encrypted > /tmp/dotenv.decrypted

    assert_equal 1 `grep -c 'NODE_ENV=production' /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c 'API_KEY=123456789 # encrypt-me' /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c 'INCLUDE_EQUAL_KEY=1234=56789= # encrypt-me' /tmp/dotenv.decrypted`
}

testcase_get_key_should_recognize_password_file() {
    echo foobarbaz > .dotenv-password

    assert_equal foobarbaz `dotenv-vault::get-key`

    rm .dotenv-password
}
