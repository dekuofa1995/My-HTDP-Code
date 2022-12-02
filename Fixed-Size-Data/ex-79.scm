;; A Color is one of:
;; - "white"
;; - "yellow"
;; - "orange"
;; - "green"
;; - "red"
;; - "blue"
;; - "black"
;; (circle 3 "solid" "blue")
;; (circle 4 "solid" "black")

;; H is a Number between 0 and 100.
;; interpretation represents a happiness value
;; (hp-render 100)
;; (hp-render 0)
;; (hp-render 50)
;; (hp-render 75)


(define-struct person [fstname lstname male?])
;; A Person is a structure:
;;   (make-person String String Boolean)

;; (make-person "Tom" "Son" #true)
;; (make-person "Jully" "Saray" #false)

(define-struct dog [owner name age happiness])
;; A Dog is a structure:
;;   (make-dog Person String PositiveInteger H)

(make-dog (make-person "Tom" "Son" #true)
	  "Walf"
	  2
	  80.5)

;; A Weapon is one of:
;; - #false
;; - Posn
;; interpretation #false means the missile hasn't
;; been fired yet; a Posn it is in flight

;;(define w1 #false)
;;(define w2 (make-posn 30 400))
