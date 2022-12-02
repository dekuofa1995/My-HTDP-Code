(define-struct phone [area num])
;; (make-phone Number String)


(define-struct phone# [area switch num])
;; An Phone# is a structure:
;;   (make-phone# Number Number Number)
;; interpretation: a three-digtial area code,
;; a four-digtial phone switch(exchange) code,
;; a four-digtial code respect the neighborhood


