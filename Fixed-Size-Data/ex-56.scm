(define (main2 x)
  (big-bang x
   [to-draw show]
   [on-key launch]
   [on-tick fly]
   [stop-when zero?]))
   
