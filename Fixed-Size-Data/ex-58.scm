;; A Price falls into one of three intervals
;; - 0 <= x < 1000
;; - 1000 <= x < 10000
;; - x >= 10000
;; interpertation the price of an item

;; Price -> Number
;; computes the amount of tax charged for p
(define PRICE-LOW 1000)
(define PRICE-LUXURY 10000)
(define RATE-LOW 0)
(define RATE-NORMAL 0.05)
(define RATE-LUXURY 0.08)
(check-expect (sales-tax 0) (* RATE-LOW 0))
(check-expect (sales-tax 537) (* RATE-LOW 537))
(check-expect (sales-tax 1000) (* RATE-NORMAL 1000))
(check-expect (sales-tax 1282) (* RATE-NORMAL 1282))
(check-expect (sales-tax 10000) (* RATE-LUXURY 10000))
(check-expect (sales-tax 12017) (* RATE-LUXURY 12017))
(define (sales-tax p)
  (cond
   [(and (<= 0 p) (< p PRICE-LOW)) (* RATE-LOW p)]
   [(and (<= PRICE-LOW p) (< p PRICE-LUXURY)) (* RATE-NORMAL p)]
   [(<= PRICE-LUXURY p) (* RATE-LUXURY p)]))


