#lang racket/base

;; Subprocess code
;; All subprocess-related things should go here (if any)
(require racket/function)

(provide subp)

;; Create a subprocess from a proc and a list of arguments (if any given)
;; The idea is to use currying to start the process of creating a subprocess,
;; but curry it so we can call it later with an apply call to apply any arity
;; of arguments. The normal Subprocess function needs it's arguments at call-time
;; making it hard to have a flexible number of arguments anywhere in code (it doesn't
;; accept lists), so we use currying to handle that
(define (subp proc)
  (curry subprocess (current-output-port) #f 'stdout (find-executable-path proc)))
