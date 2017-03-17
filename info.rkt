#lang info
(define collection "superv")
(define deps '("base"
               "rackunit-lib"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("scribblings/superv.scrbl" ())))
(define pkg-desc "Keep processes running with Racket")
(define version "0.0")
(define pkg-authors '(steve))
