#! /bin/bash
echo "HELLO"
source ./state_sync_vars.sh
source ./peers.sh


INTERVAL=100
LATEST_HEIGHT=$(curl -s "http://58.65.160.225:26687/block" | jq -r .result.block.header.height)
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL)) 
TRUST_HASH=$(curl -s "http://58.65.160.225:26687/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# Print out block and transaction hash from which to sync state.
echo "trust_height: $BLOCK_HEIGHT"
echo "trust_hash: $TRUST_HASH"

update_test_genesis '.app_state["gov"]["voting_params"]["voting_period"] = "50s"'
update_test_genesis '.app_state["mint"]["params"]["mint_denom"]=$DENOM' $DENOM


export PYLONSD_P2P_PERSISTENT_PEERS="b5f354db4339c374c9f7b206298f32f4744fa5f9@58.65.160.225:26686"
pylonsd start --rpc.laddr tcp://0.0.0.0:26657
