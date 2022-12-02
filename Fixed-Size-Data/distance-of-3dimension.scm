

(define-struct r3 [x y z])
;; A R3 is a structure:
;;   (make-r3 Number Number Number)

(define ex1 (make-r3 1 2 13))
(define ex2 (make-r3 -1 0 3))

;; R3 -> Number
;; computes the distance between given r3 and origin point in 3-dimensional space
(check-expect (r3-distance-to-0 (make-r3 1 0 0)) 1)
(check-expect (r3-distance-to-0 (make-r3 0 2 0)) 2)
(check-expect (r3-distance-to-0 (make-r3 0 0 3)) 3)
(check-expect (inexact->exact (r3-distance-to-0 ex2))
	      (inexact->exact (sqrt 10)))
(check-expect (inexact->exact (r3-distance-to-0 ex1))
	      (inexact->exact (sqrt 174)))
(check-expect (r3-distance-to-0 (make-r3 0 0 0)) 0)
(define (r3-distance-to-0 r3)
  (sqrt (+ (sqr (r3-x r3))
	   (sqr (r3-y r3))
	   (sqr (r3-z r3)))))


