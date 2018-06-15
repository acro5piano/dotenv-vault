[![CircleCI](https://circleci.com/gh/acro5piano/dotenv-vault.svg?style=svg)](https://circleci.com/gh/acro5piano/dotenv-vault)

# dotenv-vault

![](https://github.com/acro5piano/dotenv-vault/blob/master/demo.gif)

simple dotenv encrypt tool inspired by yaml_vault

Default cipher is aes-256-cbc. Default sign digest is SHA256.

# Install

For MacOS:

```
git clone https://github.com/acro5piano/dotenv-vault ~/.dotenv-vault
ln -sfnv ~/.dotenv-vault/bin/dotenv-vault /usr/local/bin/dotenv-vault
```

For Linux:

```
git clone https://github.com/acro5piano/dotenv-vault ~/.dotenv-vault
sudo ln -sfnv ~/.dotenv-vault/bin/dotenv-vault /usr/bin/dotenv-vault
```

## Requirements

dotenv-vault requires the following:

- Bash > 2
- Openssl > 2
- Perl > 5

Almost all machine does not need any installation process.

# Usage

## Encrypt

Input file (.env):

```
NODE_ENV=development
API_KEY=123456789 # encrypt-me
```

where `# encrypt-me` is the mark of the line dotenv-vault encrypt.

Command:

```
$ env DOTENV_PASSWORD=foobarbaz dotenv-vault encrypt .env
```

Output:

```
NODE_ENV=development
API_KEY=U2FsdGVkX186T6zdupR27pXHO0Hdnz9rqZfVdgqBEqk= # decrypt-me
```

`# decrypt-me` will be used when decrypt the file.

## Decrypt

Input file (.env.encrypted):

```
NODE_ENV=development
API_KEY=U2FsdGVkX186T6zdupR27pXHO0Hdnz9rqZfVdgqBEqk= # decrypt-me
```

`# decrypt-me` is the mark of the line dotenv-vault decrypt.

Command:

```
$ env DOTENV_PASSWORD=foobarbaz dotenv-vault decrypt .env.encrypted
```

Output:

```
NODE_ENV=development
API_KEY=123456789 # encrypt-me
```

## Create Encrypt env

`dotenv-vault create` command is convenient to create new entry:

```
$ env DOTENV_PASSWORD=foobarbaz bin/dotenv-vault create 'SOME_KEY=123456'

# => SOME_KEY=U2FsdGVkX18tEclKImEV30HSG0b7IOu3dyO3MpceCd4= # decrypt-me
```

You can paste or redirect to register new entry like this:

```
$ env DOTENV_PASSWORD=foobarbaz bin/dotenv-vault create 'SOME_KEY=123456' >> .env
```

## Password Option

- If `DOTENV_PASSWORD` environment variable present, use it as password.
- If `.dotenv-password` file present, use the content of the file as password.
- Else, dotenv-vault ask you at runtime.

Note you must not include the `.dotenv-password` file to any repo.

# Update

```
cd ~/.dotenv-vault
git pull origin master
```

# Development

After checking out the repo, run `make` to run all tests.

# TODO

- [x] Add `.dotenv-password` to save the password
- [ ] Add auth methods
  - [ ] AWS KMS
  - [ ] GCP KMS
