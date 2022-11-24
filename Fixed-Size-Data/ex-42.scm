(require 2htdp/image)
;; right margin,width of image, WorldState -> get current
;; car from right margin distance by given current state and car-width
(define (distance-from-right-margin right car-wd cw)
  (- right (/ car-wd 2) cw))
