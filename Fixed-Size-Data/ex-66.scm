
(define-struct movie [title producer year])
(define-struct person [name hair eyes phone])
(define-struct pet [name number])
(define-struct CD [artist title price])
(define-struct sweater [material size producer])

(make-movie "BreaveHeart" "Mel Gibson" 1995)

(make-person "Tom" "brown" "blue" "1563344444")
(make-pet "dog" 1)
(make-CD "Walkure" "Walkure wa Uragiranai" 3000)

(make-sweater "wool" "L" "Tom")
