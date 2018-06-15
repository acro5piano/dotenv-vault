export DOTENV_KEY=foobarbaz

testcase_encrypt() {
    cp tests/dotenv /tmp/dotenv
    bin/dotenv-vault encrypt /tmp/dotenv

    encrypted_line_count=`cat /tmp/dotenv | grep -c 123456789`
    assert_equal 0 $encrypted_line_count

    no_encrypt_line_count=`cat /tmp/dotenv | grep -c NODE_ENV`
    assert_equal 1 $no_encrypt_line_count
}
