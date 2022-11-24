(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 100)
(define HEIGHT 60)

(define MTSCN (empty-scene WIDTH HEIGHT))

(define ROCKET ..)

(define ROCKET-CENTER-TO-TOP
  (- HEIGHT (/ (image-height ROCKET) 2)))

(define (create-rocket-scene.v5 h)
  (cond
   [(<= h ROCKET-CENTER-TO-TOP)
    (place-image ROCKET 50 h MTSCN)]
   [(> h ROCKET-CENTER-TO-TOP)
    (place-image ROCKET 50 ROCKET-CENTER-TO-TOP MTSCN)]))

(define (create-rocket-scene.v6 h)
  (place-image ROCKET
	       50
	       (cond [(<= h ROCKET-CENTER-TO-TOP) h]
		     [else ROCKET-CENTER-TO-TOP])
	       MTSCN))

(define (tock t)
  (+ t 1))

(big-bang
 0
 [on-tick tock]
 [to-draw create-rocket-scene.v6])
