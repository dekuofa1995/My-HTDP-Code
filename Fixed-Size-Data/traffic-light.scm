(require 2htdp/image)
(require 2htdp/universe)

(define RED-X 15)
(define YELLOW-X 45)
(define GREEN-X 75)
(define Y 15)

(define BACKG (empty-scene 90 30))
;; A TrafficLight is one of three:
;; - "red"
;; - "green"
;; - "yellow"
;; interpertation the color of traffic light
 
;; TrafficLight -> TrafficLight
;; yields the next state, given current state cs
(check-expect (tl-next "red") "green")
(check-expect (tl-next "green") "yellow")
(check-expect (tl-next "yellow") "red")
(define (tl-next cs)
  (cond [(string=? cs "red") "green"]
	[(string=? cs "green") "yellow"]
	[(string=? cs "yellow") "red"]))

;; TrafficLight, Bool -> Image
;; renders a traffic light, given color and light isopen flag
(check-expect (tl-render/light "red" #false) (circle 15 'outline "red"))
(check-expect (tl-render/light "red" #true) (circle 15 'solid "red"))
(check-expect (tl-render/light "yellow" #false) (circle 15 'outline "yellow"))
(check-expect (tl-render/light "yellow" #true) (circle 15 'solid "yellow"))
(check-expect (tl-render/light "green" #false) (circle 15 'outline "green"))
(check-expect (tl-render/light "green" #true) (circle 15 'solid "green"))
(define (tl-render/light color isopen)
  (circle 15
	  (if isopen 'solid 'outline)
	  color))
;; TrafficLight -> Image
;; renders the current state cs as an image
(check-expect (tl-render "red")
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
  (place-image (tl-render/light "red" (string=? cs "red"))
	       RED-X
	       Y
	       (place-image (tl-render/light "yellow" (string=? cs "yellow"))
			    YELLOW-X
			    Y
			    (place-image (tl-render/light "green" (string=? cs "green"))
					 GREEN-X
					 Y
					 BACKG))))

(define (main ws)
  (big-bang ws
	    [on-tick tl-next]
	    [to-draw tl-render]))

(main "red")
