;; Siumlates a ball bouncing back and forth on a straight vertical line 
;; between the floor and ceiling, move 2 pixels per tick

(define WIDTH 100)
(define HEIGHT 200)

(define RAIDUS 10) ;; ball's raidus
(define COLOR 'blue) ;; ball's color
(define SPEED 2) ;; ball move 2 pixels per tick, the absolutly value of speed

(define UP-BOUNDARY 0)
(define DOWN-BOUNDARY HEIGHT)
(define BALL-X (- (/ WIDTH 2) RADIUS))

;; A BallState is a posn
;; whose x corresponding location
;; which is an non-negative number
;; whose y corresponding the velocity of ball:
;; interpretation location means the height between ceiling with ball of the ball;
;; when velocity is positive means ball is moving downward
;; when velocity is negative means ball is moving upward
(define-struct ball [location velocity])

(define (ball-next/keep s) s)

(define (ball-next/reverse s)
  (cond [(equal? (posn-x s) UP)
	 (make-posn DOWN UP-BOUNDARY)]
	[(equal? (posn-x s) DOWN)
	 (make-posn UP DOWN-BOUNDARY)]))
			     
;; BallState -> BallState
;; each tick return new BallState, given the current state
;; when ball touch the floor/ceiling it will change the direction and keep velocity
(define (ball-next cs)
  (if (hit-boundary? (ball-next/keep cs))
      (ball-next/reverse (ball-next/keep cs))
      (ball-next/keep cs)))
    
    
      
;; BallState  -> Bool
;; check wheather the ball hit the boundary
(define (hit-boundary? s)
  (cond [(equal? (posn-x s) UP) (<= (posn-y s) UP-BOUNDARY)]
	[(equal? (posn-x s) DOWN) (>= (pons-y s) DOWN-BOUNDARY)]
	[else #false]))
;; BallState -> Image
;; render image by given s
(define (ball-render s) s)

