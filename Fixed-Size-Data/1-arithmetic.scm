;; ex-2
(define prefix "hello")
(define subfix "world")

(define (ex-2)
  (string-append prefix "_" subfix))


;;

(string-length "hello")

(string-length "world")

;; (string-length 32) -- error only can give a string argument to string-length

(string-ith prefix 2) ;; "l"
(string-ith prefix 0) ;; "h"

(number->string 42)   ;; "42"

(string->number "42") ;; 42

(+ (string-length "hello world") 20) ;; (+ 11 20) == 31
;; error mixed expression
;; (+ (string-length (string-append 32 42))
;;    "hello")
	       
;; ex-3 get "hello_world"
(define str "helloworld")
(define ind "0123456789")
(define i 5)

(define (string-insert str i inserted)
  (string-append (substring str 0 i)
		 inserted
		 (substring str i)))

(string-insert i str "_")

;; ex-4
(define (string-remove-at str i)
  (string-append (substring str 0 i)
		 (substring str (+ i 1))))

(string-remove-at str i) ;; remove "w" == "helloorld"

;; 1.4

(require 2htdp/image)
;; circle, ellipse, line, rectangle, text, triangle

(circle 10 "solid" "green")

(rectangle 10 20 "solid" "blue")

(star 12 "solid" "gray")

(image-width (circle 10 "solid" "green")) ;; 20, 10 is radius of circle

(image-height (rectangle 10 20 "solid" "blue")) ;; 20

(+ (image-width (circle 10 "solid" "red"))
   (image-height (rectangle 10 20  "solid" "blue")))

;; (+ (image-width circle-10) (image-height rectangle-10-20))
;; (+ 20 20) == 40

;; the anchor point -- needed when compose two or more images

;; overlay -- place all the images to which it is applied on top of each other, use the center as anchor point
;; overlay/xy accepts two number x and y between two image arguments. sheifts the second image x pixels right, y pixels down
(define C (circle 10 "solid" "green"))
(define R (rectangle 10 20 "solid" "red"))
(overlay C R) ;; i1 i2 is ...
(overlay/xy C 10 10 R) ;; i1 x y i2
(overlay/align "left" "middle" C R) ;; x-place y-place i1 i2 is ...

(scene+line (empty-scene 100 100) 0 0 100 100 "blue") ;; draw (0,0) to (100, 100) line on given scene

;; Ex-5 use 2htdp/image library to create a simple boat or tree
(require 2htdp/image)
;; constants
(define WIDTH 100)
(define HEIGHT 100)
;; graphic constants
(define TREE_TOP_LEAVES_WIDTH 10)
(define TREE_LEAVES_STEP 10)
(define TREE_SECOND_LEAVES_WIDTH (+ TREE_LEAVES_STEP TREE_TOP_LEAVES_WIDTH))
(define TREE_THIRD_LEAVES_WIDTH (+ TREE_LEAVES_STEP TREE_SECOND_LEAVES_WIDTH))
(define TREE_HEIGHT (* (+ TREE_TOP_LEAVES_WIDTH TREE_SECOND_LEAVES_WIDTH TREE_THIRD_LEAVES_WIDTH ) 1.5))
(define SCENE (empty-scene WIDTH HEIGHT))
;; functions
(define (create-tree-leaves width)
  (triangle width "solid" "green"))
(define (create-tree image)
  (place-image
   (overlay/xy
   (overlay/xy (create-tree-leaves TREE_TOP_LEAVES_WIDTH)
	       (- (/ TREE_TOP_LEAVES_WIDTH 2))
	       TREE_TOP_LEAVES_WIDTH
	       (create-tree-leaves TREE_SECOND_LEAVES_WIDTH))
   (- (/ TREE_TOP_LEAVES_WIDTH 2))
   (+ TREE_SECOND_LEAVES_WIDTH TREE_TOP_LEAVES_WIDTH)
   (triangle TREE_THIRD_LEAVES_WIDTH "solid" "green"))
   (/ WIDTH 2)
   (/ TREE_HEIGHT 2)
   (scene+line SCENE (/ WIDTH 2) (/ (- HEIGHT TREE_HEIGHT) 2) (/ WIDTH 2) HEIGHT "black")
   ))


;; Ex-6

;; (define cat ) copy from https://htdp.org/2022-8-7/Book/part_one.html
(define (image-pixels image) (* (image-width image) (image-height image)))

(image-pixels cat)
	       
;; Ex-7
(define sunny #true)
(define friday #false)

(or (not sunny) friday) ;; false
  
;; Ex-8
(require 2htdp/image)
;; (define cat .) 


(define image cat)
(if (= (image-width image) (image-height image))
    "square"
    (if (> (image-width image) (image-height image))
        "wide"
        "tall"))


;; data type


(rational? pi)

(rational? (/ 4 2))
(/ 4 2)
(rational? (/ 4 3))
(rational? 1)
(rational? (sqrt 2)) ;; true
(rational? (sqrt -1));; false

(exact? 1) 				;; true
(exact? pi)				;; false
(inexact? (sqrt 2))			;; true
(inexact? (sin (/ pi 2)))		;; true

;; Ex-9
(define in)

(define (convert-in in)
  (cond ((string? in) (string-length in))
	((image? in) (* (image-width in) (image-height in)))
	((number? in) (abs in))
	((not in) 20)
	(in 10)))

;; (convert-in .) ;; any image
(convert-in "test")
(convert-in -2)
(convert-in #false)
(convert-in #true)





