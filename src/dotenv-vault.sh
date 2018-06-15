#!/bin/bash

set -e

dotenv-vault::check() {
    if [ -z "$2" ]; then
        echo 'No filename'
        return 1
    fi
    if ! [ -e "$2" ]; then
        echo 'Not exist'
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

dotenv-vault::encrypt-file() {
    file=$1
    password=$2
    cat $file | while read line
    do
        if echo $line | grep -q '# encrypt-me'; then
            key=`echo $line | perl -pe 's/(.+?)=.+# encrypt-me/\1/'`
            value=`echo $line | perl -pe 's/.+?=(.+)# encrypt-me/\1/' | openssl aes-256-cbc -A -base64 -k $password -e`
            echo "$key=$value # decrypt-me"
        else
            echo $line
        fi
    done
}

dotenv-vault::decrypt-file() {
    file=$1
    password=$2
    cat $file | while read line
    do
        if echo $line | grep -q '# decrypt-me'; then
            key=`echo $line | perl -pe 's/(.+?)=.+# decrypt-me/\1/'`
            encrypted_value=`echo $line | perl -pe 's/.+?=(.+) # decrypt-me/\1/'`
            value=`echo $encrypted_value | openssl aes-256-cbc -A -base64 -k $password -d`
            echo "$key=$value# encrypt-me"
        else
            echo $line
        fi
    done
}

dotenv-vault::create() {
    target=$2
    password=`dotenv-vault::get-key`
    key=`echo $target | perl -pe 's/(.+?)=.+/\1/'`
    encrypted_value=`echo $target | perl -pe 's/.+?=(.+)/\1/' | openssl aes-256-cbc -A -base64 -k $password -e`
    echo "$key=$encrypted_value # decrypt-me"
}

dotenv-vault::encrypt() {
    dotenv-vault::check $@
    key=`dotenv-vault::get-key`

    file=$2
    dotenv-vault::encrypt-file $file $key
}

dotenv-vault::decrypt() {
    dotenv-vault::check $@
    key=`dotenv-vault::get-key`

    file=$2
    dotenv-vault::decrypt-file $file $key
}
