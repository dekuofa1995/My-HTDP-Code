(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 100)
(define HEIGHT 300)
(define DELTA-Y 3)

(define BACKG (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))

(define CENTER (/ (image-height ROCKET) 2))
(define HEIGHT-OF-RESTING (- HEIGHT CENTER))

(define ROCKET-X (/ (- WIDTH (image-width ROCKET)) 2))

;; An LRCD (for launch rocket countdown) is one of:
;; - "resting"
;; - An number between -3 and -1
;; - An NonnegativeNumber
;; interpretation:
;; a grounded rocket;
;; in countdown mode;
;; a number denotes the number of pixels between the top of
;; the canvas and the rockets(its height)

;; LRCD -> Image
;; render the state as a resting of flying rocket
(check-expect (show "resting") (place-image ROCKET ROCKET-X HEIGHT-OF-RESTING BACKG)) 
(check-expect (show -2) (place-image ROCKET ROCKET-X HEIGHT-OF-RESTING BACKG)) 
(check-expect (show 20) (place-image ROCKET ROCKET-X 20 BACKG)) 
(define (show x)
  (place-image
   ROCKET
   ;; (text (if (number? x) (number->string x) x) 11 "black")
   ROCKET-X
   (cond [(and (number? x) (>= x 0)) x]
	 [else HEIGHT-OF-RESTING])
  BACKG))

;; LRCD keyEvent -> LRCD
;; starts the countdown when space bar is pressed,
;; if the rocket is still "resting"
(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -2 " ") -2)
(check-expect (launch -2 "a") -2)
(check-expect (launch 100 " ") 100)
(check-expect (launch 100 "a") 100)
(define (launch x ke)
  (cond [(string? x) (if (string=? " ") -3 x)]
	[(<= -3 x -1) x]
	[(>= x 0) x]))
  ;; (if (and (string? x) (string=? x "resting") (string=? ke " "))
  ;;     -3
  ;;     x))

;; LRCD -> LRCD
;; raises the rocket by DELTA-Y
;; if it is moving already
(check-expect (fly "resting") "resting")
(check-expect (fly -2) -1)
(check-expect (fly -1) HEIGHT-OF-RESTING)
(check-expect (fly 200) (- 200 DELTA-Y))
(check-expect (fly CENTER) CENTER)
(define (fly x)
  (cond [(and (string? x) (string=? x "resting")) x]
	[(= x CENTER) x]
        [(> x 0) (- x DELTA-Y)]
	[(= x -1) HEIGHT-OF-RESTING]
        [else (+ 1 x)]))


(define (main x)
  (big-bang x
	    [to-draw show]
	    [on-tick fly]
	    [on-key launch]))

(main "resting")
