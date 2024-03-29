#!/bin/sh

echo "VAULT CONFIGURATION SCRIPT"
echo "(./config/vault/scripts/init.sh):"
echo "===================================";

vault server -config=/vault/config/vault.json 1>&1 2>&1 &

export VAULT_ADDR=http://127.0.0.1:8200
sleep 5

FILE=/vault/data/init.out
if [ ! -e "$FILE" ]; then
    echo -e "===== Initialize the Vault ====="
    vault operator init > /vault/data/init.out
fi

UNSEAL_KEY_1=$(grep "Unseal Key 1" /vault/data/init.out | cut -c 15-)
UNSEAL_KEY_2=$(grep "Unseal Key 2" /vault/data/init.out | cut -c 15-)
UNSEAL_KEY_3=$(grep "Unseal Key 3" /vault/data/init.out | cut -c 15-)
UNSEAL_KEY_4=$(grep "Unseal Key 4" /vault/data/init.out | cut -c 15-)
UNSEAL_KEY_5=$(grep "Unseal Key 5" /vault/data/init.out | cut -c 15-)

TOKEN=$(grep "Token" /vault/data/init.out | cut -c 21-)

echo -e "\n===== Unseal the Vault ====="

vault operator unseal $UNSEAL_KEY_1
vault operator unseal $UNSEAL_KEY_2
vault operator unseal $UNSEAL_KEY_3

vault login $TOKEN
vault secrets enable -path=secret/ kv-v2
echo -e "\n===== ENABLED KV secrets ====="

IDEN3_PLUGIN_PATH="/vault/plugins/vault-plugin-secrets-iden3"

if [ ! -e "$IDEN3_PLUGIN_PATH" ]; then
	echo "===== IDEN3 Plugin not found: downloading... ====="
    IDEN3_PLUGIN_ARCH=amd64
    IDEN3_PLUGIN_VERSION=0.0.7
    if [ `uname -m` == "aarch64" ]; then
        IDEN3_PLUGIN_ARCH=arm64
    fi
    VAULT_IDEN3_PLUGIN_URL="https://github.com/iden3/vault-plugin-secrets-iden3/releases/download/v${IDEN3_PLUGIN_VERSION}/vault-plugin-secrets-iden3_${IDEN3_PLUGIN_VERSION}_linux_${IDEN3_PLUGIN_ARCH}.tar.gz"
    wget -q -O - ${VAULT_IDEN3_PLUGIN_URL} | tar -C /vault/plugins -xzf - vault-plugin-secrets-iden3
fi

apk add -q openssl
IDEN3_PLUGIN_SHA256=`openssl dgst -r -sha256 ${IDEN3_PLUGIN_PATH} | awk '{print $1}'`
vault plugin register -sha256=$IDEN3_PLUGIN_SHA256 vault-plugin-secrets-iden3
vault secrets enable -path=iden3 vault-plugin-secrets-iden3
vault secrets enable -path=kv kv-v2

chmod 755 /vault/file -R

echo "===== ENABLED IDEN3 ====="
export vault_token="token:${TOKEN}"

echo "===== CREATE POLICIES ====="
vault policy write issuernode /vault/config/policies.hcl

echo "===== CREATE USERS ====="
vault auth enable userpass

result=$(vault read auth/userpass/users/issuernode 2>&1)
echo $result

if [[ "$result" == "No value found at auth/userpass/users/issuernode" ]]; then
    echo "issuernode user nor found, creating..."
    vault write auth/userpass/users/issuernode \
        password=issuernodepwd \
        policies="admins,issuernode"
else
    echo "issuernode user found, skipping creation..."
fi

touch /vault/plugins/.initialized
echo "Vault token: $vault_token"
tail -f /dev/null