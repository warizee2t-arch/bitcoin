# Bitcoin Address Registry (Clarinet / Clarity)

This project contains a simple Clarity smart contract, built for Clarinet, that lets Stacks principals register and query their Bitcoin addresses.

## Files
- `Clarinet.toml` — Clarinet project configuration
- `contracts/btc-registry.clar` — Clarity contract implementing a BTC address registry

## Prerequisites
- Clarinet installed
  - Windows (PowerShell): `iwr -useb https://get.hiro.so/clarinet/install.ps1 | iex`
  - Check installation: `clarinet --version`

## Quick start
1. Validate the project:
   - `clarinet check`
2. Open the Clarinet console to try calls:
   - `clarinet console`
3. From the console, register a BTC address for the default wallet:
   - `(contract-call? .btc-registry set-address "bc1qexampleaddress000000000000000000000000")`
4. Read it back:
   - `(contract-call? .btc-registry my-address)`
   - `(contract-call? .btc-registry get-address 'ST1J...REPLACE-WITH-ADDR)`
5. Clear your address:
   - `(contract-call? .btc-registry clear-address)`

## Contract behavior
- Stores a mapping from Stacks principal -> Bitcoin address string (up to 90 chars).
- Performs a basic length check (25–90 chars) to loosely validate the address.
- Addresses can be updated or cleared by the owner only (the tx-sender).

## Notes
- This contract does not validate full Bitcoin address formats or signatures.
- Use this as a starting point for BTC-related apps on Stacks (e.g., linking BTC addresses to Stacks identities).
