(require 2htdp/image)
(require 2htdp/universe)

(define-struct vel [deltax deltay])

(define-struct ufo [loc vel])

(define v1 (make-vel 8 -3))
(define v2 (make-vel -5 -3))

(define p1 (make-posn 22 80))
(define p2 (make-posn 30 77))

(define u1 (make-ufo p1 v1))
(define u2 (make-ufo p1 v2))
(define u3 (make-ufo p2 v1))
(define u4 (make-ufo p2 v2))


;; UFO -> UFO
;; determines where u moves in one clock tick
;; leaves the velocity as is
(check-expect (ufo-move-1 u1) u3)
(check-expect (ufo-move-1 u2) (make-ufo (make-posn 17 77) v2))
(define (ufo-move-1 u)
  (make-ufo (posn+ (ufo-loc u) (ufo-vel u))
	    (ufo-vel u)))

;; handle the same level of nested structures
;; Posn, Vel -> Posn
;; return new Posn by given p and v
(check-expect (posn+ (make-posn 4 3)
		     (make-vel 3 3))
	      (make-posn 7 6))
(check-expect (posn+ (make-posn 4 3)
		     (make-vel -2 -1))
	      (make-posn 2 2))
(check-expect (posn+ (make-posn 4 3)
		     (make-vel -6 -1))
	      (make-posn -2 2))
(define (posn+ p v)
  (make-posn
   (+ (posn-x p) (vel-deltax v))
   (+ (posn-y p) (vel-deltay v))))
   
