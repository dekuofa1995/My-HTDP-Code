
;; Ex-12
(define (cube x)
  (* x x x))
(define (cvolume side)
  (cube side))
(cvolume 3)

(define (csurface side)
  (* 6 (sqr side)))
(csurface 2)

;; Ex-13
(define (string-first inp)
  (if (and (string? inp) (> (string-length inp) 0))
      (string-ith inp 0)
      ""))

(string-first "a")
(string-first "abcd")
(string-first "")

;; Ex-14
(define (string-last s)
  (if (and (string? s) (> (string-length s) 0))
      (string-ith s (- (string-length s) 1))
      ""))

(string-last "abc")
(string-last "a")
(string-last "")

;; Ex-15
(define (==> sunny friday)
  (or (not sunny) friday))

(and (==> #true #true))
(not (==> #true #false))
(and (==> #false #true))
(and (==> #false #false))

;; Ex-16
(define (image-area i)
  (if (image? i)
      (* (image-length i) (image-width i))
      0))

;; Ex-17
(define (image-classify i)
  (cond ((> (image-width i) (image-height i)) "wide")
	((< (image-width i) (image-height i)) "tall")
	((= (image-width i) (image-height i)) "square")))
(define TALL (rectangle 10 20 "solid" "blue"))
(define WIDE (rectangle 30 20 "solid" "blue"))
(define SQUARE (rectangle 20 20 "solid" "blue"))
(image-classify TALL)
(image-classify WIDE)
(image-classify SQUARE)

;; Ex-18

(define (string-join s1 s2)
  (string-append s1 "_" s2))

(string-join "hello" "world")

;; Ex-19
(define (string-insert str i)
  (string-append (substring str 0 i)
		 "_"
		 (substring str i)))

(string-insert "helloworld" 5)

;; Ex-20
(define (string-delete str i)
  (if (or (>= i (string-length str)) (< i 0))
      str
      (string-append (substring str 0 i)
		     (substring str (+ i 1) (string-length str)))))

(string-delete "hello" 0)
(string-delete "hello" 3)
(string-delete "hello" 4)
(string-delete "hello" -1)
(string-delete "hello" 5)


;; 2.2 Computing ;;

;; Ex-21
(define (ff x)
  (* 10 x))

(ff (ff 1))
;; (ff (* 10 1))
;; (ff 10)
;; (* 10 10)
;; 100
(+ (ff 1) (ff 1))
;; (+ (* 10 1) (ff 1))
;; (+ 10 (ff 1))
;; (+ 10 (* 10 1)) ;; DrRocket not reuse the results of expression (ff 1)
;; (+ 10 10)
;; 20

;; Ex-22
(define (distance-to-origin x y)
  (sqrt (+ (sqr x) (sqr y))))

(distance-to-origin 3 4)
;; (sqrt (+ (sqr 3) (sqr 4)))
;; (sqrt (+ 9 (sqr 4)))
;; (sqrt (+ 9 16))
;; (sqrt 25)
;; 5

;; Ex-23
(define (string-first s)
  (substring s 0 1))

(string-first "hello world")
;; (substring "hello world" 0 1)
;; "h"

;; Ex-24
(define (==> x y)
  (or (not x) y))

(==> #true #false)
;; (or (not #true) #false)
;; (or #false #false)
;; #false

;; Ex-25
(define (image-classify i)
  (cond ((>= (image-width i) (image-height i)) "wide") ;; to Fix it, need remove equal check
	((<= (image-width i) (image-height i)) "tall") ;; to Fix it, need remove equal check
	((= (image-width i) (image-height i)) "square")))


;; Ex-26
(define (string-insert s i)
  (string-append (substring s 0 i)
		 "_"
		 (substring s i)))

(string-insert "helloworld" 6)
;; (string-append (substring "helloworld" 0 6) "_" (substring "helloworld" 6))
;; (string-append "hellow" "_" (substring "helloworld" 6))
;; (string-append "hellow" "_" "orld")
;; "hellow_orld"

;; 2.3 Composing function ;; 
(define (letter fst lst signature-name)
  (string-append
   (opening fst)
   "\n\n"
   (body fst lst)
   "\n\n"
   (closing signature-name)))

(define (opening fst)
  (string-append "Dear " fst ","))

(define (body fst lst)
  (string-append
   "We have discovered that all people with the" "\n"
   "last name " lst " have won our lottery. So, " "\n"
   fst ", " "hurry and pick up your prize."))

(define (closing signature-name)
  (string-append
   "Sincerely,"
   "\n\n"
   signature-name
   "\n"))

(write-file 'stdout (letter "Matt" "Fiss" "Fell")) ;; (require 2htdp/batch-io)

;; EX-27 best profit
(define COST_FIXED 180)
(define COST_PRE_ATT 0.04)
(define INIT_ATTENDANCE 120)
(define INIT_PRICE 5.0)
(define PRICE_STEP 0.1)
(define PEOPLE_STEP 15)

(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(define (revenue ticket-price)
  (* (attendees ticket-price) ticket-price))

(define (attendees price)
  (- INIT_ATTENDANCE
     (* (/ (- price INIT_PRICE) PRICE_STEP) PEOPLE_STEP)))

(define (cost ticket-price)
  (+ COST_FIXED (* (attendees ticket-price) COST_PRE_ATT)))

;; EX-28
(profit 1);; 511.2
(profit 2);; 937.2
(profit 3);; 1063.2
(profit 4);; 889.2
(profit 5);; 415.2

(profit 2.5) ;; 1037.7
(profit 3.5) ;; 1013.7

(profit 2.75) ;; 1059.825
(profit 3.25) ;; 1047.825
(profit 2.875) ;; 1063.856
(profit 3.125) ;; 1057.856

(profit 2.9) ;; 1064.1 -- best

;; Ex-29
(define COST_FIXED 0)
(define COST_PRE_ATT 1.5)
(define INIT_ATTENDANCE 120)
(define INIT_PRICE 5.0)
(define PRICE_STEP 0.1)
(define PEOPLE_STEP 15)

;; SAME with Ex-28 START;;
(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(define (revenue ticket-price)
  (* (attendees ticket-price) ticket-price))

(define (attendees price)
  (- INIT_ATTENDANCE
     (* (/ (- price INIT_PRICE) PRICE_STEP) PEOPLE_STEP)))

(define (cost ticket-price)
  (+ COST_FIXED (* (attendees ticket-price) COST_PRE_ATT)))
;; SAME END ;;

(profit 3) ;; 630
(profit 4) ;; 675
(profit 5) ;; 420


;; 2.4 Global Constants ;;
;;; For evry constant mentioned in a problem statement, introduce one constant definition.

;; Ex-30
(define PRICE_STEP 0.1)
(define PEOPLE_STEP 15)
(define price-change-of-att (/ PEOPLE_STEP PRICE_STEP))


;; 2.5 Programs ;;
(require 2htdp/batch-io)
(define NL "\n")
(define (C f)
  (* 5/9 (- f 32)))
(define (convert in out)
  (write-file out
              (string-append
               NL
               (number->string
                (C
                 (string->number (read-file in))))
               NL)))

(convert 'stdin 'stdout)


;; Ex-31
(require 2htdp/batch-io)
(define (letter fst lst signature-name)
  (string-append
   (opening fst)
   "\n\n"
   (body fst lst)
   "\n\n"
   (closing signature-name)))

(define (opening fst)
  (string-append "Dear " fst ","))

(define (body fst lst)
  (string-append
   "We have discovered that all people with the" "\n"
   "last name " lst " have won our lottery. So, " "\n"
   fst ", " "hurry and pick up your prize."))

(define (closing signature-name)
  (string-append
   "Sincerely,"
   "\n\n"
   signature-name
   "\n"))

(define STD_IN 'stdin)
(define STD_OUT 'stdout)
(write-file 'stdout (letter "Matthew" "Fisler" "Felleisen"))
(write-file 'stdout
	    (letter (read-file STDIN) (read-file STDIN) (read-file STDIN)))

(define (main in-fst in-lst in-signature out)
  (write-file out
	      (letter (read-file in-fst)
		      (read-file in-lst)
		      (read-file in-signature))))

(main STD_IN STD_IN STD_IN STD_OUT)


;; Ex-32
;; hear, touch, pain, feel, speak, emotion, move, eat, sleep, write.
(require 2htdp/universe)
(require 2htdp/image)

(define (number->square s)
  (square s "solid" "red"))

