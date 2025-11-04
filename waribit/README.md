# WariBit (WARI)

A simple fungible token smart contract written in Clarity for the Stacks blockchain. The token supports owner-controlled minting, burning, pause/unpause, and ERC-20-like allowances.

- Name: WariBit
- Symbol: WARI
- Decimals: 6

## Features
- Owner can mint new tokens to any principal
- Any holder can burn their own tokens
- Transfers can be paused/unpaused by the owner
- Approve/allowance/transfer-from flow for spenders
- Read-only metadata (name, symbol, decimals), balances, total supply, owner

## Files
- `contracts/waribit.clar` – core token logic
- `Clarinet.toml` – Clarinet project configuration
- `tests/waribit.test.ts` – test scaffold

## Install Clarinet
If you don’t have Clarinet:

- Using npm (recommended):
  ```bash
  npm install -g @hirosystems/clarinet
  ```
- Using cargo (alternative):
  ```bash
  cargo install --locked clarinet
  ```

Verify:
```bash
clarinet --version
```

## Quick start
From this directory:
```bash
clarinet check        # typecheck and lint Clarity contracts
npm install           # install test tooling (optional)
npm test              # run unit tests (optional)
```

## Contract interface
Public functions:
- `(transfer (recipient principal) (amount uint)) -> (response bool uint)`
- `(approve (spender principal) (amount uint)) -> (response bool uint)`
- `(transfer-from (sender principal) (recipient principal) (amount uint)) -> (response bool uint)`
- `(mint (recipient principal) (amount uint)) -> (response bool uint)` [owner-only]
- `(burn (amount uint)) -> (response bool uint)`
- `(set-owner (new-owner principal)) -> (response principal uint)` [owner-only]
- `(set-paused (flag bool)) -> (response bool uint)` [owner-only]

Read-only functions:
- `(get-owner) -> (response principal uint)`
- `(get-paused) -> (response bool uint)`
- `(get-total-supply) -> (response uint uint)`
- `(get-name) -> (response (string-ascii 32) uint)`
- `(get-symbol) -> (response (string-ascii 32) uint)`
- `(get-decimals) -> (response uint uint)`
- `(get-balance (who principal)) -> (response uint uint)`
- `(get-allowance (owner principal) (spender principal)) -> (response uint uint)`

Error codes:
- `u100` – not authorized
- `u101` – token transfers paused
- `u102` – insufficient balance
- `u103` – insufficient allowance
- `u104` – zero amount not allowed

## Usage examples
- Mint 1,000,000 WARI (considering 6 decimals) to yourself (owner only):
```clarity
(contract-call? .waribit mint tx-sender u1000000)
```
- Transfer 100 WARI to another principal:
```clarity
(contract-call? .waribit transfer 'SP3FBR2AGK1... u100)
```
- Approve 500 WARI for a spender:
```clarity
(contract-call? .waribit approve 'SP2C2YH3... u500)
```
- Spender moves funds from owner (after approval):
```clarity
(contract-call? .waribit transfer-from 'SP3FBR2AGK1... 'SP2C2YH3... u250)
```

## Development notes
- This contract intentionally does not declare SIP-010 compliance to avoid external trait dependencies during local development. It mirrors the common FT interface for convenience.
- To add more contracts or traits, place them under `contracts/` and update `Clarinet.toml`.

## License
MIT
