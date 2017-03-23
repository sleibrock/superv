#lang racket/base

(require "data.rkt"
         "subprocess.rkt"
         "config.rkt")

(provide superv)

(define (superv conf-path)
  (define logger (create-logger "supervisor  " 9))
  (define-values
    (hard-rest sleep-count sleep-time init-sleep programs)
    (read-config conf-path))
  (define (cust-loop)
    (define cust (make-custodian))
    (parameterize ([current-custodian cust])
      (define threads '())
      (define revive  '())
      (sleep init-sleep)
      (define (loop x)
        (unless (= x sleep-count)
          (sleep sleep-time)
          (loop (add1 x)))
        (loop 0)))
    (when hard-restart
      (logger "Shutting down custodian")
      (custodian-shutdown-all cust)
      (logger "Resting for a bit")
      (sleep init-sleep))
    (cust-loop))
  (cust-loop)
