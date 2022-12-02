(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 200)
(define HEIGHT 20)

(define CURSOR (rectangle 1 HEIGHT "solid" "red"))
(define TEXT-SIZE 12)
(define TEXT-COLOR "black")
(define MTS (empty-scene WIDTH HEIGHT))
(define MARGIN-LEFT 0)
(define CENTER-Y (/ HEIGHT 2))

(define LEFT "left")
(define RIGHT "right")
(define BACKSPACE "\b")
(define TAB "\t")
(define RETURN "\r")
;; A Editor is a structure:
;;   (make-editor String Index)
;; String describes current text in editor
;; Index is an NonNegativeNumber which describes the cursor's location
;; treat all index of the characters are added 0.5
;; then index = 0 means the cursor at the head, the left of the first character
;; index = 1 means the cursor in characters between the first and the second
(define-struct editor [text idx])
(define e1 (make-editor "" 0))            ;; |
(define e2 (make-editor "helloworld" 1))  ;; h|elloworld
(define e3 (make-editor "helloworld" 0))  ;; |helloworld
(define e4 (make-editor "helloworld" 9)) ;; helloworl|d
(define e5 (make-editor "helloworld" 10)) ;; helloworld|


;; Image, Image -> Image
;; Combines pre, post and CURSOR to one images
;; the order is pre CURSOR post
(check-expect (render-combine i1
			      i2)
	      (beside/align "center"
			    i1
			    CURSOR
			    i2))
(check-expect (render-combine i2
			      i1)
	      (beside/align "center"
			    i2
			    CURSOR
			    i1))
(define (render-combine pre post)
  (beside/align "center"
		pre
		CURSOR
		post))
;; String -> Image
;; render given text as image
(check-expect (render-text "helloworld")
	      (text "helloworld" TEXT-SIZE TEXT-COLOR))
(check-expect (render-text "") (text "" TEXT-SIZE TEXT-COLOR))
(define (render-text t)
  (text t TEXT-SIZE TEXT-COLOR))
(define i1 (render-text "hello"))
(define i2 (render-text "world"))

(check-expect (render e1)
	      (overlay/align "left" "center"
		 (render-combine
		  (render-text "")
		  (render-text ""))
		 MTS))
(check-expect (render e2)
	      (overlay/align "left" "center"
		 (render-combine
		  (render-text "h")
		  (render-text "elloworld"))
		 MTS))
(check-expect (render e3)
	      (overlay/align "left" "center"
		 (render-combine
		  (render-text "")
		  (render-text "helloworld"))
		 MTS))

(check-expect (render e4)
	      (overlay/align "left" "center"
		 (render-combine
		  (render-text "helloworl")
		  (render-text "d"))
		 MTS))
(check-expect (render e5)
	      (overlay/align "left" "center"
		 (render-combine
		  (render-text "helloworld")
		  (render-text ""))
		 MTS))
;; Editor -> Image
;; render editor image by given ed
(define (render ed)
  (overlay/align "left" "center"
		 (render-combine
		  (render-text (substring (editor-text ed)
					     0 (editor-idx ed)))
		  (render-text (substring (editor-text ed)
					     (editor-idx ed))))
		 MTS))



;; Editor, KeyEvent -> Image
;; - If KeyEvent is "left"/"right" then move the cursor to left/right
;; - Ignore return("\r") and tab("\t") key stroke
;; - If backspace("\b") keystroke then remove the charactor immediately
;; to the left of the cursor (if there are any)
;; - 1String append to the text field of editor
;; - Other Ignore
(check-expect (edit e1 "a") (make-editor "a" 1))
(check-expect (edit e1 LEFT) e1)
(check-expect (edit e1 RIGHT) e1)
(check-expect (edit e1 "up") e1)
(check-expect (edit e1 "down") e1)
(check-expect (edit e1 BACKSPACE) e1)
(check-expect (edit e1 TAB) e1)
(check-expect (edit e1 RETURN) e1)
 ;; h|elloworld
(check-expect (edit e2 LEFT) (make-editor "helloworld" 0)) ;; |helloworld
(check-expect (edit e2 RIGHT) (make-editor "helloworld" 2)) ;; he|lloworld
(check-expect (edit e2 "up") e2) 
(check-expect (edit e2 "down") e2) 
(check-expect (edit e2 BACKSPACE) (make-editor "elloworld" 0)) ;; |elloworld
(check-expect (edit e2 TAB) e2) 
(check-expect (edit e2 RETURN) e2)
(define (edit ed ke)
  (cond [(string=? ke LEFT) (edit-move ed #true)]
	 [(string=? ke RIGHT) (edit-move ed #false)]
	 [(string=? ke TAB) ed]
	 [(string=? ke RETURN) ed]
	 [(string=? ke BACKSPACE) (edit-delete ed)]
	 [(1string? ke) (edit-insert ed ke)]
	 [else ed]))
;; Editor -> Boolean
;; check wheather current cursor is editor's head
(check-expect (cursor-head? e1) #true)
(check-expect (cursor-head? e2) #false)
(check-expect (cursor-head? e3) #true)
(check-expect (cursor-head? e4) #false)
(check-expect (cursor-head? e5) #false)
(define (cursor-head? ed)
  (= 0 (editor-idx ed)))
;; Editor -> Boolean
;; check wheather current cursor is editor's tail
(check-expect (cursor-tail? e1) #true)
(check-expect (cursor-tail? e2) #false)
(check-expect (cursor-tail? e3) #false)
(check-expect (cursor-tail? e4) #false)
(check-expect (cursor-tail? e5) #true)

(define (cursor-tail? ed)
  (= (string-length (editor-text ed))
     (editor-idx ed)))
;; Editor -> Editor
;; Remove the charactor immediately to the left of the cursor(if there are any)
(check-expect (edit-delete e1) e1) ;; |
(check-expect (edit-delete e2) (make-editor "elloworld" 0)) ;; |elloworld
(check-expect (edit-delete e3) e3) ; |helloworld
(check-expect (edit-delete e4) (make-editor "helloword" 8)) ; hellowor|d
(check-expect (edit-delete e5) (make-editor "helloworl" 9)) ; helloworl|
(define (edit-delete ed)
  (if (cursor-head? ed)
      ed
      (make-editor
       (string-append (substring (editor-text ed) 0 (- (editor-idx ed) 1))
		      (substring (editor-text ed) (editor-idx ed)))
       (- (editor-idx ed) 1))))

;; Editor, String -> Editor
;; insert s into editor at current editor's cursor location
(check-expect (edit-insert e1 "a") (make-editor "a" 1))
(check-expect (edit-insert e1 "ab") (make-editor "ab" 2))
(check-expect (edit-insert e1 "") e1)
(check-expect (edit-insert e2 "a") (make-editor "haelloworld" 2)) ; ha|elloworld
(define (edit-insert ed s)
  (make-editor
   (cond [(cursor-head? ed) (string-append s (editor-text ed))]
	 [(cursor-tail? ed) (string-append (editor-text ed) s)]
	 [else (string-append
		(substring (editor-text ed) 0 (editor-idx ed))
		s
		(substring (editor-text ed) (editor-idx ed)))])
   (+ (string-length s)
      (editor-idx ed))))
;; Editor, Boolean -> Editor
;; Move editor's cursor 1 character(if not the head/tail)
;; left? describes the direction of moving.
(check-expect (edit-move e1 #true) e1)
(check-expect (edit-move e1 #false) e1)
(check-expect (edit-move e2 #true) e3)
(check-expect (edit-move e3 #false) e2)
(check-expect (edit-move e5 #true) e4)
(check-expect (edit-move e4 #false) e5)
(define (edit-move ed left?)
  (if left?
      (if (cursor-head? ed) ;; head
	  ed
	  (make-editor (editor-text ed)
		       (- (editor-idx ed) 1)))
      (if (cursor-tail? ed)
	  ed
	  (make-editor (editor-text ed)
		       (+ (editor-idx ed) 1)))))
  
;; String -> Boolean
;; return #true only if s has one character
(check-expect (1string? "\t") #true)
(check-expect (1string? "\b") #true)
(check-expect (1string? " ") #true)
(check-expect (1string? "left") #false)
(check-expect (1string? "up") #false)
(check-expect (1string? "down") #false)
(define (1string? s) (= 1 (string-length s)))

(define (run text)
  (big-bang (make-editor text 0)
	    [to-draw render]
	    [on-key edit]))
