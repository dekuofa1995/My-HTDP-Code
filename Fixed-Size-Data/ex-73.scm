
(check-expect (posn-up-x (make-posn 3 4) 5)
	      (make-posn 5 4))
(check-expect (posn-up-x (make-posn 8 4) 8)
	      (make-posn 8 4))
(define (posn-up-x posn x)
  (make-posn x (posn-y posn)))

(check-expect (x+ (make-posn 3 4)) (make-posn 6 4))
(define (x+ p)
  (posn-up-x p (+ 3 (posn-x p))))
