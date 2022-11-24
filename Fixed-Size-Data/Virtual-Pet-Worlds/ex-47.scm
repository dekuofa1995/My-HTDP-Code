;; happiness gauge.
(require 2htdp/image)
(require 2htdp/universe)

;; constants
(define KEY-UP-BUTTON "up")
(define KEY-DOWN-BUTTON "down")

(define STEP -0.1)

(define MIN 0)
(define MAX 10)

(define RATE-OF-DOWN -1/5)
(define RATE-OF-UP 1/3)

;; Happiness Score is a Number
;; graphic constants
(define HEIGHT-OF-GAUGE 400)
(define WIDTH-OF-GAUGE 80)

(define COLOR-OF-FRAME "black")
(define COLOR-OF-BAR "red")
(define BORDER-OF-VERTICAL 10)
(define BORDER-OF-HORZONTAL 5)
(define HEIGHT-OF-SCNEN (+ 400 (* 2 BORDER-OF-VERTICAL)))
(define WIDTH-OF-SCNEN (+ 80 (* 2 BORDER-OF-HORZONTAL)))

(define BACKGROUND (empty-scene WIDTH-OF-SCNEN HEIGHT-OF-SCNEN COLOR-OF-FRAME))
(define BAR-X (+ BORDER-OF-HORZONTAL WIDTH-OF-GAUGE))
(define BAR-Y (+ BORDER-OF-VERTICAL HEIGHT-OF-GAUGE))
;; functions
(define (tock hs)
  (+ hs STEP))

(define (rate->change hs rate)
  (+ hs (* hs rate)))
;; Score, String -> Score
;; given: 9, up; wanted: 12
;; given: 10, down; wanted: 8
;; given: 6, up; wanted: 8
;; given: 5, down; wanted: 4
(check-expect (key-handler 9 "up") 12)
(check-expect (key-handler 10 "down") 8)
(check-expect (key-handler 6 "up") 8)
(check-expect (key-handler 5 "down") 4)
(define (key-handler hs ke)
  (cond ([string=? ke KEY-UP-BUTTON] (rate->change hs RATE-OF-UP))
	([string=? ke KEY-DOWN-BUTTON] (rate->change hs RATE-OF-DOWN))
	(else hs)))
;; max_s
(define (score->height max_s max_height cs)
  (if (>= cs max_s)
      max_height
      (* max_height (/ cs max_s))))
;; Score -> Image
(define (render-bar hs)
  (rectangle WIDTH-OF-GAUGE (score->height MAX HEIGHT-OF-GAUGE hs)
	     "solid" COLOR-OF-BAR))

(define (render hs)
  (place-image/align (render-bar hs)
	       BAR-X
	       BAR-Y
	       BACKGROUND))
;; gauge-prog
;; show current happiness gauge
(define (gauge-prog hs)
  (big-bang hs
   [on-key key-handler]
   [on-tick tock]
   [to-draw render]))

(gauge-prog MAX)
  
