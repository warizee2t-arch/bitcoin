# Clarinet Project: Wrapped Bitcoin (wBTC)

This repository contains a minimal Clarity smart contract implementing a simple fungible token representing wrapped BTC (wBTC) for the Stacks blockchain. It is intended for local development with Clarinet.

## Structure
- `Clarinet.toml` – Clarinet project configuration
- `contracts/wbtc.clar` – Clarity contract (fungible token)

## Prerequisites
- Install Clarinet (one of):
  - `npm i -g @hirosystems/clarinet`
  - Or see: https://github.com/hirosystems/clarinet

## Quick start
```bash
# Validate and type-check the project
clarinet check

# Open a local console to interact with the contract
clarinet console
```

Inside the Clarinet console you can experiment, for example:
```lisp
;; Mint 1 wBTC (u100 sats in this example)
(contract-call? .wbtc mint tx-sender u100)

;; Check balances and supply
(contract-call? .wbtc get-balance tx-sender)
(contract-call? .wbtc get-total-supply)

;; Transfer from deployer to another principal
(contract-call? .wbtc transfer u10 tx-sender 'ST3J2GVMMM2R07ZFBJDWTYEYAR8FZH5WKDTFJ9AHA)
```

Notes:
- `mint` and `burn` are restricted to the contract owner (the deployer account).
- This is a minimal example for development/education and does not bridge real BTC.
