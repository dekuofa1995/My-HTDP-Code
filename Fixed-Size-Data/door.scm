(require 2htdp/universe)
(require 2htdp/image)

;; A DoorState is one of:
;; - LOCKED
;; - OPEN
;; - CLOSED
(define OPEN "open")
(define CLOSED "closed")
(define LOCKED "locked")

;; An Action is one of:
;; - PUSH
;; - UNLOCK
;; - LOCK
(define PUSH " ")
(define UNLOCK "u")
(define LOCK "l")

(define TEXT-SIZE 40)
(define TEXT-COLOR "red")
;; DoorState -> DoorState
;; closes an open door over the period of one tick
(check-expect (door-closer OPEN) CLOSED)
(check-expect (door-closer CLOSED) CLOSED)
(check-expect (door-closer LOCKED) LOCKED)
(define (door-closer cs)
  (cond [(equal? cs OPEN) CLOSED]
	[(equal? cs CLOSED) cs]
	[(equal? cs LOCKED) cs]))

;; DoorState, KeyEvent -> DoorState
;; we can open a closed door by push or unlock a locked door by key
(check-expect (door-action OPEN PUSH) OPEN)
(check-expect (door-action OPEN UNLOCK) OPEN)
(check-expect (door-action OPEN LOCK) OPEN)
(check-expect (door-action CLOSED PUSH) OPEN)
(check-expect (door-action CLOSED UNLOCK) CLOSED)
(check-expect (door-action CLOSED LOCK) LOCKED)
(check-expect (door-action LOCKED PUSH) LOCKED)
(check-expect (door-action LOCKED UNLOCK) CLOSED)
(check-expect (door-action LOCKED LOCK) LOCKED)
(define (door-action cs ke)
  (cond [(and (equal? cs CLOSED) (equal? ke PUSH)) OPEN]
	[(and (equal? cs CLOSED) (equal? ke LOCK)) LOCKED]
	[(and (equal? cs LOCKED) (equal? ke UNLOCK)) CLOSED]
	[else cs]))

;; DoorState -> Image
;; translates the state s into a large text image
(check-expect (door-render CLOSED)
	      (text CLOSED TEXT-SIZE TEXT-COLOR))
(check-expect (door-render OPEN)
	      (text OPEN TEXT-SIZE TEXT-COLOR))
(define (door-render s)
  (text s TEXT-SIZE TEXT-COLOR))


(define (main ws)
  (big-bang ws
	    [on-tick door-closer]
	    [on-key door-action]
	    [to-draw door-render]))

(main LOCKED)
