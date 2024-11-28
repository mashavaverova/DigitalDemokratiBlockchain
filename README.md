Digital Demokrati (swe)
Short description

A modular and secure decentralized voting system designed for scalability and cross-chain compatibility. This platform enables users to participate in transparent polls through direct voting, delegation, and gasless transactions via meta-transactions. Key features include proposal and prediction management, cross-chain poll result bridging, and comprehensive delegation tracking to support decentralized representation.

The main repository can be found at https://github.com/lokehagberg/flowback-frontend

The project is fully open source and built with modularity in mind, allowing for seamless integration of additional functionalities while optimizing gas costs and maintaining secure, verifiable operations. My work involves auditing and optimizing the platform, adding a prepaid voting function, and enhancing cross-chain capabilities to ensure a scalable and trustless democratic process.


Specification:
 # Prerequisites

Ensure the following are installed on your system:

1. Foundry  
   Install Foundry:
   ```
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. Clone the Repository 

3. Install Dependencies
Install any Solidity dependencies:
```
forge install
```

4. Configuration
Set up your .env file for deployment. Create the file and fill in the following:
```
PRIVATE_KEY=[your_private_key]
BASE_RPC_URL=[Base_network_RPC_URL]
ETH_RPC_URL=[Ethereum_network_RPC_URL]
```
