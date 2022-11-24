(define (reward x)
  (cond [(<= 0 x 10) "bronze"]
	[(and (< 10 x) (<= x 20)) "silver"]
	[else "gold"]))

(reward 18)
;; (cond [(<= 0 18 10) "bronze"] ...)
;; (cond [#false "bronze] [...] ...)
;; (cond [(and (< 10 18) (<= 18 20)) "silver"] [...])
;; (cond [(and #true #true) "silver"] [...])

;; (cond [#true "silver"] [...])
;; "silver"
