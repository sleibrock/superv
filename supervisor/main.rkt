#lang racket/base

(require "superv.rkt")

(module+ main
  (require racket/cmdline)
  (command-line
   #:program "superv"
   #:args (conf-path)
   (superv conf-path)))

; end
