# Developer edition for Rarimo decentralized bridge

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Here you can find the developer-edition to run the Rarimo cross-chain messaging protocol core for developer reasons.

## Running

`Makefile` is used as an auto-deploy script. You must have `make` package installed in order to follow these instructions.

### 1. Filling Vault

Run container for Vault:
```shell
make vault
```

Visit `localhost:8200` and login with `dev-only-token`. 
Set up Vault configuration for 2, 3 or 4 TSS services. Modify TSS environment if required. 
Explore [doc](https://github.com/rarimo/tss-svc#setup-the-hashicorp-vault-and-create-secret-for-your-tss-type-kv-version-2) for more information.

Briefly, you have to go through the following steps:
- Generate Cosmos accounts.
- Generate pre-params.
- Generate trial ECDSA keypair.
- Set up credentials in Valut.

### 2. Running validator and staking

Run container for Validator node:
```shell
make validator
```

Then, stake for your TSS services (also check the TSS service [documentation](https://github.com/rarimo/tss-svc#stake-tokens-to-become-an-active-party)).

### 3. Configuring issuer and RariMe orgs

#### Required for issuer

Copy the issuer's config samples:
```shell
cd config
cp env-issuer.sample .env-issuer
cp env-api.sample .env-api
```

In .env-issuer set the following environment variable:
```shell
ISSUER_ETHEREUM_URL=<YOUR_RPC_PROVIDER_ENDPOINT>
```

Save the *issuer's private key* in order to run the issuer later. Ensure that none of your configuration is exposed, that's why **all the changes should be done inside Git-ignored .env-* files** instead of the samples.

#### Optional

To enable domain verification and e-mail notifications for orgs service, check out `config/rarime-orgs.yaml`.

Configure TSS session start in `config/tss*.yaml` files.

### 4. Issuer node, TSS and organizations services

The remaining services can be run with
```shell
make key=xxx keygen=true all-remaining
```
where `key` is a private key from step 3 represented as hex string _without 0x prefix_; and `keygen=true` runs TSS services in key generation mode, required for the clean start: drop it if it's necessary not to generate keys. The command runs all 4 TSS services, then issuer's infrastructure, and at last the orgs service. If you need more flexibility, check out **Makefile commands** section below.

## Keys

Validator key (`validator_key`):
* Mnemonic: `monkey property mercy pottery perfect wonder happy method legend gather link scorpion cruise alcohol motion lava option swift retire purity luxury material car gentle`
* Address: `rarimo1q5wjzf8kfpxx3xze987ajjkr69rktk64a0wqqp`

## Useful commands

Create key:
```shell
rarimo-cored keys add name_key --keyring-backend test --home=./config/validator
```

Add key to genesis:
```shell
rarimo-cored add-genesis-account key_name [balance urmo, example: 1000urmo] --home=./config/validator
```

Apply changes in genesis:
```shell
rarimo-cored collect-gentxs --home=./config/validator
```

## Makefile commands

NOTE. You may check `Makefile` yourself to understand what's going on under the hood. The syntax is straitforward: when you run `make target`, all commands under the `target:` statement are executed in sequence they are written, EXCEPT variable assignments (any `var=...`), which are executed beforehand. For `target: dep1 dep2 [...]` targets-dependencies are executed even before assignments. Visit [Makefile tutorial](https://makefiletutorial.com/) if you need more info.

- `make clean` - run `issuer-clean-vault` and drop all the containers **with volumes**. Run `docker compouse down` instead if you want to preserve all the storage data.
- `make issuer-clean-vault` - delete issuer vault's temporary files. Useful when you have troubles with re-running issuer.
- `make key=xxx issuer` - run full issuer's infrastructure and configure it on-run. You might want to omit certain commands to have your own configuration, like `issuer-add-vault-token` and `issuer-generate-did`. Refer to `issuer: cmd1 cmd2 ...` definition in `Makefile` to see the sequence of commands you will need to run for flexibility.
- `make issuer-storage` - run storage services only
- `make issuer-services` - run issuer back-end, requires storage services up and running
- `make key=xxx issuer-add-private-key` - save key into issuer's vault
- `make issuer-add-vault-token` - retrieve the token from vault and replace it inside `config/.env-issuer` as `ISSUER_KEY_STORE_TOKEN`
- `make issuer-generate-did` - run initializer service and get generated DID from it, then replace it in `config/.env-api` as `ISSUER_API_UI_ISSUER_DID`.
- `make did=xxx issuer-add-did` - update DID in vault's path `kv/did`
- Other commands are self-explanatory.