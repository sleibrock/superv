#lang racket/base

;; Data and utilities
;; Mostly used for constants and other unloved functions

;; Test module requires RackUnit
(module+ test
  (require rackunit))

(provide
 default-sleep-time
 default-sleep-count
 default-hard-resets
 default-init-sleep
 default-reset-sleep
 default-config-file
 default-name-factory
 span
 create-logger
 posint?
 )

;; Check used for positive integers
(define (posint? x) (and (positive? x) (integer? x)))

;; Constants to use in the supervisor process
(define default-sleep-time   30)
(define default-sleep-count  12)
(define default-hard-resets  #t)
(define default-init-sleep   30)
(define default-reset-sleep  30)
(define default-config-file  "config.json")

;; Used only by *create-logger, shouldn't be configurable through the JSON
(define default-print-string "[\033[38;5;~am~a\033[0m @ ~a:~a:~a] ~a")

;; Default program name - a closure that increments the number each time
(define (default-name-factory)
  (define counter 0)
  (λ ()
    (set! counter (add1 counter))
    (values (format "Program ~a" counter))))

;; Create a list of numbers much like racket/list:range
;; (We don't really want to pull in the whole racket/list library though)
(define (span x)
  (define (inner x lst)
    (if (< x 0)
        lst
        (inner (sub1 x) (cons x lst))))
  (cond
    [(< x 1) '()]
    [else (inner (sub1 x) '())]))

;; Message printer for the supervisor
;; Converts current seconds to a date and creates a time stamp in a very
;; convoluted, compressed and functional manner
(define (create-logger t-name color)
  (λ (msg)
    (define cd (seconds->date (current-seconds)))
    (displayln
     (apply (λ (x y z) (format default-print-string color t-name x y z msg))
            (map (λ (i) (format (if (< i 10) "0~a" "~a") i))
                 (list (date-hour cd) (date-minute cd) (date-second cd)))))))

;; Testing section ;;
(module+ test
   (test-case "Testing span works on strange inputs"
     (check-eq? '() (span 0) "Zero input")
     (check-eq? '() (span -1) "Negative input"))
   (test-case "Testing create-logger"
     (check-true (procedure? (create-logger "supervisor" 9)) "Creates a function?"))
   (test-case "Testing posint?"
     (check-true (posint? 1) "Is 1 a posint?"))
   )

;; end
