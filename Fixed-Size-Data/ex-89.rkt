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
(define CAT-SPEED 3) ;; the cat moves three pixels per clock tick
(define MTS (empty-scene WIDTH HEIGHT))
(define CAT 20)
(define CAT-Y (/ (image-height CAT) 2))
(define CAT-CENTER-X (/ (image-width CAT) 2))
(define CAT-X-MAX (- WIDTH CAT-CENTER-X));; width - cat image's half width
(define CAT-X-MIN CAT-CENTER-X);; cat image's half width


(define-struct cat [x h])
;; A VCat is a structure:
;;   (make-cat Number Number)
;; x describes the vcat's current x-coordinate
;; h describes the vcat's current happniess
(define c1 (make-cat 0 HAPP-MAX))
(define c2 (make-cat 50 (+ HAPP-MIN (/ (- HAPP-MAX HAPP-MIN) 2))))
(define c3 (make-cat 50 HAPP-MIN))

;; Cat -> Cat
;; Run happy-cat world program, given c0 as initial state
;; for cat
(define (happy-cat c0)
  (big-bang c0
    [stop-when cat-stop?]
    [to-draw render]
    [on-tick tock]))


;; Cat -> Cat
;; computes next cat state according given cat state
(define (tock cs)
  (make-cat (+ CAT-SPEED (cat-x cs))
            (+ HAPP-STEP (cat-h cs))))

;; Number -> Number
;; computes the cat's next tick x-coordinate
;; move cat according CAT-SPEED
;; maxima is CAT-X-MAX
(check-expect (cat-next WIDTH) CAT-X-MAX)
(check-expect (cat-next (+ 1 (- WIDTH CAT-SPEED ))) CAT-X-MAX)
(check-expect (cat-next (/ WIDTH 2)) (+ (/ WIDTH 2) CAT-SPEED))
(check-expect (cat-next 0) CAT-SPEED)
(define (cat-next x)
  (if (< CAT-X-MAX (+ CAT-SPEED x))
      CAT-X-MAX
      (+ CAT-SPEED x)))

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
                            (render/cat (cat-x c1))
                            (render/happ (cat-h c1))))
(check-expect (render c2)
              (beside/align "bottom"
                            (render/cat (cat-x c2))
                            (render/happ (cat-h c2))))
(check-expect (render c3)
              (beside/align "bottom"
                            (render/cat (cat-x c3))
                            (render/happ (cat-h c3))))
(define (render cat)
  (beside/align "bottom"
                (render/cat (cat-x cat))
                (render/happ (cat-h cat))))

;; Number -> Number
;; Convert cat's x position to x-coordinate on MTS
(check-expect (x->loc 0) CAT-X-MIN)
(check-expect (x->loc CAT-X-MIN) CAT-X-MIN)
(check-expect (x->loc CAT-X-MAX) CAT-X-MAX)
(check-expect (x->loc (- CAT-X-MIN 5)) CAT-X-MIN)
(check-expect (x->loc (+ CAT-X-MIN 5)) (+ CAT-X-MIN 5))
(check-expect (x->loc (- CAT-X-MAX 5)) (- CAT-X-MAX 5))
(check-expect (x->loc (+ CAT-X-MAX 5)) CAT-X-MAX)
(define (x->loc x)
  (cond [(>= CAT-X-MIN x) CAT-X-MIN]
        	[(<= CAT-X-MAX x) CAT-X-MAX]
                	[else x]))
;; Number -> Image
;; render cat by given x position
(check-expect (render/cat CAT-X-MIN)
              	      (place-image CAT CAT-X-MIN CAT-Y MTS))
(check-expect (render/cat CAT-X-MAX)
              	      (place-image CAT CAT-X-MAX CAT-Y MTS))
(check-expect (render/cat (- CAT-X-MAX 10))
              	      (place-image CAT (- CAT-X-MAX 10) CAT-Y MTS))
(define (render/cat x)
  (place-image CAT
               (x->loc x)
               CAT-Y
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

(define (render/happ h)
  (rectangle GAUGE-WIDTH
             (happ->height h)
             "solid"
             "red"))

;; Cat -> Boolean
;; according to given state, check wheather cat is stoped
(check-expect (cat-stop? c1) #false)
(check-expect (cat-stop? c2) #false)
(check-expect (cat-stop? c3) #true)
(check-expect (cat-stop? (make-cat 20 (+ HAPP-MAX 5))) #false)
(check-expect (cat-stop? (make-cat 20 (- HAPP-MIN 5))) #true)
(define (cat-stop? cat)
  (cond [(>= HAPP-MIN (cat-h cat)) #true]
        ;; [(<= CAT-X-MAX (cat-x cat)) #true]
        [else #false]))
  
