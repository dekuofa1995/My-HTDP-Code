(require 2htdp/image)
(require 2htdp/universe)

(define MST (empty-scene 100 100))
(define DOT (circle 3 "solid" "red"))

(define SPEED 3) ;; dot's moving speed
(define INIT-POSN (make-posn 0 50))
;; A Posn repersents the state of the world.
(define (main p0)
  (big-bang p0
	    [to-draw scene+dot]
	    [on-tick x+]
	    [on-mouse reset-dot]))

;; Posn, x, y, MouseEvent -> Posn
;; when click and release mouse button then current mouse position
;; other case return given Posn
(check-expect (reset-dot (make-posn 4 3) 0 1 "move") (make-posn 4 3))
(check-expect (reset-dot (make-posn 4 3) 1 0 "leave") (make-posn 4 3))
(check-expect (reset-dot (make-posn 4 3) 1 0 "button-up") (make-posn 4 3))
(check-expect (reset-dot (make-posn 4 3) 1 0 "button-down") (make-posn 1 0))
(define (reset-dot s x y me)
  (if (mouse=? me "button-down")
      (make-posn x y)
      s))

;; Posn -> Posn
;; the dot's next Posn
(check-expect (x+ (make-posn 3 4)) (make-posn (+ 3 SPEED) 4))
(check-expect (x+ (make-posn 5 0)) (make-posn (+ 5 SPEED) 0))
(define (x+ s)
  (make-posn (+ 3 (posn-x s))
	     (posn-y s)))

;; Posn -> Image
;; render the red dot on canvas at specified positon
(check-expect (scene+dot (make-posn 3 4))
	      (place-image DOT 3 4 MST))
(check-expect (scene+dot (make-posn 0 4))
	      (place-image DOT 0 4 MST))
(check-expect (scene+dot (make-posn 20 0))
	      (place-image DOT 20 0 MST))
(define (scene+dot s)
  (place-image DOT
	       (posn-x s)
	       (posn-y s)
	       MST))
  
			
