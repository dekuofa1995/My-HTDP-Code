
(define-struct 3letter-word [a b c])

(define w1 (make-3letter-word "a" "d" "d"))
(define w2 (make-3letter-word "o" "d" "d"))
(define w3 (make-3letter-word "s" "p" "y"))
(define w4 (make-3letter-word #false "p" "y"))

;; 3Letter-Word, 3Letter-Word -> 3Letter-Word
;; retain the same letter in given two words, and replace
;; the disagree letter by #false
(check-expect (compare-word w1 w2) (make-3letter-word #false "d" "d"))
(check-expect (compare-word w3 w2) (make-3letter-word #false #false #false))
(check-expect (compare-word w1 w3) (make-3letter-word #false #false #false))
(check-expect (compare-word w3 w4) (make-3letter-word #false "p" "y"))
(check-expect (compare-word w1 w1) w1)
(check-expect (compare-word w2 w2) w2)
(check-expect (compare-word w3 w3) w3)
(check-expect (compare-word w4 w1) (make-3letter-word #false #false #false))
(define (compare-word w1 w2)
  (make-3letter-word
   (compare-letter 
    (3letter-word-a w1)
    (3letter-word-a w2))
   (compare-letter 
    (3letter-word-b w1)
    (3letter-word-b w2))
   (compare-letter 
    (3letter-word-c w1)
    (3letter-word-c w2))))
;; 1Letter, 1Letter -> 1Letter or #false
;; A 1Letter is one of "a" though "z" or #false
;; compare wheater the two given letter are same
;; if true, then return letter; otherwise return #false
(check-expect (compare-letter "a" "b") #false)
(check-expect (compare-letter #false "b") #false)
(check-expect (compare-letter #false #false) #false)
(check-expect (compare-letter "a" "a") "a")
(check-expect (compare-letter "z" "z") "z")
(define (compare-letter l1 l2)
  (if (equal? l1 l2)
      l1
      #false))
