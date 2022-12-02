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

(define-struct editor [pre post])
;; An Editor is a structure:
;;   (make-editor s t) describes an editor
;; whose visible text is (string-append s t) with
;; the cursor displayed between s and t
(define e1 (make-editor "hello" "world"))
(define e2 (make-editor "" "helloworld"))
(define e3 (make-editor "helloworld" ""))
;; String -> Image
;; render text as image, given t
(check-expect (render/text "hello") (text "hello" TEXT-SIZE "black"))
(check-expect (render/text "world") (text "world" TEXT-SIZE "black"))
(define (render/text t)
  (text t TEXT-SIZE TEXT-COLOR))
;; Editor -> Image
;; render editor as image, given e
(check-expect (render e1)
  (overlay/align "left" "center"
	       (editor/combine 
                (render/text (editor-pre e1))
                CURSOR
                (render/text (editor-post e1)))
               MTS))
			   
(check-expect (render e2)
  (overlay/align "left" "center"
	       (editor/combine 
                (render/text (editor-pre e2))
                CURSOR
                (render/text (editor-post e2)))
               MTS))
(define (render e)
  (overlay/align "left" "center"
		 (editor/combine
                      (render/text (editor-pre e))
                      CURSOR
                      (render/text (editor-post e)))
                     MTS))

(define (editor/combine pre cursor post)
  (beside/align "center"
		pre
		cursor
		post))


(define BACKSPACE "\b")
(define TAB "\t")
(define RETURN "\r")
(define LEFT "left")
(define RIGHT "right")

;; String Utils
;; String -> Boolean
;; return #true if s is empty (equal to "")
(define (string-empty? s)
  (string=? s ""))

;; String -> 1String or EmptyString
;; return the last character in s, return "" if s is empty
(check-expect (string-last "h") "h")
(check-expect (string-last "hello") "o")
(check-expect (string-last "") "")
(define (string-last s)
  (if (string-empty? s)
      ""
      (substring s (- (string-length s) 1))))
;; String -> 1String or EmptyString
;; return the first character in s, return "" if s is empty
(check-expect (string-first "h") "h")
(check-expect (string-first "hello") "h")
(check-expect (string-first "") "")
(define (string-first s)
  (if (string-empty? s)
      ""
      (substring s 0 1)))
;; String -> String
;; remove the last letter in s, if exist
(check-expect (string/remove-last "hello") "hell")
(check-expect (string/remove-last "h") "")
(check-expect (string/remove-last "") "")
(define (string/remove-last s)
  (if (string-empty? s)
      s
      (substring s 0 (- (string-length s) 1))))


(check-expect (string/remove-first "hello") "ello")
(check-expect (string/remove-first "h") "")
(check-expect (string/remove-first "") "")
(define (string/remove-first s)
  (if (string-empty? s)
      s
      (substring s 1)))

;; Editor -> Editor
;; remove the character immediately to the left of the cursor(if there are any)
(check-expect (edit/delete e1) 
	      (make-editor (string/remove-last (editor-pre e1)) (editor-post e1)))
(check-expect (edit/delete e2)
	      e2) 
(check-expect (edit/delete e3)
	      (make-editor (string/remove-last (editor-pre e3)) (editor-post e3)))

(define (edit/delete ed)
  (make-editor (string/remove-last (editor-pre ed)) (editor-post ed)))

;; Editor, String -> Editor
;; Append s to the pre field of ed
(check-expect (edit/append e1 "a") (make-editor "helloa" "world"))
(check-expect (edit/append e2 "a") (make-editor "a" "helloworld"))
(check-expect (edit/append e3 "a") (make-editor "helloworlda" ""))
(define (edit/append ed s)
  (make-editor (string-append (editor-pre ed) s)
	       (editor-post ed)))

;; Editor, Boolean -> Editor
;; if left? is #true, then move the last character of the pre field of ed
;; to the post field's head(if there are any), otherwise reverse move.
(check-expect (edit/move e1 #true) (make-editor "hell" "oworld"))
(check-expect (edit/move e1 #false) (make-editor "hellow" "orld"))
(check-expect (edit/move e2 #true) (make-editor "" "helloworld"))
(check-expect (edit/move e2 #false) (make-editor "h" "elloworld"))
(check-expect (edit/move e3 #true) (make-editor "helloworl" "d"))
(check-expect (edit/move e3 #false) (make-editor "helloworld" ""))
(define (edit/move ed left?)
  (if left?
      (make-editor (string/remove-last (editor-pre ed))
		   (string-append (string-last (editor-pre ed))
				  (editor-post ed)))
      (make-editor (string-append (editor-pre ed)
				  (string-first (editor-post ed)))
		   (string/remove-first (editor-post ed)))))
      
;; Editor, KeyEvent -> Editor
;; Computes new Editor according to the given editor and key event.
;; add single-character to the end of the pre field of ed, unless
;; ke denote the backspace ("\b") key. In that case, it deletes the
;; character immediately to the left of the cursor(if there are any).
;; Ignores the tab key ("\t") and the return key ("\r").
(define ot "abcdefghijklmnopqrstuvwxyzABCDE") ;; image-width = 199
(define e4 (make-editor ot "")) 
(check-expect (edit e1 BACKSPACE) (edit/delete e1))
(check-expect (edit e2 BACKSPACE) e2) 
(check-expect (edit e3 BACKSPACE) (edit/delete e3))
(check-expect (edit e1 TAB) e1)
(check-expect (edit e2 TAB) e2)
(check-expect (edit e3 TAB) e3)
(check-expect (edit e1 RETURN) e1)
(check-expect (edit e2 RETURN) e2)
(check-expect (edit e3 RETURN) e3)
(check-expect (edit e3 "a") (edit/append e3 "a"))
(check-expect (edit e2 "a") (edit/append e2 "a"))
(check-expect (edit e1 "a") (edit/append e1 "a"))
(check-expect (edit e1 "left")
	      (make-editor "hell" "oworld"))
(check-expect (edit e1 "right")
	      (make-editor "hellow" "orld"))
(check-expect (edit e2 "left") e2)
(check-expect (edit e2 "right") (make-editor "h" "elloworld"))

(check-expect (edit e3 "left") (make-editor "helloworl" "d"))
(check-expect (edit e3 "right") e3)
(check-expect (edit e4 "a") e4)
(check-expect (edit e4 "|") e4)
(check-expect (edit e4 "right") e4)
(check-expect (edit e4 "left") (make-editor (string/remove-last ot)
					    "E"))
(define (edit ed ke)
  (cond [(string=? ke RETURN) ed] ;; ignore
	[(string=? ke TAB) ed]    ;; ignore
	[(string=? ke BACKSPACE)  ;; delete
	 (edit/delete ed)]
	[(string=? ke LEFT) (edit/move ed #true)]  ;; move
	[(string=? ke RIGHT) (edit/move ed #false)];; move
	[else
	 (if (< WIDTH (+ (text-width (string-append
					(editor-pre ed)
					(editor-post ed)
					ke)
				     TEXT-SIZE)
			  1))
	     ed                     ;; ignore if too wide
	     (edit/append ed ke))])) ;; append

;; String, FontSize -> Number
;; Computes the width of the given t convert to text of image.
(check-expect (text-width ot TEXT-SIZE) 199)
(check-expect (text-width "a" TEXT-SIZE) 7)
(check-expect (text-width "1" TEXT-SIZE) 7)
(check-expect (text-width "A" TEXT-SIZE) 8)
(check-expect (text-width "" TEXT-SIZE) 0)
(check-expect (text-width "|" TEXT-SIZE) 3)
(define (text-width t s)
  (image-width (text t s "black")))

(define (run pre)
  (big-bang
   (make-editor pre "")
   [to-draw render]
   [on-key edit]))


;; Ex-86   
