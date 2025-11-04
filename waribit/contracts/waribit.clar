;; title: WariBit (WARI)
;; clarity: v3
;; summary: A simple fungible token with owner-controlled minting, burning, pause, and allowances.
;; description: Non-SIP demo FT for development; provides transfer/approve/transfer-from/mint/burn and basic admin controls.

(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-PAUSED (err u101))
(define-constant ERR-INSUFFICIENT-BALANCE (err u102))
(define-constant ERR-INSUFFICIENT-ALLOWANCE (err u103))
(define-constant ERR-ZERO-AMOUNT (err u104))

;; metadata
(define-constant TOKEN-NAME "WariBit")
(define-constant TOKEN-SYMBOL "WARI")
(define-constant TOKEN-DECIMALS u6)

;; state
(define-data-var owner principal tx-sender)
(define-data-var paused bool false)
(define-data-var total-supply uint u0)

(define-map balances { who: principal } { amount: uint })
(define-map allowances { owner: principal, spender: principal } { amount: uint })

;; helpers
(define-read-only (get-owner) (ok (var-get owner)))
(define-read-only (get-paused) (ok (var-get paused)))
(define-read-only (get-total-supply) (ok (var-get total-supply)))
(define-read-only (get-name) (ok TOKEN-NAME))
(define-read-only (get-symbol) (ok TOKEN-SYMBOL))
(define-read-only (get-decimals) (ok TOKEN-DECIMALS))

(define-read-only (get-balance (who principal))
  (ok (default-to u0 (get amount (map-get? balances { who: who })))))

(define-read-only (get-allowance (token-owner principal) (spender principal))
  (ok (default-to u0 (get amount (map-get? allowances { owner: token-owner, spender: spender })))))

(define-private (is-owner (who principal))
  (is-eq who (var-get owner)))

(define-private (ensure-not-paused)
  (if (var-get paused)
      ERR-PAUSED
      (ok true)))

;; admin
(define-public (set-owner (new-owner principal))
  (if (not (is-owner tx-sender))
      ERR-NOT-AUTHORIZED
      (begin
        (var-set owner new-owner)
        (ok new-owner))))

(define-public (set-paused (flag bool))
  (if (not (is-owner tx-sender))
      ERR-NOT-AUTHORIZED
      (begin
        (var-set paused flag)
        (ok flag))))

;; token mechanics
(define-public (transfer (recipient principal) (amount uint))
  (if (var-get paused)
      ERR-PAUSED
      (if (is-eq amount u0)
          ERR-ZERO-AMOUNT
          (let ((sender tx-sender))
            (try! (debit sender amount))
            (credit recipient amount)
            (ok true)))))

(define-public (approve (spender principal) (amount uint))
  (if (var-get paused)
      ERR-PAUSED
      (begin
        (map-set allowances { owner: tx-sender, spender: spender } { amount: amount })
        (ok true))))

(define-public (transfer-from (sender principal) (recipient principal) (amount uint))
  (if (var-get paused)
      ERR-PAUSED
      (if (is-eq amount u0)
          ERR-ZERO-AMOUNT
          (let (
                (allow (default-to u0 (get amount (map-get? allowances { owner: sender, spender: tx-sender }))))
               )
            (if (>= amount allow)
                ERR-INSUFFICIENT-ALLOWANCE
                (begin
                  (try! (debit sender amount))
                  (credit recipient amount)
                  (map-set allowances { owner: sender, spender: tx-sender } { amount: (- allow amount) })
                  (ok true)
                )
            )
          )
      )
  ))

(define-public (mint (recipient principal) (amount uint))
  (if (not (is-owner tx-sender))
      ERR-NOT-AUTHORIZED
      (if (is-eq amount u0)
          ERR-ZERO-AMOUNT
          (begin
            (var-set total-supply (+ (var-get total-supply) amount))
            (credit recipient amount)
            (ok true)))))

(define-public (burn (amount uint))
  (if (var-get paused)
      ERR-PAUSED
      (if (is-eq amount u0)
          ERR-ZERO-AMOUNT
          (begin
            (try! (debit tx-sender amount))
            (var-set total-supply (- (var-get total-supply) amount))
            (ok true)))))

;; internal balance helpers
(define-private (debit (from principal) (amount uint))
  (let ((bal (default-to u0 (get amount (map-get? balances { who: from })))))
    (if (>= amount bal)
        ERR-INSUFFICIENT-BALANCE
        (begin
          (map-set balances { who: from } { amount: (- bal amount) })
          (ok true)))))

(define-private (credit (who principal) (amount uint))
  (let ((bal (default-to u0 (get amount (map-get? balances { who: who })))))
    (map-set balances { who: who } { amount: (+ bal amount) })
    true))
