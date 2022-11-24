(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 300)
(define HEIGHT 100)

(define CLOSE (/ HEIGHT 3))

(define MTSCN (empty-scene WIDTH HEIGHT))
(define UFO (overlay (circle 10 "solid" "green")
		     (circle 20 "solid" "black")))

(define UFO-CENTER-TO-LEFT (/ (image-width UFO) 2))
(define UFO-CENTER-TO-TOP (/ (image-height UFO) 2))
(define UFO-CENTER-TO-LEFT-MARGIN (- (/ WIDTH 2) UFO-CENTER-TO-LEFT))
(define MAX-Y (- HEIGHT UFO-CENTER-TO-TOP))
;; color of status line
(define COLOR-OF-SL "black")
(define FONT-SIZE-OF-SL 12)
;; 
(define (main y0)
  (big-bang y0
	    [stop-when end?]
	    [on-tick nxt]
	    [to-draw render]))

;; WorldState -> WorldState
(check-expect (nxt 11) 14)
(define (nxt y)
  (+ 3 y))

;; given: 20; wanted 60
(check-expect (ws->height 20) 60)
(check-expect (ws->height 30) 50)
(check-expect (ws->height 80) 0)
(define (ws->height cw)
  (- HEIGHT cw UFO-CENTER-TO-TOP)) ;; - HEIGHT cw 20

;; height -> String
(check-expect (status-text 0) "landed")
(check-expect (status-text 100) "decending")
(check-expect (status-text 70) "decending")
(check-expect (status-text 33.4) "decending")
(check-expect (status-text 33.3) "closing in")
(check-expect (status-text 10) "closing in")
(define (status-text h)
  (cond [(>= h CLOSE) "decending"]
	[(and (< h CLOSE) (> h 0)) "closing in"]
	[else "landed"]))
;; WorldState -> Image
(define (status-line cw)
  (text (status-text (ws->height cw))
	FONT-SIZE-OF-SL COLOR-OF-SL))
  
(define (end? cw)
  (< (ws->height cw) 0))

(check-expect (render 11)
	      (overlay/align
               "center"
	       "top"
	       (status-line 11)
	       (place-image UFO UFO-CENTER-TO-LEFT-MARGIN  11 MTSCN)))
(define (render y)
  (overlay/align
   "center"
   "top"
   (status-line y)
   (place-image UFO UFO-CENTER-TO-LEFT-MARGIN y MTSCN)))
(main UFO-CENTER-TO-TOP)
