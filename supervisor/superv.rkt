#lang racket/base

(require "data.rkt"
         "subprocess.rkt"
         "config.rkt"
         "program.rkt")

(provide superv)

;; Accept a program struct, get it's curried form and return a subprocess type
(define (start-prog prog)
  (define-values (a b c d)
    (parameterize ([current-subprocess-custodian-mode 'kill])
      (define subber (subp (program-type prog)))
      (apply subber (program-args prog))))
  (values a))

;; Return a function that takes an ID and yields a new subprocess
(define (prog-factory prog-source logger)
  (λ (prog-id)
    (define prog (vector-ref prog-source prog-id))
    (define sub  (start-prog prog))
    (logger (format "Started '~a' (PID ~a)"
                    (program-name prog)
                    (subprocess-pid sub)))
    (values sub)))

;; Return a function that takes an ID and mutates the vector with a new subproc
(define (reviver threads factory logger)
  (λ (prog-id)
    (define sub (vector-ref threads prog-id))
    (when (not (eqv? 'running (subprocess-status sub)))
      (subprocess-kill sub #t)
      (vector-set! threads prog-id (factory prog-id)))))

;; Supervisor function
;; Steps broken down:
;; 1) create a logger and define the JSON config read-in values (config.rkt)
;; 2) Define the new custodian to feed into the update loop
;; 3) Do the updates and execute cycles and pauses based on sleep-count/sleep-time
;; 4) If hard-rest is defined, kill the current cust and pass in a new one to the loop
;; 5) Jump back to 3) and begin the infinite loop
(define (superv conf-path)
  (define logger (create-logger "supervisor  " 9))
  (define-values
    (hard-rest sleep-count sleep-time init-sleep programs)
    (read-config conf-path))
  (define total-progs (vector-length programs))
  (define make-prog (prog-factory programs logger))

  (define (cust-loop)
    (logger "Starting custodian")
    (define cust (make-custodian))
    (parameterize ([current-custodian cust])
      (define threads (build-vector total-progs make-prog))
      (define revive (reviver threads make-prog logger))
      (logger "Subprocesses initialized")
      (sleep init-sleep)
      (define (loop x)
        (unless (= x sleep-count)
          (logger "Checking on subprocesses")
          (for-each revive (span total-progs))
          (sleep sleep-time)
          (loop (if hard-rest (add1 x) 0))))
      (loop 0))
    (logger "Shutting down Custodian")
    (custodian-shutdown-all cust)
    (sleep sleep-time)
    (cust-loop))
  (cust-loop))

; end
