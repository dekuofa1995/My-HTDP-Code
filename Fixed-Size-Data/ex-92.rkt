#lang htdp/bsl

(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 600)
(define HEIGHT 120)
(define GAUGE-WIDTH 20)
(define GAUGE-HEIGHT HEIGHT)
(define HAPP-MIN 0)
(define HAPP-MAX 10)
(define HAPP-HEIGHT 100)
(define HAPP-STEP -0.1)
(define SPEED 3) ;; the cat moves three pixels per clock tick
(define MTS (empty-scene WIDTH HEIGHT))
(define CHAM 20)
(define CHAM-CENTER-Y (/ (image-height CHAM) 2))
(define CHAM-CENTER-X (/ (image-width CHAM) 2))
(define CHAM-X-MAX (- WIDTH CHAM-CENTER-X));; width - cat image's half width
(define CHAM-X-MIN CHAM-CENTER-X);; cham image's half width

(define RED "red")
(define BLUE "blue")
(define GREEN "green")

(define KEY-RED "r")
(define KEY-BLUE "b")
(define KEY-GREEN "g")
(define KEY-UP "up")
(define KEY-DOWN "down")

(define RATE-OF-DOWN -1/5)
(define RATE-OF-UP 1/3)


(define-struct cham [x h c])
;; A Cham is a structure:
;;   (make-cat Number Number Color)
;; x describes the cham's current x-coordinate
;; h describes the cham's current happniess
;; c describes the cham's color, which is one of:
;; - RED
;; - BLUE
;; - GREEN
(define c1 (make-cham CHAM-CENTER-X HAPP-MAX RED))
(define c2 (make-cham CHAM-CENTER-X
                      (+ HAPP-MIN (/ (- HAPP-MAX HAPP-MIN) 2))
                      BLUE))
(define c3 (make-cham CHAM-X-MAX HAPP-MIN GREEN))

;; Cham -> Cham
;; Run happy-cham world program, given c0 as initial state
;; for cat
(define (happy-cham c0)
  (big-bang c0
    ;; [stop-when cat-stop?]
    [on-key handle-key]
    [to-draw render]
    [on-tick tock]))

;; Cham -> Cham
;; computes next cat state according given cat state
(check-expect (tock c1) (make-cham (next-x CHAM-CENTER-X)
                                   (next-happ (cham-h c1))
                                   (cham-c c1)))
(check-expect (tock c2) (make-cham (next-x CHAM-CENTER-X)
                                   (next-happ (cham-h c2))
                                   (cham-c c2)))
(check-expect (tock c3) (make-cham CHAM-X-MIN
                                   (next-happ (cham-h c3))
                                   (cham-c c3)))
(define (tock cs)
  (make-cham (next-x (cham-x cs))
             (next-happ (cham-h cs))
             (cham-c cs)))

;; Number -> Number
;; computes the cat's next tick x-coordinate
;; move cat according SPEED
;; maxima is CAT-X-MAX
(check-expect (next-x CHAM-X-MAX) CHAM-X-MIN)
(check-expect (next-x (+ 1 (- CHAM-X-MAX SPEED ))) CHAM-X-MAX)
(check-expect (next-x (/ CHAM-X-MAX 2)) (+ (/ CHAM-X-MAX 2) SPEED))
(check-expect (next-x CHAM-X-MIN) (+ SPEED CHAM-X-MIN))
(check-expect (next-x (- CHAM-X-MIN 1)) CHAM-X-MIN)
(define (next-x x)
  (cond [(> CHAM-X-MIN x) CHAM-X-MIN]
        [(= CHAM-X-MAX x) CHAM-X-MIN]
        [(< CHAM-X-MAX (+ SPEED x)) CHAM-X-MAX]
        [else (+ SPEED x)]))

;; Happiness -> Happiness
;; per clock tick Happniess decreases by HAPP-STEP
;; never falls below HAPP-MIN
(check-expect (next-happ HAPP-MIN) HAPP-MIN)
(check-expect (next-happ 0.05) HAPP-MIN)
(check-expect (next-happ -10) HAPP-MIN)
(check-expect (next-happ 1) (+ HAPP-STEP 1))
(check-expect (next-happ 100) (+ HAPP-STEP 100))
(define (next-happ h)
  (if (<= (+ HAPP-STEP h) HAPP-MIN)
      HAPP-MIN
      (+ HAPP-STEP h)))
;; Cat -> Image
;; render the cat and its happiness bar on MTS
(check-expect (render c1)
              (beside/align "bottom"
                            (render/cham (cham-x c1) (cham-c c1))
                            (render/happ (cham-h c1))))
(check-expect (render c2)
              (beside/align "bottom"
                            (render/cham (cham-x c2) (cham-c c2))
                            (render/happ (cham-h c2))))
(check-expect (render c3)
              (beside/align "bottom"
                            (render/cham (cham-x c3) (cham-c c3))
                            (render/happ (cham-h c3))))
(define (render cham)
  (beside/align "bottom"
                (render/cham (cham-x cham) (cham-c cham))
                (render/happ (cham-h cham))))

;; Number -> Number
;; Convert cat's x position to x-coordinate on MTS
(check-expect (x->loc 0) CHAM-X-MIN)
(check-expect (x->loc CHAM-X-MIN) CHAM-X-MIN)
(check-expect (x->loc CHAM-X-MAX) CHAM-X-MAX)
(check-expect (x->loc (- CHAM-X-MIN 5)) CHAM-X-MIN)
(check-expect (x->loc (+ CHAM-X-MIN 5)) (+ CHAM-X-MIN 5))
(check-expect (x->loc (- CHAM-X-MAX 5)) (- CHAM-X-MAX 5))
(check-expect (x->loc (+ CHAM-X-MAX 5)) CHAM-X-MAX)
(define (x->loc x)
  (cond [(>= CHAM-X-MIN x) CHAM-X-MIN]
        	[(<= CHAM-X-MAX x) CHAM-X-MAX]
                [else x]))
;; Color -> Image
;; render cham with color
(check-expect (cham-with-color RED)
              (overlay CHAM
                       (rectangle (image-width CHAM)
                                  (image-height CHAM)
                                  "solid"
                                  RED)))
(check-expect (cham-with-color BLUE)
              (overlay CHAM
                       (rectangle (image-width CHAM)
                                  (image-height CHAM)
                                  "solid"
                                  BLUE)))
(check-expect (cham-with-color GREEN)
              (overlay CHAM
                       (rectangle (image-width CHAM)
                                  (image-height CHAM)
                                  "solid"
                                  GREEN)))

(define (cham-with-color c)
  (overlay CHAM
           (rectangle (image-width CHAM)
                      (image-height CHAM)
                      "solid"
                      c)))


;; Number -> Image
;; render cat by given x position
(check-expect (render/cham CHAM-X-MIN RED)
              (place-image (cham-with-color RED) CHAM-X-MIN CHAM-CENTER-Y MTS))
(check-expect (render/cham CHAM-X-MAX BLUE)
              (place-image (cham-with-color BLUE) CHAM-X-MAX CHAM-CENTER-Y MTS))
(check-expect (render/cham (- CHAM-X-MAX 10) GREEN)
              (place-image (cham-with-color GREEN) (- CHAM-X-MAX 10) CHAM-CENTER-Y MTS))
(define (render/cham x c)
  (place-image (cham-with-color c)
               (x->loc x)
               CHAM-CENTER-Y
               MTS))

;; Number -> Number
;; Computes happiness bar height, given h describes cat's happiness
(check-expect (happ->height (+ 5 HAPP-MAX)) GAUGE-HEIGHT)
(check-expect (happ->height HAPP-MIN) 0)
(check-expect (happ->height (- HAPP-MIN 5)) 0)
(check-expect (happ->height (+ HAPP-MIN (/ (- HAPP-MAX HAPP-MIN) 2)))
              (/ GAUGE-HEIGHT 2))
(define (happ->height h)
  (* GAUGE-HEIGHT (/ (cond [(<= HAPP-MIN h HAPP-MAX) h]
                           [(> HAPP-MIN h) HAPP-MIN]
                           [(< HAPP-MAX h) HAPP-MAX])
                     (- HAPP-MAX HAPP-MIN))))
;; Number -> Image
;; render cat's happiness bar, given h describes current cat's happiness point
(check-expect (render/happ HAPP-MIN)
              (rectangle GAUGE-WIDTH
                         0
                         "solid"
                         "red"))
(check-expect (render/happ HAPP-MAX)
              	      (rectangle GAUGE-WIDTH
                                 GAUGE-HEIGHT
                                 "solid"
                                 "red"))
(check-expect (render/happ (+ HAPP-MIN (/ (- HAPP-MAX HAPP-MIN) 2)))
              	      (rectangle GAUGE-WIDTH
                                 (/ GAUGE-HEIGHT 2)
                                 "solid"
                                 "red"))


;; Cham, Color
;; change cham's color
(check-expect (change-color c1 RED) c1)
(check-expect (change-color c1 BLUE) (make-cham (cham-x c1)
                                                (cham-h c1)
                                                BLUE
                                                ))
(check-expect (change-color c1 GREEN) (make-cham (cham-x c1)
                                                 (cham-h c1)
                                                 GREEN))
(define (change-color cham color)
  (make-cham (cham-x cham)
             (cham-h cham)
             color))
;; Cham, Happ -> Cham
;; change cham's happniess, max: HAPP-MAX, min: HAPP-MIN
(check-expect (cham-h (change-happ c1 HAPP-MIN))
              HAPP-MIN)
(check-expect (cham-h (change-happ c1 (- HAPP-MIN 1)))
              HAPP-MIN)
(check-expect (cham-h (change-happ c1 (+ 5 HAPP-MIN)))
              (+ 5 HAPP-MIN))
(check-expect (cham-h (change-happ c1 HAPP-MAX))
              HAPP-MAX)
(check-expect (cham-h (change-happ c1 (+ 1 HAPP-MAX)))
              HAPP-MAX)
              
(define (change-happ cham h)
  (make-cham (cham-x cham)
             (cond [(> HAPP-MIN h) HAPP-MIN]
                   [(< HAPP-MAX h) HAPP-MAX]
                   [else h])
             (cham-c cham)
             ))
(define (rate->change hs rate)
  (+ hs (* hs rate)))

;; Cham, KeyEvent -> Cham
;; computes new cham state, given keyevent
;; if KeyEvent is one of KEY-BLUE, KEY-RED, KEY-GREEN then change color respectively
(check-expect (handle-key c1 KEY-BLUE)
              (change-color c1 BLUE))
(check-expect (handle-key c1 KEY-RED)
              (change-color c1 RED))
(check-expect (handle-key c1 KEY-GREEN)
              (change-color c1 GREEN))
(define (handle-key cs ke)
  (cond [(string=? ke KEY-RED) (change-color cs RED)]
        [(string=? ke KEY-GREEN) (change-color cs GREEN)]
        [(string=? ke KEY-BLUE) (change-color cs BLUE)]
        [(string=? ke KEY-UP) (change-happ cs (rate->change (cham-h cs) RATE-OF-UP))]
        [(string=? ke KEY-DOWN) (change-happ cs (rate->change (cham-h cs) RATE-OF-DOWN))]
        [else cs]))
        

(define (render/happ h)
  (rectangle GAUGE-WIDTH
             (happ->height h)
             "solid"
             "red"))

