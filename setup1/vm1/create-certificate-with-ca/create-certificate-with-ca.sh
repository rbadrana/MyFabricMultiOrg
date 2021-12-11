createcertificatesForOrg1() {
  echo
  echo "Enrolling the CA Admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/org1.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/org1.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.org1.example.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  #below is Node orgnization unit which we have to put inside each MSP such as we have four units: Client, Orderer, Peer and Admin unit
  echo 'NodeOUs:  
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/org1.example.com/msp/config.yaml

  #first we have to register every entity or unit and then Enroll using fabric-ca-client to create MSP
  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register user1"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register user2"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name user2 --id.secret user2pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
  
  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/org1.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp --csr.hosts peer0.org1.example.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/config.yaml

  #tls certifactes are also generated and required for secure communication between units such as peers of same or diffrent organization
  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls --enrollment.profile tls --csr.hosts peer0.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/org1.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/org1.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/org1.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p ../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp --csr.hosts peer1.org1.example.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls --enrollment.profile tls --csr.hosts peer1.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/org1.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/org1.example.com/users/User1@org1.example.com

  #we dont need to create msp for users or admin
  echo
  echo "## Generate the user1 msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/org1.example.com/users/User2@org1.example.com
  
  echo
  echo "## Generate the user2 msp"
  echo
  fabric-ca-client enroll -u https://user2:user2pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config/peerOrganizations/org1.example.com/users/User2@org1.example.com/msp --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
  
  mkdir -p ../crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml

}

createcertificatesForOrg1
