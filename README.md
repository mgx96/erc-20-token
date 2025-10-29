![Solidity](https://img.shields.io/badge/Solidity-0.8.30-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Framework](https://img.shields.io/badge/Framework-Foundry-orange)
![Coverage](https://img.shields.io/badge/Test%20Coverage-100%25-brightgreen)
![Status](https://img.shields.io/badge/Status-Local%20Development-lightgrey)

# ERC-20 Token (MyToken)

A modern, gas-optimized ERC-20 implementation written in Solidity and built using the Foundry toolchain.  
The contract suite features ownership control, pausability, custom errors, event-driven architecture, and full test coverage.

---

## Features

- **ERC-20 compliant** with full test suite  
- **Gas efficient design** using custom errors and minimal storage reads  
- **Ownership control** (`Ownable`)  
- **Pause / Unpause functionality** (`Pausable`)  
- **Minting & Burning** restricted to the owner  
- **100% line and branch coverage** (24 passing tests)  

---

## Contracts

| Contract | Description |
|-----------|--------------|
| `Ownable.sol` | Ownership logic with secure transfer and renounce features |
| `Pausable.sol` | Contract-level pause control using modifiers and events |
| `ERC-20 Token.sol` | Core ERC-20 implementation with mint/burn support |
| `DeployToken.s.sol` | Foundry deployment script for local or live networks |

---

## Project Structure

```
src/
 ├── ERC-20 Token.sol
 ├── Ownable.sol
 └── Pausable.sol
script/
 └── DeployToken.s.sol
test/
 └── TokenTest.t.sol
```

---

## Getting Started

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed  
- Local or testnet RPC endpoint (e.g., Anvil, Sepolia)

### Installation
```bash
git clone https://github.com/mgx96/erc-20-token.git
cd erc-20-token
forge install
```

### Running Tests
```bash
forge test -vvv
```

### Running Coverage
```bash
forge coverage --report summary
```

---

## Deployment

A Foundry deployment script is included:

```bash
forge script script/DeployToken.s.sol --broadcast --rpc-url <YOUR_RPC_URL>
```

> ℹ️ The current version is optimized for local development and testing.  
> It has not yet been deployed on any live network.

---

## License

[MIT](LICENSE)

