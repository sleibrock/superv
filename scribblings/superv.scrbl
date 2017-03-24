#lang scribble/manual
@require[@for-label[racket/base]]

@title{superv - A Supervisor Program}
@author{steve}

@defmodule[superv]

@section[#:tag "intro"]{Introduction}

superv is a program aimed at running daemon-esque programs long-term without any monitoring. If you want to run a program and you don't want to watch it to keep rebooting it, this might be helpful to you.



