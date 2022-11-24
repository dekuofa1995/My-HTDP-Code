;; need import 2htdp/batch-io and 2htdp/universe
(require 2htdp/image)
(require 2htdp/batch-io)
(require 2htdp/universe)

;; Ex-34

;; non-empty string -> string
;; extract first character in the given non-empty str
;; given: "hello"; excepted: "h"
;; given: "world"; excepted: "w"
;; given: ""; excepted: ""
(define (string-first str)
      (string-ith str 0))

(string=? (string-first "hello") "h")
(string=? (string-first "world") "w")

;; Ex-35
;; non-empty string -> string
;; extracts last character from the given non-empty str
;; given "hello"; excepted: "o"
;; given "world"; excepted: "d"
;; given "b"; excepted: "b"

(define (string-last str)
  (string-ith str (- (string-length str) 1)))

(string=? (string-last "hello") "o")
(string=? (string-last "world") "d")
(string=? (string-last "b") "b")


;; Ex-36
;; image -> number (area)
;; calculates area of the given img: area = height * width
;; given img h=300 w=100; excepted: area=30000
;; given img h=100 w=100; excepted: area=10000

(define (image-area img)
  ;; (... img ...)
  (* (image-height img)
     (image-width img)))

(= (image-area (empty-scene 300 100)) 30000)
(= (image-area (empty-scene 100 100)) 10000)

;; Ex-37 string-rest
;; non-empty string -> string
;; return the given string with removed first character
;; given: "hello"; excepted: "ello"
;; given: "world"; excepted: "orld"
;; given: "b"; excepted: ""

(define (string-rest str)
  ;; (... str ...)
  (substring str 1))

(string=? (string-rest "hello") "ello")
(string=? (string-rest "world") "orld")
(string=? (string-rest "b") "")


;; Ex-38 string-remove-last
;; non-empty string -> string
;; return the given str with removed last character
;; given: "hello"; excepted: "ello"
;; given: "world"; excepted: "worl"
;; given: "b"; excepted: ""

(define (string-remove-last str)
  ;; (... str ...))
  (substring str 0 (- (string-length str) 1)))

(string=? (string-remove-last "hello") "hell")
(string=? (string-remove-last "world") "worl")
(string=? (string-remove-last "b") "")


  
;; 3.5 On Testing ;;
;; Numebr -> Number
;; converts Fahrenheit temperatures to Celsius temperatures
;; replace example and test steps
(check-expect (f2c -40) -40)
(check-expect (f2c 32) 0)
(check-expect (f2c 212) 100)

(define (f2c f)
  (* 5/9 (- f 32)))

;; 3.6 Designing World Programs ;;

;; WorldState: data repersenting the current world(cw)

;; WorldState -> Image
;; when needed, big-bang obtains the Image of the current
;; state of the world by evaluating (render cw)
(define (render cw) ...)

;; WorldState -> WorldState
;; for each tick of the clock, big-bang obtains the next
;; state of the world from (clock-tick-handler cw)
(define (clock-tick-handler cw) ...)

;; WorldState String -> WorldState
;; for each keystroke, big-bang obtains the next state
;; from (keystroke-handler cw ke) ; ke repersents the key
(define (keystroke-handler cw ke) ...)

;; WorldState Number Number String -> WorldState
;; for each mouse gesture, big-bang obstains the next state
;; from (mouse-event-handler cw x y me) where x and y are
;; the coordinates of the event and me is its description
(define (mouse-event-handler cw x y me) ...)

;; WorldState -> Boolean
;; after each event, big-bang evaluates (end? cw)
(define (end? cw) ...)

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
(define START-X 0)
(define START-Y (- HEIGHT-OF-WORLD (/ HEIGHT-OF-CAR 2)))

(define MAX-X (- WIDTH-OF-WORLD (/ WIDTH-OF-CAR 2)))
;; keys
(define RESTART-KEY "r")
(define END-MOUSE-EVENT "leave")
;; 
(define INITIAL-WORLD-STATE START-X)
;; place the car into the BACKGROUND scene
;; according to the given world state
(define (render cw)
  (place-image CAR cw START-Y BACKGROUND))
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
