# Developer edition for Rarimo decentralized bridge

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Here you can find the developer-edition to run the Rarimo cross-chain messaging protocol core for developer reasons.

## How to launch

### 1.  Filling Vault

Run container for Vault:
```shell
docker-compose up vault -d
```

Visit `localhost:8200` and login with `dev-only-token`. 
Set up Vault configuration for 2, 3 or 4 TSS services. Modify TSS environment if required. 
Explore [doc](https://github.com/rarimo/tss-svc#setup-the-hashicorp-vault-and-create-secret-for-your-tss-type-kv-version-2) for more information.

Briefly, you have to go through the following steps:
- Generate Cosmos accounts.
- Generate pre-params.
- Generate trial ECDSA keypair.
- Set up credentials in Valut.

### 2. Running validator

Run container for Validator node:
```shell
docker-compose up validator -d
```

Then, stake for your TSS services (also check the TSS service [documentation](https://github.com/rarimo/tss-svc#stake-tokens-to-become-an-active-party)).

### 3.  Generating keys

Configure session start in `tss{i}.yaml` files. Run TSS services (`docker-compose up -d`) with
```yaml
entrypoint: sh -c "tss-svc migrate up && tss-svc run keygen"
```
After finishing of the keygen session change back the entrypoint to `...tss-svc run service`.

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
