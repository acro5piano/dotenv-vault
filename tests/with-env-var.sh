source src/dotenv-vault.sh

set +eu

testcase_with_env_var_should_same_with_argument() {
    bin/dotenv-vault -k foobarbaz encrypt tests/assets/dotenv > /tmp/dotenv.encrypted

    env DOTENV_PASSWORD=foobarbaz bin/dotenv-vault decrypt /tmp/dotenv.encrypted > /tmp/dotenv.decrypted

    assert_true diff /tmp/dotenv.decrypted tests/assets/dotenv
}
