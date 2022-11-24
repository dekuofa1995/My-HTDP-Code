;; TrafficLight -> TrafficLight
;; yields the next state given current state s
(check-expect (traffic-light-next "red") "green")
(check-expect (traffic-light-next "green") "yellow")
(check-expect (traffic-light-next "yellow") "red")

(define (traffic-light-next s)
  (cond
   [(string=? "red" s) "green"]
   [(string=? "green" s) "yellow"]
   [(string=? "yellow" s) "red"]))


(provide traffic-light-next)
