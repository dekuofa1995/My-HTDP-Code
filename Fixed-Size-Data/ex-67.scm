;; Siumlates a ball bouncing back and forth on a straight vertical line 
;; between the floor and ceiling, move 2 pixels per tick

(define WIDTH 100)
(define HEIGHT 200)

(define RAIDUS 10) ;; ball's raidus
(define COLOR 'blue) ;; ball's color
(define SPEED 3) ;; ball move how much pixels per tick, the absolutly value of velocity

(define UP-BOUNDARY 0)
(define DOWN-BOUNDARY HEIGHT)
(define BALL-X (- (/ WIDTH 2) RADIUS))

;; A balld is a struction:
;; - location
;; - direction is one of:
;;   - "up"
;;   - "down"
;; interpretation
;; location means the height between ceiling with ball of the ball;
(define-struct balld [location direction])
(make-balld 10 "up")
