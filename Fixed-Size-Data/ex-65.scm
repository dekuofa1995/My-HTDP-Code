
(define-struct movie [title producer year])
(define-struct person [name hair eyes phone])
(define-struct pet [name number])
(define-struct CD [artist title price])
(define-struct sweater [material size producer])

;; constructors
(make-movie title producer year)
(make-person name hair eyes phone)
(make-pet name number)
(make-CD artist title price)
(make-sweater material size producer)

;; selectors
(movie-tile movie)
(movie-producer movie)
(movie-year movie)

(person-name p)
(person-hair p)
(person-eyes p)
(person-phone p)

(pet-name p)
(pet-number p)

(CD-artist cd)
(CD-title cd)
(CD-price cd)

(sweater-material s)
(sweater-size s)
(sweater-producer s)

;; predicates
(movie? m)
(person? p)
(pet? p)
(CD? cd)
(sweater? s)
