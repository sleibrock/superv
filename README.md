superv - A Supervisor in Racket
======

## What is superv?

`superv` is a Racket program made to run any kind of program and keep it running. It's good at keeping subprocesses alive and making sure they stay alive by watching their statuses and seeing if they go down, and will reboot the process when needed.

Ideally with a supervisor you can run long-term programs that are meant to stay alive 24/7 and `superv` will watch them for you to ensure they stay alive. Possible application uses include:

* Keeping Chat bots alive (Slack, Facebook Messenger, Discord, etc.)
* Web crawlers and scrapers for gathering information
* Stock tickers to keep you notified of prices at certain intervals
* E-mail daemons using any combination of above applications
* Hosting web servers across different ports
* Hosting a game server with complex configurations
* Twilio bots to text you about various info

## Install

`superv` is a program that can be used directly right from Racket's `raco` command. Once you install `superv` with:

```
something about downloading a Raco PLT package here
```

Then you can run

```
raco superv <your_config.json>
```

Look under the `samples/` folder for an example JSON configuration you can edit to create your own `superv` configuration.

## Requirements

`superv` requires Racket and `raco` but should run on any Racket version above 6.5 at least.
