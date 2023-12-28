include config/.env-api

vault:
	docker compose up -d vault

validator:
	docker compose up -d validator

# usage: make n=1 keygen=true tss-single (keygen is optional, running in service mode by default)
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

# usage: make private_key=xxx issuer
issuer: issuer-clean-vault issuer-storage add-private-key add-vault-token generate-issuer-did issuer-services

clean: issuer-clean-vault
	docker compose down -v --remove-orphans

issuer-clean-vault:
	rm -R config/vault/data/init.out || true
	rm -R config/vault/file/core/ || true
	rm -R config/vault/file/logical/ || true
	rm -R config/vault/file/sys/ || true
	rm -R config/vault/policies || true

issuer-storage:
	docker compose up -d vault issuer-db issuer-redis

issuer-services:
	docker compose up -d issuer-api issuer-api-ui issuer-notifications issuer-pending-publisher

# usage: make private_key=xxx add-private-key
add-private-key:
	docker compose exec vault \
	vault write iden3/import/pbkey key_type=ethereum private_key=$(private_key)

add-vault-token:
	$(eval TOKEN = $(shell docker compose logs vault 2>&1 | grep " .hvs" | awk  '{print $$2}' | tail -1 ))
	sed '/ISSUER_KEY_STORE_TOKEN/d' config/.env-issuer > config/.env-issuer.tmp
	@echo ISSUER_KEY_STORE_TOKEN=$(TOKEN) >> config/.env-issuer.tmp
	mv config/.env-issuer.tmp config/.env-issuer

generate-issuer-did:
	docker compose up -d issuer-initializer
	sleep 5
	docker compose logs issuer-initializer
	$(eval DID = $(shell docker compose logs -f --tail 1 issuer-initializer | grep "did"))
	@echo $(DID)
	sed '/ISSUER_API_UI_ISSUER_DID/d' config/.env-api > config/.env-api.tmp
	@echo ISSUER_API_UI_ISSUER_DID=$(DID) >> config/.env-api.tmp
	mv config/.env-api.tmp config/.env-api
	docker compose rm -sf issuer-initializer

print-vault-token:
	$(eval TOKEN = $(shell docker compose logs vault 2>&1 | grep " .hvs" | awk  '{print $$2}' | tail -1 ))
	@echo $(TOKEN)

print-did:
	docker compose exec vault \
	vault kv get -mount=kv did

delete-did:
	docker compose exec issuer-vault \
	vault kv delete kv/did

# usage: make did=xxx add-did
add-did:
	docker compose exec issuer-vault \
	vault kv put kv/did did=$(did)
