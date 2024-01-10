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
	sleep 6 # wait for the account sequence to be updated
}

stake 1 rarimo1zcp0u36xuuze0a7qffh85r9rqj726hz40juv00 0x024f935e83c2f993545157fc2d927e8f4de80b0697efb1900a8b190fe405f8da1e
stake 2 rarimo1mqjv3c84wrxkx3vnrtnwv3xkng8xa04tjquf22 0x02390d661746d63dbf4a76f3ffece7199322507af5d1cf262bdd65715c4f791ce8
stake 3 rarimo187clm2ltv0wn3y0qz8vhje7vh5elsyrwxznfz5 0x03b2e189fad79b92cde7f8ea49c800cfe9209fd3fdbe63ebf8a226b742df3752b4
stake 4 rarimo1awqtexrljtejm8a857yw4h9g6ec5gysffth4h7 0x039cd3ced0ff6630a27e0272c697ba5b685dd815bf284dc47b85a4442660943f80
