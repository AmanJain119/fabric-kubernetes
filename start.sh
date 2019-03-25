export FABRIC_CFG_PATH=${PWD}
CHANNEL1_NAME="channel1"
COMPOSE_FILE=docker-compose-cli.yaml
COMPOSE_FILE_COUCH=docker-compose-couch.yaml

echo "Generate Certificates\n"
cryptogen generate --config=./crypto-config.yaml

echo "Generate Artifcats\n"
configtxgen -profile ThreeOrgsOrdererGenesis -channelID sahil -outputBlock ./channel-artifacts/genesis.block

echo "Create Channel\n"
configtxgen -profile Org1Org2 -outputCreateChannelTx ./channel-artifacts/channel1.tx -channelID $CHANNEL1_NAME

echo "Anchor Peer for Org 1"
configtxgen -profile Org1Org2 -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL1_NAME -asOrg Org1MSP

#docker-compose -f $COMPOSE_FILE -f $COMPOSE_FILE_COUCH up

