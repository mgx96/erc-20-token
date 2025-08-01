# Token – Custom ERC-20 Token

This project contains a fully functional ERC-20 token written in Solidity, with features including:

- Token transfers
- Ownership and access control (`Ownable`)
- Minting and burning
- Pausing/unpausing token activity (`Pausable`)

## Contracts

- `MyToken.sol` – Main token logic
- `Ownable.sol` – Restricts access to admin-only functions
- `Pausable.sol` – Adds emergency pause/resume functionality

## Getting Started

Use [Remix](https://remix.ethereum.org/) or a local development environment like Hardhat or Foundry to compile and deploy the contracts.

## License

MIT