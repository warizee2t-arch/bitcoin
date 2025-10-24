;; Wrapped Bitcoin (wBTC) - minimal fungible token in Clarity

(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u101))

(define-data-var total-supply uint u0)
(define-map balances { who: principal } { balance: uint })

(define-read-only (get-name) "Wrapped Bitcoin")
(define-read-only (get-symbol) "wBTC")
(define-read-only (get-decimals) u8)

(define-read-only (get-total-supply)
  (var-get total-supply)
)

(define-read-only (balance-of (who principal))
  (match (map-get? balances { who: who })
    entry (get balance entry)
    u0)
)

(define-read-only (get-balance (who principal))
  (balance-of who)
)

(define-public (mint (to principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender (contract-owner)) ERR-NOT-AUTHORIZED)
    (let (
          (current (balance-of to))
          (new-bal (+ current amount))
          (new-supply (+ (var-get total-supply) amount))
         )
      (map-set balances { who: to } { balance: new-bal })
      (var-set total-supply new-supply)
      (ok true)
    )
  )
)

(define-public (burn (from principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender (contract-owner)) ERR-NOT-AUTHORIZED)
    (let ((current (balance-of from)))
      (asserts! (>= current amount) ERR-INSUFFICIENT-BALANCE)
      (map-set balances { who: from } { balance: (- current amount) })
      (var-set total-supply (- (var-get total-supply) amount))
      (ok true)
    )
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) ERR-NOT-AUTHORIZED)
    (let ((sender-bal (balance-of sender)))
      (asserts! (>= sender-bal amount) ERR-INSUFFICIENT-BALANCE)
      (map-set balances { who: sender } { balance: (- sender-bal amount) })
      (let ((recipient-bal (balance-of recipient)))
        (map-set balances { who: recipient } { balance: (+ recipient-bal amount) }))
      (ok true)
    )
  )
)
