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

dotenv-vault::ask-key() {
    if [ -z $DOTENV_KEY ]; then
        read -p 'Please input payme password and press Return: ' -s DOTENV_KEY
    fi

    echo $DOTENV_KEY
}

dotenv-vault::encrypt-file() {
    file=$1
    key=$2
    cat $file | while read line
    do
        if echo $line | grep -q '# encrypt-me'; then
            key=`echo $line | perl -pe 's/(.+?)=.+# encrypt-me/\1/'`
            value=`echo $line | perl -pe 's/.+?=(.+)# encrypt-me/\1/' | openssl aes-256-cbc -base64 -k hoge -e`
            echo "$key=$value # decrypt-me"
        else
            echo $line
        fi
    done
}

dotenv-vault::decrypt-file() {
    file=$1
    key=$2
    cat $file | while read line
    do
        if echo $line | grep -q '# decrypt-me'; then
            key=`echo $line | perl -pe 's/(.+?)=.+# decrypt-me/\1/'`
            # value=`echo $line | perl -pe 's/.+?=(.+)# decrypt-me/\1/' | openssl aes-256-cbc -base64 -k hoge -d`
            decrypted_value=`echo $line | perl -pe 's/.+?=(.+)# decrypt-me/\1\n/'`
            value=`echo $decrypted_value | openssl aes-256-cbc -base64 -k hoge -d`
            echo "$key=$value # encrypt-me"
        else
            echo $line
        fi
    done
}

dotenv-vault::encrypt() {
    dotenv-vault::check $@
    key=`dotenv-vault::ask-key`

    file=$2
    dotenv-vault::encrypt-file $file $key
}

dotenv-vault::decrypt() {
    dotenv-vault::check $@
    key=`dotenv-vault::ask-key`

    file=$2
    dotenv-vault::decrypt-file $file $key
}
