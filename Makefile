PRIVATE_KEY=

all:
	docker compose up -d vault
	sleep 5
	curl \
		-H "X-Vault-Token: 00000000-0000-0000-0000-000000000000" \
		-H "Content-Type: application/json" \
		-X POST \
		-d '{"data":{"private_key":"$(PRIVATE_KEY)"}}' \
		http://localhost:8201/v1/secret/data/relayer
	sleep 2
	docker compose up -d registration-relayer