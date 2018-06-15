#!/bin/bash

dotenv-vault::decrypt() {
    in=$1
    out=$2
    openssl aes-256-cbc -e -in $in -out $out
}
