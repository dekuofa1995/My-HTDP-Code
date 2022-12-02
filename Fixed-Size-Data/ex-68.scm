

(define-struct ball [location velocity])
(define-struct vel [deltax deltay])
(define ball1 (make-ball (make-posn 30 40)
			 (make-vel -10 5)))
  
;; flat representation
(define-struct ballf [x y deltax deltay])

(make-ballf 30 40 -10 5)
