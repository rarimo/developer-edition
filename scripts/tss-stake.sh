#!/bin/sh

STAKER=rarimo1q5wjzf8kfpxx3xze987ajjkr69rktk64a0wqqp
RARIMO_NODE=tcp://validator:26657

# stake <tss-number> <tss-account-address> <trial-pubkey>
stake() {
	echo "===== Submit staking tx for tss-$1 ====="
	rarimo-core tx rarimocore stake $2 tcp://tss-$1 $3\
		--from=$STAKER\
		--chain-id=rarimo_666-1\
		--home=/validator\
		--keyring-backend=test\
		--fees=0urmo\
		--node=$RARIMO_NODE\
		--yes
	sleep 4 # wait for an account sequence to be updated
}

stake 1 rarimo1zcp0u36xuuze0a7qffh85r9rqj726hz40juv00 0xcf387fe86c9bb1cf41222cbf47b34a8e58e79bc43a138e44921d64cb9e38e47a
stake 2 rarimo1mqjv3c84wrxkx3vnrtnwv3xkng8xa04tjquf22 0x2e23ed1c3a0c1f44e26233bc69f7ddcd14caf4718ed33a3f4ef2b5fa883ffb88
stake 3 rarimo187clm2ltv0wn3y0qz8vhje7vh5elsyrwxznfz5 0x9085722cc252de8cdce50990387df6ab04d4e46568f123172d689798626dd7ea
stake 4 rarimo1awqtexrljtejm8a857yw4h9g6ec5gysffth4h7 0x8fffd64693359403da21ac75aca6ed75c69300e31e7efe16dc74d6360abd6adb
