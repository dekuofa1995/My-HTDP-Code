(define (show x)
  (cond
   [(string? x) (- HEIGHT CENTRE)]
   [(<= -3 x -1) (- HEIGHT CENTRE)]
   [(>= x 0) (- x CENTRE)]
   ))
;; Q: why can't use string=? at first clause
;; because the string=? function need a string argument
;; however x can be string or number, so it will throw an exception
;; when encounter x is a number.
