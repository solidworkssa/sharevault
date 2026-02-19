;; ────────────────────────────────────────
;; ShareVault v1.0.0
;; Author: solidworkssa
;; License: MIT
;; ────────────────────────────────────────

(define-constant VERSION "1.0.0")

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-ALREADY-EXISTS (err u409))
(define-constant ERR-INVALID-INPUT (err u422))

;; ShareVault Clarity Contract
;; Encrypted file sharing registry.


(define-map files
    uint
    {
        cid: (string-ascii 64),
        owner: principal
    }
)
(define-map access {file-id: uint, user: principal} bool)
(define-data-var file-nonce uint u0)

(define-public (upload-file (cid (string-ascii 64)))
    (let ((id (var-get file-nonce)))
        (map-set files id {cid: cid, owner: tx-sender})
        (var-set file-nonce (+ id u1))
        (ok id)
    )
)

(define-public (grant-access (id uint) (user principal))
    (let ((f (unwrap! (map-get? files id) (err u404))))
        (asserts! (is-eq tx-sender (get owner f)) (err u401))
        (map-set access {file-id: id, user: user} true)
        (ok true)
    )
)

