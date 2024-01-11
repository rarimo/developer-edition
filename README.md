# Developer edition for Rarimo decentralized bridge

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Here you can find the developer-edition to run the Rarimo cross-chain messaging protocol core for developer reasons.

## Pre-requisites
- Docker Compose
- GNU Make
- Common POSIX utils, like `sed`, `awk` (usually built-in)
- Linux or MacOS (PolygonID issuer node is unsupported on Windows, visit [repo](https://github.com/0xPolygonID/issuer-node) for more info)

## Running

It is recommended to drop all other Docker services in order to prevent conflicts with ports.

Deploy the full system from scratch with out-of-box configuration:
```shell
make all
```

This command does the following:
1. Check *Issuer's* env files; if they are absent, copy `env-issuer.sample`, `env-api.sample` into `.env-issuer`, `.env-api` accordingly in [config](config) directory
2. Run Vault and Validator
3. Fill Vault with 4 TSS pre-generated secrets
4. Stake for 4 TSS services, paying from Validator's account
5. Run TSS services in *keygen* mode, then restart in normal
6. Clean up *Issuer Vault* local files (this is a separate instance of Vault)
7. Run Issuer services, initialize Issuer Vault
8. Append generated Issuer's DID and Issuer Vault's token into `.env-api` and `.env-issuer` accordingly
9. Initialize and run Issuer services
10. Run the remaining Rarimo infrastrucure, like *links* and *orgs* services.

Explore [docker-compose.yaml](docker-compose.yaml) to view the exposed ports of each service you need.

Drop the entire system. **Please understand what this involves before the execution:**
- Stopping services, deleting containers
- Pruning volumes: databases of TSS, orgs, links services
- Deleting local *Rarimo ledger state*
- Deleting local Issuer Vault data
```shell
make clean
```

### Optional configuration

To enable domain verification and e-mail notifications for orgs service, check out `config/rarime-orgs.yaml`.

## Troubleshooting

### General

You might need these commands to quickly diagnose the issue.

Check the services' states. Be sure that all the services have `Up` status, and two script ones `vault-init` and `tss-stake` are with `Exited (0)`.
```shell
docker compose ps -a
```

Check service logs. It is a common case that something has broken in scripts mentioned above. Try checking their logs first if everything else seems good.
```shell
docker compose logs -f service_name # service2 service3... for multiple logs at once
```

Restart service:
```shell
docker compose down service_name && docker compose up -d service_name
```

### Clean start failure

It is possible that your `make all` command fails at the first clean execution. Run `make clean` and retry.

The known issue is "floating initialization time". To quick-fix such failures, try increasing the time (seconds) of certain `sleep` instruction in [Makefile](Makefile).

### Advanced checks

If you have changed configuration manually, be sure that:
- After changing `genesis.json` `config/validator/data` directory was cleaned up (this is achieved with `make clean`)
- Changes are made in `config/.env-*` files, not in `config/env-*.sample`
- Account corresponding to `ISSUER_PRIVATE_KEY` in `Makefile` has funds on EvmOS

## Keys

Validator (`validator_key`):
* Mnemonic: `monkey property mercy pottery perfect wonder happy method legend gather link scorpion cruise alcohol motion lava option swift retire purity luxury material car gentle`
* Address: `rarimo1q5wjzf8kfpxx3xze987ajjkr69rktk64a0wqqp`

Issuer (`issuer`):
* Mnemonic: `grocery example stay mosquito view invest enemy exotic since grief agree flee shoot cave actress sting admit buffalo access mutual case more local now`
* Address: `rarimo1ghcxdrgmy8duq8cu68fgmlp2sfmfwkh2dl4chl`

## Useful commands

Create key:
```shell
rarimo-cored keys add key_name --keyring-backend test --home=./config/validator
```

Show all keys:
```shell
rarimo-cored keys list --keyring-backend test --home=./config/validator
```

Add key to genesis:
```shell
rarimo-cored add-genesis-account key_name 1000urmo --home=./config/validator
# urmo is default currency
```

Apply changes in genesis:
```shell
rarimo-cored collect-gentxs --home=./config/validator
```
