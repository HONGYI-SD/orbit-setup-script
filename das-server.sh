#!/bin/bash

# Read sequencerInbox address from the orbitSetupScriptConfig JSON file
SEQUENCER_INBOX_ADDRESS=0x2d6ec173b84145a079288d6DF7F85Caca78E198D

# Read the parent-chain-node-url from the nodeConfig JSON file
PARENT_CHAIN_NODE_URL=$(jq -r '.node."data-availability"."parent-chain-node-url"' /home/user/.arbitrum/node-config.json)

# Check if the "data-availability" key exists
if jq -e '.node | has("data-availability")' /home/user/.arbitrum/node-config.json >/dev/null; then
    # Start daserver with the new command
    /usr/local/bin/daserver --data-availability.parent-chain-node-url "$PARENT_CHAIN_NODE_URL" --enable-rpc --rpc-addr '0.0.0.0' --enable-rest --rest-addr '0.0.0.0' --log-level 3 --data-availability.local-db-storage.enable --data-availability.local-db-storage.data-dir /home/user/das-data --data-availability.local-db-storage.discard-after-timeout=false --data-availability.key.key-dir /home/user/.arbitrum/keys --data-availability.local-cache.enable --data-availability.sequencer-inbox-address $SEQUENCER_INBOX_ADDRESS
else
    # Log a message and exit if "data-availability" key doesn't exist
    echo "You're running in Rollup mode. No need for das-server, so exiting the container ..."
    exit
fi
