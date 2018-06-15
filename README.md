# dotenv-vault

simple dotenv encrypt tool inspired by yaml_vault

Default cipher is aes-256-cbc. Default sign digest is SHA256.

# Install

```
git clone https://github.com/acro5piano/dotenv-vault ~/.dotenv-vault
sudo ln -sfnv ~/.dotenv-vault/bin/dotenv-vault /usr/bin/dotenv-vault
```

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
env DOTENV_PASSWORD=foobarbaz dotenv-vault encrypt .env
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
env DOTENV_PASSWORD=foobarbaz dotenv-vault decrypt .env.encrypted
```

Output:

```
NODE_ENV=development
API_KEY=123456789 # encrypt-me
```

## Password Option

- If ENV["DOTENV_PASSWORD"] present, use it as passphrase.
- If `.dotenv-vault` file present, use the content of the file as passphrase.
- Else, dotenv-vault ask you at runtime.

Note you must not include the `.dotenv-vault` file to any repo.

# Development

After checking out the repo, run `make` to run all tests.

# TODO

- [ ] Add `.dotenv-password` to save the password
- [ ] Add auth methods
  - [ ] AWS KMS
  - [ ] GCP KMS
