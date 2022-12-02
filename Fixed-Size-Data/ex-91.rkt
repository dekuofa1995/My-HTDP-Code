#lang htdp/bsl

(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 600)
(define HEIGHT 400)
(define GAUGE-WIDTH 20)
(define GAUGE-HEIGHT HEIGHT)
(define HAPP-MIN 0)
(define HAPP-MAX 10)
(define HAPP-HEIGHT 100)
(define HAPP-STEP -0.1)
(define MTS (empty-scene WIDTH HEIGHT))

(define cat 20)
(define cham 20)

(define CAT-Y (/ (image-height cat) 2))
(define CAT-CENTER-X (/ (image-width cat) 2))
(define CAT-CENTER-Y (/ (image-height cat) 2))
(define CAT-X-MAX (- WIDTH CAT-CENTER-X));; width - cat image's half width
(define CAT-X-MIN CAT-CENTER-X);; cat image's half width
(define CAT-Y-MIN CAT-CENTER-Y)
(define CAT-Y-MAX (- HEIGHT CAT-CENTER-Y))
(define LEFT-TOP (make-posn CAT-X-MIN CAT-Y-MIN))
(define RIGHT-BOTTOM (make-posn CAT-X-MAX CAT-Y-MAX))
(define-struct vel [deltax deltay])
;; A Vel is a structure:
;;   (make-vel Number Number)
;; deltax describes speed on the x-coordinate, positive cooresponding right direction
;; deltay describes speed on the y-coordinate, positive cooresponding down direction
(define x-3 (make-vel 3 0))
(define y-3 (make-vel 0 3))
(define xy-3 (make-vel 3 3))

(define-struct vcat [loc vel h])
;; A Cat is a structure:
;;   (make-cat Posn Vel Number)
;; loc describes the cat's current x/y-coordinate
;; vel describes the cat's velocity
;; h describes the cat's current happniess
(define origin (make-posn 0 0))
(define p1 (make-posn 0 CAT-Y))
(define p2 (make-posn 50 50))

(define c1 (make-vcat p1 x-3 HAPP-MAX))
(define c2 (make-vcat p2 y-3 HAPP-MAX))
(define c3 (make-vcat origin xy-3 HAPP-MAX))

;; Cat -> Cat
;; Run happy-cat world program, given c0 as initial state
;; for cat
(define (happy-cat c0)
  (big-bang c0
    	    [to-draw render]
    	    [on-tick tock]))

;; Loc, Vel -> Loc
;; computes new Loc according given loc and vel
(check-expect (next-loc origin x-3) (make-posn 3 0))
(check-expect (next-loc origin y-3) (make-posn 0 3))
(check-expect (next-loc origin xy-3) (make-posn 3 3))
(check-expect (next-loc p2 (make-vel -3 0))
              (make-posn (+ -3 (posn-x p2))
                         (posn-y p2)))
(check-expect (next-loc p2 (make-vel 0 -3))
              (make-posn  (posn-x p2)
                          (+ -3 (posn-y p2))))
(check-expect (next-loc p2 (make-vel -3 -3))
              (make-posn (+ -3 (posn-x p2))
                         (+ -3 (posn-y p2))))
(define (next-loc loc vel)
  (make-posn (+ (posn-x loc) (vel-deltax vel))
             (+ (posn-y loc) (vel-deltay vel))))

;; Number, Number, Number -> Boolean
;; check wheater current location is touch the end of canvas
;; first x describe the one of the cat coordinates
;; min, max are the side min and max value
(check-expect (touch-end? 0 0 100) #true)
(check-expect (touch-end? 100 0 100) #true)
(check-expect (touch-end? -2 0 100) #true)
(check-expect (touch-end? -120 0 100) #true)
(check-expect (touch-end? 20 0 100) #false)
(define (touch-end? x min max)
  (cond [(< min x max) #false]
        [else #true]))

(define (half x y)
  (if (> x y)
      (half y x)
      (+ x (/ (- y x) 2))))
;; Vel, Loc -> Vel
;; valid vel, if current loc is touch the end of canvas then reverse cooresponding vel
(define RB (make-posn CAT-X-MAX CAT-Y-MAX))
(define LB (make-posn CAT-X-MIN CAT-Y-MAX))
(define RT (make-posn CAT-X-MAX CAT-Y-MIN))
(define LT (make-posn CAT-X-MIN CAT-Y-MIN))
(define CENTER (make-posn (half CAT-X-MIN CAT-X-MAX)
                          (half CAT-Y-MIN CAT-Y-MAX)))
(define nxy-3 (make-vel -3 -3))
;; Posn -> Posn
;; return valid loc, if given location touch the end then use the valid data replace
(define (valid-loc loc)
  (make-posn
   (cond [(> CAT-X-MIN (posn-x loc)) CAT-X-MIN]
         [(< CAT-X-MAX (posn-x loc)) CAT-X-MAX]
         [(<= CAT-X-MIN (posn-x loc) CAT-X-MAX) (posn-x loc)])
   (cond [(> CAT-Y-MIN (posn-y loc)) CAT-Y-MIN]
         [(< CAT-Y-MAX (posn-y loc)) CAT-Y-MAX]
         [(<= CAT-Y-MIN (posn-y loc) CAT-Y-MAX) (posn-y loc)])))
       

(check-expect (valid-vel xy-3 RB) (make-vel -3 -3))
(check-expect (valid-vel xy-3 RT) (make-vel -3 -3))
(check-expect (valid-vel xy-3 LT) (make-vel -3 -3))
(check-expect (valid-vel xy-3 LB) (make-vel -3 -3))
(check-expect (valid-vel xy-3 CENTER) xy-3)
(define (valid-vel vel loc)
  (make-vel
   (if (touch-end? (posn-x loc) CAT-X-MIN CAT-X-MAX)
       (- (vel-deltax vel))
       (vel-deltax vel))
   (if (touch-end? (posn-y loc) CAT-Y-MIN CAT-Y-MAX)
       (- (vel-deltay vel))
       (vel-deltay vel))))

;; Cat -> Cat
;; computes next cat state according given cat state
(check-expect (tock c1) (make-vcat (valid-loc (next-loc (vcat-loc c1) (vcat-vel c1)))
                                   (make-vel -3 0)
                                   (next-happ (vcat-h c1))))
(check-expect (tock c2) (make-vcat (valid-loc (next-loc (vcat-loc c2) (vcat-vel c2)))
                                   (make-vel 0 -3)
                                   (next-happ (vcat-h c2))))
(define (tock cs)
  (make-vcat (valid-loc (next-loc (vcat-loc cs) (vcat-vel cs)))
             (valid-vel
              (vcat-vel cs)
              (next-loc (vcat-loc cs) (vcat-vel cs)))

             (next-happ (vcat-h cs))))

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
                            (render/cat (vcat-loc c1))
                            (render/happ (vcat-h c1))))
(check-expect (render c2)
              (beside/align "bottom"
                            (render/cat (vcat-loc c2))
                            (render/happ (vcat-h c2))))
(check-expect (render c3)
              (beside/align "bottom"
                            (render/cat (vcat-loc c3))
                            (render/happ (vcat-h c3))))
(define (render cat)
  (beside/align "bottom"
                (render/cat (vcat-loc cat))
                (render/happ (vcat-h cat))))

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
;; Posn -> Image
;; render cat by given cat position
(check-expect (render/cat origin)
              (place-image cat (posn-x origin)
                           (posn-y origin)
                           MTS))
(check-expect (render/cat p1)
              (place-image cat
                           (posn-x p1)
                           (posn-y p1)
                           MTS))
(check-expect (render/cat p2)
              (place-image cat
                           (posn-x p2)
                           (posn-y p2)
                           MTS))
(define (render/cat loc)
  (place-image cat
               (posn-x loc)
               (posn-y loc)
               MTS
               ))

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
		

(happy-cat c3)
