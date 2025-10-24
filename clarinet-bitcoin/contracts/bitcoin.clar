(define-constant ERR-NOT-OWNER u100)

(define-data-var owner principal tx-sender)
(define-data-var message (optional (string-utf8 140)) none)

(define-read-only (get-owner)
  (ok (var-get owner)))

(define-public (transfer-ownership (new-owner principal))
  (if (is-eq tx-sender (var-get owner))
      (begin (var-set owner new-owner) (ok true))
      (err ERR-NOT-OWNER)))

(define-public (set-message (msg (string-utf8 140)))
  (if (is-eq tx-sender (var-get owner))
      (begin (var-set message (some msg)) (ok true))
      (err ERR-NOT-OWNER)))

(define-read-only (get-message)
  (ok (var-get message)))
