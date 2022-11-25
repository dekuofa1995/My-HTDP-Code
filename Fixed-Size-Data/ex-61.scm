(require 2htdp/image)
(require 2htdp/universe)

(define RED 0)
(define GREEN 1)
(define YELLOW 2)

(define RED-X 15)
(define YELLOW-X 45)
(define GREEN-X 75)
(define Y 15)
(define RADIUS 12)
(define BACKG (empty-scene 90 30))
;; A S-TrafficLight is one of:
;; - RED
;; - GREEN
;; - YELLOW
 
;; S-TrafficLight -> S-TrafficLight
;; yields the next state, given current state cs
(check-expect (tl-next RED) GREEN)
(check-expect (tl-next GREEN) YELLOW)
(check-expect (tl-next YELLOW) RED)
(define (tl-next cs)
  ;; not clearly than before, reader need read NT doc to get the information abount numbers
  (cond [(= RED cs) GREEN]
	[(= GREEN cs) YELLOW]
	[(= YELLOW cs) RED]))
;; only work for numeric cs
(check-expect (tl-next-numeric RED) GREEN)
(check-expect (tl-next-numeric GREEN) YELLOW)
(check-expect (tl-next-numeric YELLOW) RED)
(define (tl-next-numeric cs)
  (modulo (+ cs 1) 3))
(check-expect (tl-next-symbolic RED) GREEN)
(check-expect (tl-next-symbolic GREEN) YELLOW)
(check-expect (tl-next-symbolic YELLOW) RED)

;; work for string and number variables
(define (tl-next-symbolic cs)
  (cond [(equal? cs RED) GREEN]
	[(equal? cs GREEN) YELLOW]
	[(equal? cs YELLOW) RED]))
;; Color, Bool -> Image
;; renders a traffic light, given color and light isopen flag
(check-expect (tl-render/light "red" #false) (circle RADIUS 'outline "red"))
(check-expect (tl-render/light "red" #true) (circle RADIUS 'solid "red"))
(check-expect (tl-render/light "yellow" #false) (circle RADIUS 'outline "yellow"))
(check-expect (tl-render/light "yellow" #true) (circle RADIUS 'solid "yellow"))
(check-expect (tl-render/light "green" #false) (circle RADIUS 'outline "green"))
(check-expect (tl-render/light "green" #true) (circle RADIUS 'solid "green"))
(define (tl-render/light color isopen)
  (circle RADIUS
	  (if isopen 'solid 'outline)
	  color))
;; TrafficLight -> Image
;; renders the current state cs as an image
(check-expect (tl-render RED)
	      (place-image (tl-render/light "red" #true)
			   RED-X
			   Y
			   (place-image (tl-render/light "yellow" #false)
					YELLOW-X
					Y
					(place-image (tl-render/light "green" #false)
						     GREEN-X
						     Y
						     BACKG))))
			    
(define (tl-render cs)
  (place-image (tl-render/light "red" (= cs RED))
	       RED-X
	       Y
	       (place-image (tl-render/light "yellow" (= cs GREEN))
			    YELLOW-X
			    Y
			    (place-image (tl-render/light "green" (= cs YELLOW))
					 GREEN-X
					 Y
					 BACKG))))

(define (main ws)
  (big-bang ws
	    [on-tick tl-next]
	    [to-draw tl-render]))

(main RED)
