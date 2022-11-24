(require 2htdp/image)
(require 2htdp/universe)

(define (half num) (/ num 2))
;; constants
(define WIDTH-OF-WORLD 400)
(define HEIGHT-OF-WORLD 120)

(define STEP 3)
(define CAT-Y (half (image-height cat1)))
(define START-X (half (image-width cat1)))
;; graphis constants
;; (define cat1 ...)
(define BACKGROUND (empty-scene WIDTH-OF-WORLD HEIGHT-OF-WORLD))
(define WIDTH-OF-IMG (image-width cat1))
(define INIT-STATE 0)
;; program

;; WorldState, Number -> Number
;; get current distance from right margin by the given
;; world width, current world state, image width
;; given: 400 0 150; wanted: 325
;; given: 400 20 150; wanted: 305
;; given: 400 55 150; wanted: 270
(check-expect (distance-from-right 400 0 150) 250)
(check-expect (distance-from-right 400 20 150) 230)
(check-expect (distance-from-right 400 100 150) 150)

(define (distance-from-right world-width cw img-width)
  (- world-width cw img-width))
(define (end? cw)
  (<= (distance-from-right WIDTH-OF-WORLD cw WIDTH-OF-IMG) 0))

(define (x-coordinate cw)
  (+ cw START-X))

(define (render cw)
  (place-image cat1 (x-coordinate cw) CAT-Y BACKGROUND))

(define (tock cw)
  (if (end? (+ STEP cw))
      INIT-STATE
      (+ STEP cw)))

;; Number -> Void
;; according the given start point,
;; move image from left to right
;;
(define (cat-prog start)
  (big-bang start
	    [to-draw render]
	    [on-tick tock]))
	    
   
