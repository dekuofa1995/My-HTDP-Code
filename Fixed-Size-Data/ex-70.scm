(define-struct centry [name home office cell])
(define-struct phone [area number])

(phone-area
 (centry-office
  (make-centry "Shriram Fisler"
	       (make-phone 207 "363-2421")
	       (make-phone 101 "776-1099")
	       (make-phone 208 "112-9981"))))

;; (phone-area (make-phone 101 "776-1099"))
;; 101
