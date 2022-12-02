
(check-expect (distance-to-0 (make-posn 3 4)) 5)
(check-expect (distance-to-0 (make-posn 6 8)) 10)
(check-expect (distance-to-0 (make-posn 0 5)) 5)
(check-expect (distance-to-0 (make-posn 7 0)) 7)
(check-expect (distance-to-0 (make-posn 5 12)) 13)
;; distance between ap and origin point
(define (distance-to-0 ap)
  (sqrt
   (+ (sqr (posn-x ap))
      (sqr (posn-y ap)))))


(check-expect (distance-to-0 (make-posn 3 4)) 5)
;; (sqrt (+ (sqr (posn-x ap)) (sqr (posn-y ap))))
;; (sqrt (+ (sqr 3) (sqr (posn-y ap))))
;; (sqrt (+ 9 (sqr (posn-y ap))))
;; (sqrt (+ 9 (sqr 4)))
;; (sqrt (+ 9 16))
;; (sqrt 25)
;; 5
(check-expect (distance-to-0 (make-posn 6 (* 2 4))) 10)
;; (sqrt (+ (sqr (posn-x ap)) (sqr (posn-y ap))))
;; (sqrt (+ (sqr 6) (sqr (posn-y ap))))
;; (sqrt (+ 36 (sqr 8)))
;; (sqrt (+ 36 64))
;; (sqrt 100)
;; 10
(check-expect (+ 10 (distance-to-0 (make-posn 12 5))) 23)
;; (sqrt (+ (sqr (posn-x ap)) (sqr (posn-y ap))))
;; (sqrt (+ (sqr 12) (sqr (posn-y ap))))
;; (sqrt (+ 144 (sqr (posn-y ap))))
;; (sqrt (+ 144 (sqr 5)))
;; (sqrt (+ 144 25))
;; (sqrt 169)
;; 13
