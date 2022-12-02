(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 200)
(define HEIGHT 20)

(define CURSOR (rectangle 1 HEIGHT "solid" "red"))
(define TEXT-SIZE 16)
(define TEXT-COLOR "black")
(define MTS (empty-scene WIDTH HEIGHT))
(define MARGIN-LEFT 5)
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
              (place-image/align
	       (editor/combine 
                (render/text (editor-pre e1))
                CURSOR
                (render/text (editor-post e1)))
               MARGIN-LEFT
	       CENTER-Y
               "left"
               "center"
               MTS))
			   
(check-expect (render e2)
              (place-image/align
	       (editor/combine 
                (render/text (editor-pre e2))
                CURSOR
                (render/text (editor-post e2)))
               MARGIN-LEFT
	       CENTER-Y
               "left"
               "center"
	       
               MTS))
(define (render e)
  (place-image/align (editor/combine
                      (render/text (editor-pre e))
                      CURSOR
                      (render/text (editor-post e)))
                     MARGIN-LEFT
		     CENTER-Y
                     "left"
                     "center"
                     MTS))

(define (editor/combine pre cursor post)
  (beside/align "bottom"
		pre
		cursor
		post))
