rm /tmp/dotenv.*

source src/dotenv-vault.sh

set +eu

testcase_encrypt() {
    export DOTENV_PASSWORD=foobarbaz

    bin/dotenv-vault encrypt tests/assets/dotenv > /tmp/dotenv.encrypted

    assert_equal 1 `grep -c 'NODE_ENV=production' /tmp/dotenv.encrypted`
    assert_equal 0 `grep -c 123456789 /tmp/dotenv.encrypted`
    assert_equal 0 `grep -c '1234=56789=' /tmp/dotenv.encrypted`
}

testcase_decrypt() {
    export DOTENV_PASSWORD=foobarbaz

    bin/dotenv-vault decrypt tests/assets/dotenv.encrypted > /tmp/dotenv.decrypted

    assert_equal 1 `grep -c 'NODE_ENV=production' /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c 123456789 /tmp/dotenv.decrypted`
    assert_equal 1 `grep -c '1234=56789=' /tmp/dotenv.decrypted`
}

testcase_encrypt_with_password() {
    echo foobarbaz > .dotenv-password

    assert_equal foobarbaz `dotenv-vault::get-key`

    rm .dotenv-password
}
