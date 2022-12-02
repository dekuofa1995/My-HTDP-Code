
;; A Vel is a structure:
;;   (make-vel Number Number)
;; interpretation two Number repersent the x-coordinate and y-coordinate
;; change respectly
(define-struct vel [deltax deltay])
(define v1 (make-vel 3 3))
(define v2 (make-vel -3 3))
(define v3 (make-vel 0 3))
(define v4 (make-vel 2 0))
;; A Item is a structure:
;;   (make-item Posn Vel)
(define-struct item [loc vel])
(define i1 (make-posn 50 40) v3) ;; ufo
(define i2 (make-posn 10 100) v4) ;; tank
;; A Space-Game is a structure:
;;   (make-space-game Item Item)
;; The First Item describes the UFO coordinates and Velocity
;; The Second describe the Tank coordinates and Velocity
(define-struct space-game [ufo tank])

(define s0 (make-space-game i1 i2))
