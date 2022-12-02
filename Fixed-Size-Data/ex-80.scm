

(define-struct movie [title director year])

(define (movie-detail m)
  (... (movie-title m) ... (movie-director m) ... (movie-year m)))

(define-struct pet [name number])

(define (pet-func p)
  (... (pet-name p) ... (pet-number p)))

(define-struct CD [artist title price])
(define (CD-func cd)
  (... (CD-artist cd) ... (CD-title cd) ... (CD-price cd)))

(define-struct sweater [material size color])
(define (sweater-func s)
  (... (sweater-material s) ... (sweater-size s) ... (sweater-color s)))
