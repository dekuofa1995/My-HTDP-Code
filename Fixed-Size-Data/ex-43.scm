
(require 2htdp/image)
(require 2htdp/universe)
;; constants
(define WIDTH-OF-WORLD 400)
(define HEIGHT-OF-WORLD 40)
(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))

(define CAR-BODY-HEAD 10)
(define CAR-BODY-TAIL 10)
(define CAR-BODY-WIDTH (+ CAR-BODY-HEAD CAR-BODY-TAIL (* 4 WHEEL-RADIUS) WHEEL-DISTANCE))
(define CAR-BODY-HEIGHT 15)
(define CAR-TOP-HEIGHT 8)
(define CAR-TOP-WIDTH (/ CAR-BODY-WIDTH 2))

;; graphies
(define (render-wheel radius)
  (circle radius "solid" "black"))

(define WHEEL (render-wheel WHEEL-RADIUS))
(define SPACE (rectangle WHEEL-DISTANCE WHEEL-RADIUS "solid" "white")) ;; space between two wheels
(define BOTH-WHEELS (beside WHEEL SPACE WHEEL))

(define CAR-TOP (rectangle CAR-TOP-WIDTH CAR-TOP-HEIGHT "solid" "red"))
(define CAR-BOTTOM (rectangle CAR-BODY-WIDTH CAR-BODY-HEIGHT "solid" "red"))

(define CAR-BODY (above/align "center" CAR-TOP CAR-BOTTOM))


(define CAR (underlay/xy CAR-BODY
                         CAR-BODY-TAIL
                         (+ CAR-BODY-HEIGHT CAR-TOP-HEIGHT (- WHEEL-RADIUS))
                         BOTH-WHEELS))
;; 
(define WIDTH-OF-CAR (image-width CAR))
(define HEIGHT-OF-CAR (image-height CAR))

(define BACKGROUND (empty-scene WIDTH-OF-WORLD HEIGHT-OF-WORLD))
;; porperty of car
(define MOVE-X-STEP 3)
;; limitations of the world

;; NOTICE: image be treated as a point in place-image, the point is the center point of its.
;; so we need consider a image as its center point, when we need place/move it
(define START-X (/ WIDTH-OF-CAR 2))
(define START-Y (- HEIGHT-OF-WORLD (/ HEIGHT-OF-CAR 2)))

(define MAX-X (- WIDTH-OF-WORLD (/ WIDTH-OF-CAR 2)))
;; keys
(define RESTART-KEY "r")
(define END-MOUSE-EVENT "leave")
;; 
(define INITIAL-WORLD-STATE START-X)
;; place the car into the BACKGROUND scene
;; according to the given world state

;; An AnimationState is a Number.
;; interpretation the number of clock ticks
;; since the animation started

(define TOCK-STEP 1)
;; clock tick event handler
;; WorldState -> WorldState
(check-expect (tock 20) 21)
(check-expect (tock 35) 36)
(define (tock cw)
  (+ cw TOCK-STEP))

(define (render cw)
  (place-image CAR
	       (+ cw START-X)
	       START-Y
	       BACKGROUND))
(define (distance-from-right-margin right car-wd cw)
  (- right car-wd cw))

(define (end? cw)
  (<= (distance-from-right-margin WIDTH-OF-WORLD (image-width CAR) cw)
      0))
(define (keystroke-handler cw ke)
  (if (string=? ke RESTART-KEY) INITIAL-WORLD-STATE cw))

(define (main ws)
  (big-bang ws
	    [on-tick tock]
	    [stop-when end?]
	    [on-key keystroke-handler]
	    [to-draw render]))

(main INITIAL-WORLD-STATE)
