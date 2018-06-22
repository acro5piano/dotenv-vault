source src/dotenv-vault.sh

set +eu

testcase_create() {
    bin/dotenv-vault -k foobarbaz create 'SOME_KEY=123456789' > /tmp/dotenv.created.encrypted

    assert_equal 'SOME_KEY=123456789' "`bin/dotenv-vault -k foobarbaz decrypt /tmp/dotenv.created.encrypted`"
}
