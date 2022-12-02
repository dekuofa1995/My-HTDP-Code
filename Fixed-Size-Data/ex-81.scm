
(define-struct time [hour minute second])

(define t1 (make-time 12 30 2))
;; Time -> Number
;; computes seconds corresponding given t
;; (define (time->second t)
;;   ... (time-hour t) ... (time-minute t) ... (time-second t))
(check-expect (time->second t1) 45002)
(check-expect (time->second (make-time 0 0 0)) 0)
(check-expect (time->second (make-time 0 0 1)) 1)
(check-expect (time->second (make-time 0 1 0)) 60)
(check-expect (time->second (make-time 1 0 0)) 3600)
(define (time->second t)
  (+ (time-second t)
     (* 60
	(+ (time-minute t)
	   (* 60 (time-hour t))))))
