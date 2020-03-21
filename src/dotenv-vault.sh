#!/bin/bash

set -e

dotenv-vault::check() {
    if [ -z "$2" ]; then
        echo 'No filename' 1>&2
        return 1
    fi
    if ! [ -e "$2" ]; then
        echo 'Not exist' 1>&2
        return 2
    fi
}

dotenv-vault::get-key() {
    if ! [ -z $DOTENV_PASSWORD ]; then
        echo $DOTENV_PASSWORD
        return 0
    fi

    if [ -e .dotenv-password ]; then
        cat .dotenv-password
        return 0
    fi

    read -p 'Please input password and press Return: ' -s DOTENV_PASSWORD
    echo $DOTENV_PASSWORD
}

dotenv-vault::get-key-from-line() {
    echo $1 | perl -pe 's/(.+?)=.+$/\1/'
}

dotenv-vault::get-value-from-line() {
    echo $1 | perl -pe 's/.+?=(.+)$/\1/'
}

dotenv-vault::should-encrypt() {
    key=$1
    pattern=$2
    ! [ -z $pattern ] && ! echo $key | egrep -q $pattern
}

dotenv-vault::encrypt-file() {
    file=$1
    password=$2
    pattern=$3
    cat $file | while read line
    do
        key=`dotenv-vault::get-key-from-line $line`
        value=`dotenv-vault::get-value-from-line $line`

        if dotenv-vault::should-encrypt $key $pattern; then
            echo "$key=$value"
        else
            value=`echo $value | openssl aes-256-cbc -A -base64 -md sha512 -pbkdf2 -iter 100000 -pass pass:$password -e`
            echo "$key=$value"
        fi
    done
}

dotenv-vault::decrypt-file() {
    file=$1
    password=$2
    pattern=$3
    cat $file | while read line
    do
        key=`dotenv-vault::get-key-from-line $line`
        value=`dotenv-vault::get-value-from-line $line`

        if dotenv-vault::should-encrypt $key $pattern; then
            echo "$key=$value"
        else
            value=`echo $value | openssl aes-256-cbc -A -base64 -md sha512 -pbkdf2 -iter 100000 -pass pass:$password -d`
            echo "$key=$value"
        fi
    done
}

dotenv-vault::create() {
    target=$1
    password=$2
    if [ -z $password ]; then
        password=`dotenv-vault::get-key`
    fi
    key=`dotenv-vault::get-key-from-line $target`
    value=`dotenv-vault::get-value-from-line $target`
    encrypted_value=`echo $value | openssl aes-256-cbc -A -base64 -md sha512 -pbkdf2 -iter 100000 -pass pass:$password -e`
    echo "$key=$encrypted_value"
}

dotenv-vault::encrypt() {
    file=$1
    key=$2
    exp=$3
    if [ -z $key ]; then
        key=`dotenv-vault::get-key`
    fi

    if ! [ -e "$file" ]; then
        echo 'Not exist' 1>&2
        exit 2
    fi

    dotenv-vault::encrypt-file $file $key $exp
}

dotenv-vault::decrypt() {
    file=$1
    key=$2
    exp=$3
    if [ -z $key ]; then
        key=`dotenv-vault::get-key`
    fi

    if ! [ -e "$file" ]; then
        echo 'Not exist' 1>&2
        exit 2
    fi

    dotenv-vault::decrypt-file $file $key $exp
}
