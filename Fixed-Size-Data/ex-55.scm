(define (show x)
  (cond [(string? x)
	 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG)]
	[(<= -3 x -1)
	 (place-image (text (number->string x) 20 "red")
		      10 (* 3/4 WIDTH)
		      (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))]
	[(>= x 0)
	 (place-image ROCKET
		      10
		      (- x CENTER)
		      BACKG)]))
;; A:

(define (show/rocket x)
  (place-image 10 (- x CENTER) BACKG))

(define (show x)
  (cond [(string? x)
	 (show/rocket HEIGHT)]
	[(<= -3 x -1)
	 (place-image (text (number->string x) 20 "red")
		      10
		      (* 3/4 WIDTH)
		      (show/rocket HEIGHT))]
	[(>= x 0) (show/rocket HEIGHT)]))
