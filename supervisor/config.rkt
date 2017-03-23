#lang racket/base

(require json
         "data.rkt"
         "program.rkt")

(provide read-config)

(define (hash->program phash)
  (program (hash-ref phash 'program)
           (hash-ref phash 'args)))

(define (read-config file-path)
  (define jdata (read-json (open-input-file file-path)))
  (define hard-restart (hash-ref jdata 'hard_restarts default-hard-resets))
  (define sleep-count  (hash-ref jdata 'sleep_count default-sleep-count))
  (define sleep-time   (hash-ref jdata 'sleep_time default-sleep-time))
  (define init-sleep   (hash-ref jdata 'init_sleep default-init-sleep))
  (define bot-data     (hash-ref jdata 'bots #hasheq()))
  (values hard-restart sleep-count sleep-time init-sleep (map hash->program bot-data)))
