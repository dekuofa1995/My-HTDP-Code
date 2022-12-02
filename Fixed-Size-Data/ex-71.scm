(define HEIGHT 200)
(define MIDDLE (quotient HEIGHT 2))
(define WIDTH 400)
(define CENTER (quotient WIDTH 2))

(define-struct game [left-player right-player ball])

(define game0
  (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))


;; evaluate following experssions:
(game-ball game0) ;; (make-posn CENTER CENTER)
;; (game-ball (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))
;; (make-posn CENTER CENTER)

(posn? (game-ball game0)) ;; #true
;; (posn? (make-posn CENTER CENTER))
;; #true

(game-left-player game0) ;; MIDDLE
;; (game-left-player (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))
;; MIDDLE
