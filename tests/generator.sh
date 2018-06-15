source src/dotenv-vault.sh

set +eu

export DOTENV_PASSWORD=foobarbaz

testcase_create() {
    bin/dotenv-vault create 'SOME_KEY=123456789' > /tmp/dotenv.created.encrypted

    assert_equal 'SOME_KEY=123456789' `bin/dotenv-vault decrypt /tmp/dotenv.created.encrypted`
}
