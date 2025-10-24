# clarinet-bitcoin

A minimal Clarinet (Clarity) project with a simple contract `bitcoin.clar`.

## Prerequisites
- Install Clarinet: https://docs.hiro.so/clarity/clarinet

## Project layout
```
clarinet-bitcoin/
├─ Clarinet.toml
├─ contracts/
│  └─ bitcoin.clar
```

## Usage
```powershell
cd clarinet-bitcoin
clarinet check
```

Open a console to interact:
```powershell
clarinet console
```
In the console, you can call functions like:
```lisp
(contract-call? .bitcoin set-message "Hello Bitcoin")
(contract-call? .bitcoin get-message)
```

## Contract summary
- Owner can:
  - set-message: store a short message
  - transfer-ownership: change owner
- Read-only:
  - get-message, get-owner
