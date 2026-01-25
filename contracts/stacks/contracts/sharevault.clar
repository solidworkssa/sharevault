;; ShareVault - Encrypted file sharing

(define-data-var doc-counter uint u0)

(define-map documents uint {
    owner: principal,
    ipfs-hash: (string-ascii 64),
    timestamp: uint,
    active: bool
})

(define-map access-control {doc-id: uint, user: principal} bool)

(define-constant ERR-UNAUTHORIZED (err u101))

(define-public (store-document (ipfs-hash (string-ascii 64)))
    (let ((doc-id (var-get doc-counter)))
        (map-set documents doc-id {
            owner: tx-sender,
            ipfs-hash: ipfs-hash,
            timestamp: block-height,
            active: true
        })
        (map-set access-control {doc-id: doc-id, user: tx-sender} true)
        (var-set doc-counter (+ doc-id u1))
        (ok doc-id)))

(define-public (grant-access (doc-id uint) (user principal))
    (let ((doc (unwrap! (map-get? documents doc-id) ERR-UNAUTHORIZED)))
        (asserts! (is-eq (get owner doc) tx-sender) ERR-UNAUTHORIZED)
        (ok (map-set access-control {doc-id: doc-id, user: user} true))))

(define-public (revoke-access (doc-id uint) (user principal))
    (let ((doc (unwrap! (map-get? documents doc-id) ERR-UNAUTHORIZED)))
        (asserts! (is-eq (get owner doc) tx-sender) ERR-UNAUTHORIZED)
        (ok (map-delete access-control {doc-id: doc-id, user: user}))))

(define-read-only (get-document (doc-id uint))
    (ok (map-get? documents doc-id)))

(define-read-only (has-access (doc-id uint) (user principal))
    (ok (default-to false (map-get? access-control {doc-id: doc-id, user: user}))))
