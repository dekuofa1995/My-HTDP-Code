;; A Price falls into one of three intervals
;; - 0 <= x < 1000
;; - 1000 <= x < 10000
;; - x >= 10000
;; interpertation the price of an item

;; Price -> Number
;; computes the amount of tax charged for p
(check-expect (sales-tax 0) 0)
(check-expect (sales-tax 537) 0)
(check-expect (sales-tax 1000) (* 0.05 1000))
(check-expect (sales-tax 1282) (* 0.05 1282))
(check-expect (sales-tax 10000) (* 0.08 10000))
(check-expect (sales-tax 12017) (* 0.08 12017))
(define (sales-tax p)
  (cond
   [(and (<= 0 p) (< p 1000)) 0]
   [(and (<= 1000 p) (< p 10000)) (* 0.05 p)]
   [(<= 10000 p) (* 0.08 p)]))


