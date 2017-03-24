#lang racket/base

(require "data.rkt")

(provide (struct-out program))

;; Program code
;; Definitions for Program structs go here

;; A program should consist of two things - it's type and it's arguments
;; Type is the name of the binary (should be discoverable within $PATH)
;; Args is a list of strings to be used when creating a subprocess
(struct program (name type args))

; end
