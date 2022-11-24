(require 2htdp/image)
(require 2htdp/universe)

(define RED-X 15)
(define YELLOW-X 45)
(define GREEN-X 75)
(define Y 15)
(define RADIUS 12)
(define BACKG (empty-scene 90 30))
;; A N-TrafficLight is one of three:
;; - 0 interpretation the traffic light shows red 
;; - 1 interpretation the traffic light shows green
;; - 2 interpretation the traffic light shows yellow
 
;; N-TrafficLight -> N-TrafficLight
;; yields the next state, given current state cs
(check-expect (tl-next 0) 1)
(check-expect (tl-next 1) 2)
(check-expect (tl-next 2) 0)
(define (tl-next cs)
  ;; not clearly than before, reader need read NT doc to get the information abount numbers
  (cond [(= 0 cs) 1]
	[(= 1 cs) 2]
	[(= 2 cs) 0]))

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
(check-expect (tl-render 0)
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
  (place-image (tl-render/light "red" (= cs 0))
	       RED-X
	       Y
	       (place-image (tl-render/light "yellow" (= cs 1))
			    YELLOW-X
			    Y
			    (place-image (tl-render/light "green" (= cs 2))
					 GREEN-X
					 Y
					 BACKG))))

(define (main ws)
  (big-bang ws
	    [on-tick tl-next]
	    [to-draw tl-render]))

(main 0)
