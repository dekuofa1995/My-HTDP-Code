
(check-expect (manhattan-distance (make-posn 3 4)) 7)
(check-expect (manhattan-distance (make-posn 5 4)) 9)
(check-expect (manhattan-distance (make-posn 0 0)) 0)
(check-expect (manhattan-distance (make-posn 0 6)) 6)
(check-expect (manhattan-distance (make-posn 5 0)) 5)
(define (manhattan-distance ap)
  (+ (posn-x ap)
     (posn-y ap)))
      
