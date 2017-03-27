#lang racket/base

(require json
         "data.rkt"
         "program.rkt")

(provide read-config)

(define namer (default-name-factory))

(define (hash->program phash)
  (program (hash-ref phash 'name (namer))
           (hash-ref phash 'program)
           (hash-ref phash 'args '())))

;; Define a configuration reading system here
;; You can add more variables as you see fit
;; All data is returned as a Values (relatively easier than vec/hashref calls)
(define (read-config file-path)
  (define jdata (read-json (open-input-file file-path)))
  (define hard-restart (hash-ref jdata 'hard_restarts default-hard-resets))
  (define sleep-count  (hash-ref jdata 'sleep_count   default-sleep-count))
  (define sleep-time   (hash-ref jdata 'sleep_time    default-sleep-time))
  (define init-sleep   (hash-ref jdata 'init_sleep    default-init-sleep))
  (define rest-sleep   (hash-ref jdata 'reset_sleep   default-reset-sleep))
  (define program-data (hash-ref jdata 'programs      '()))

  ;; Do error checks here to see if we have a decent JSON file
  (when (eqv? '() program-data)
    (error "No programs defined"))
  (unless (posint? sleep-count)
    (error "sleep_count not a positive-integer"))
  (unless (posint? sleep-time)
    (error "sleep_time not a positive-integer"))
  (unless (posint? init-sleep)
    (error "init_sleep not a positive-integer"))
  (unless (boolean? hard-restart)
    (error "hard_restarts not a boolean"))

  ;; Return the values
  (values hard-restart
          sleep-count
          sleep-time
          init-sleep
          rest-sleep
          (list->vector (map hash->program program-data))))
