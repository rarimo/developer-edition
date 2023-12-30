include config/.env-api

vault:
	docker compose up -d vault

validator:
	docker compose up -d validator

# usage: make n=1 keygen=true tss-single (keygen is optional, running without it by default)
tss-single:
ifeq ($(keygen), true)
	TSS_MODE=keygen docker compose up -d tss-$(n)
	sleep 5
	docker compose logs tss-$(n)
	docker compose down tss-$(n)
	TSS_MODE=service docker compose up -d tss-$(n)
else
	TSS_MODE=service docker compose up -d tss-$(n)
endif

# usage: make keygen=true tss-single (keygen is optional)
tss-all:
ifeq ($(keygen), true)
	TSS_MODE=keygen docker compose up -d tss-1 tss-2 tss-3 tss-4
	sleep 5
	docker compose logs tss-1
	docker compose down tss-1 tss-2 tss-3 tss-4
	TSS_MODE=service docker compose up -d tss-1 tss-2 tss-3 tss-4
else
	TSS_MODE=service docker compose up -d tss-1 tss-2 tss-3 tss-4
endif

# usage: make key=xxx issuer
issuer: issuer-clean-vault issuer-storage issuer-add-priv-key issuer-add-vault-token issuer-generate-did issuer-services

clean: issuer-clean-vault
	docker compose down -v --remove-orphans

issuer-clean-vault:
	rm -R config/vault/data/init.out || true
	rm -R config/vault/file/core/ || true
	rm -R config/vault/file/logical/ || true
	rm -R config/vault/file/sys/ || true
	rm -R config/vault/policies || true

issuer-storage:
	docker compose up -d issuer-db issuer-redis issuer-vault
	sleep 10

issuer-services:
	docker compose up -d issuer-api issuer-api-ui issuer-notifications issuer-pending-publisher

# usage: make key=xxx issuer-add-priv-key
issuer-add-priv-key:
	docker compose exec issuer-vault \
	vault write iden3/import/pbkey key_type=ethereum private_key=$(key)

issuer-add-vault-token:
	$(eval TOKEN = $(shell docker compose logs issuer-vault 2>&1 | grep " .hvs" | awk '{print $$4}' | tail -1 ))
	sed '/ISSUER_KEY_STORE_TOKEN/d' config/.env-issuer > config/.env-issuer.tmp
	@echo ISSUER_KEY_STORE_TOKEN=$(TOKEN) >> config/.env-issuer.tmp
	mv config/.env-issuer.tmp config/.env-issuer

issuer-generate-did: issuer-initializer
	$(eval DID = $(shell docker compose logs --tail 1 issuer-initializer | awk '{print $$3}'))
	@echo "DID: $(DID)"
	sed '/ISSUER_API_UI_ISSUER_DID/d' config/.env-api > config/.env-api.tmp
	@echo ISSUER_API_UI_ISSUER_DID=$(DID) >> config/.env-api.tmp
	mv config/.env-api.tmp config/.env-api
	docker compose rm -sf issuer-initializer

# this is a separate target due to Makefile variables processing:
# if we do it inside issuer-generate-did, DID would be empty
issuer-initializer:
	docker compose up -d issuer-initializer
	sleep 5

issuer-print-vault-token:
	$(eval TOKEN = $(shell docker compose logs issuer-vault 2>&1 | grep " .hvs" | awk '{print $$4}' | tail -1 ))
	@echo $(TOKEN)

issuer-print-did:
	docker compose exec issuer-vault \
	vault kv get -mount=kv did

issuer-delete-did:
	docker compose exec issuer-vault \
	vault kv delete kv/did

# usage: make did=xxx add-did
issuer-add-did:
	docker compose exec issuer-vault \
	vault kv put kv/did did=$(did)
