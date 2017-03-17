#lang racket/base

(define my-var 5)
(provide my-var)

(module+ main
  (require racket/cmdline)
  (displayln "Hi")
  (displayln "This is text"))
