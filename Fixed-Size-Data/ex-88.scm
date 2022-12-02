
(define-struct vcat [x h])
;; A VCat is a structure:
;;   (make-cat Number Number)
;; x describes the vcat's current x-coordinate
;; h describes the vcat's current happniess
(define c1 (make-cat [0 100]))
(define c2 (make-cat [50 50]))
(define c3 (make-cat [50 0]))

(provide all-defined-out)
