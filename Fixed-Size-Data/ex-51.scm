(require "ex-50.scm") ;; traffic-light-next
(require 2htdp/image)
(require 2htdp/universe)

;; constants
(define RAIDUS-OF-LIGHT 20)
;; TrafficLight is a Enumuration:
;; - "red"
;; - "green"
;; - "yellow"

;; simulates a traffic light for a given duration.

;; render traffic light as a solid circle of the appropriate color.
(define (render color)
  (circle RADIUS-OF-LIGHT "solid" color))
;; change state on every clock tick

(define (main color)
  (big-bang color
	    [on-tick traffic-light-next]
	    [to-draw render]))
