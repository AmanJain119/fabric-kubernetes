export CC_SRC_PATH="github.com/chaincode/chaincode_example02/go/"
export CHANNEL1="channel1"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

echo "Create channel 1\n"
peer channel create -o orderer:7050 -c $CHANNEL1 -f ./channel-artifacts/channel1.tx --tls true --cafile $ORDERER_CA

echo "Join channel 1\n"
setGlobals 0 1
peer channel join -b $CHANNEL1.block

setGlobals 0 1
peer channel update -o orderer:7050 -c $CHANNEL1 -f ./channel-artifacts/Org1MSPanchors.tx --tls true --cafile $ORDERER_CA

setGlobals 0 1
peer chaincode install -n mycc -v 1.0 -p ${CC_SRC_PATH}

peer chaincode instantiate -o orderer:7050 --tls true --cafile $ORDERER_CA -C $CHANNEL1 -n mycc -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "OR ('Org1MSP.peer')"
