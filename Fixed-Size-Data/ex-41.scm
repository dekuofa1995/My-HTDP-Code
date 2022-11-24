
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

(define tree
  (underlay/xy (circle 10 "solid" "green")
	       9
	       15
	       (rectangle 2 20 "solid" "brown")))


;; place the car into the BACKGROUND scene
;; according to the given world state

(define (render cw)
  (if (>= cw (- MAX-X MOVE-X-STEP))
      (place-image tree cw (- HEIGHT-OF-WORLD (/ (image-height tree) 2)) BACKGROUND)
      (place-image CAR cw START-Y BACKGROUND)))
;; ex-40
;; WorldState -> WorldState 
(check-expect (clock-tick-handler 20) 23);; (clock-tick-handler 20) -> 23
(check-expect (clock-tick-handler 34) 37);; (clock-tick-handler 34) -> 37
;; (check-expect (clock-tick-handler 35) 37)

(define (clock-tick-handler cw)
  (+ MOVE-X-STEP cw))
;; WorldState, String -> WorldState
(define (keystroke-handler cw ke)
  (if (string=? ke RESTART-KEY) INITIAL-WORLD-STATE cw))
;; mouse-event-handler
(define (mouse-event-handler cw x y me)
  (if (string=? me END-MOUSE-EVENT)
      MAX-X x))
			   
(define (end? cw)
  (<= MAX-X cw))

(define (main ws)
  (big-bang ws
	    [on-tick clock-tick-handler]
	    [stop-when end?]
	    [on-mouse mouse-event-handler]
	    [on-key keystroke-handler]
	    [to-draw render]))

(main INITIAL-WORLD-STATE)
