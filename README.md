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
raco pkg install superv
```

Then you can run

```
raco superv <your_config.json>
```

Look under the `samples/` folder for an example JSON configuration you can edit to create your own `superv` configuration.

## Requirements

`superv` requires Racket >= 6.5 at least. Racket can be obtained from [the official Racket website](http://racket-lang.org)

## Constructing a Configuration File

`superv` reads from a JSON file which allows you to tweak some minor settings, but also define the programs you want to run. The most basic JSON layout for defining a single `sleep` process would look like this:

```
{
	"programs": [
		{
			"name": "Sleep for 10",
			"program": "sleep",
			"args": [
				"10"
			]
		}
	]
}
```

A running program is defined as a basic JSON object with three properties - a name to label it, the program's binary and the arguments used. The program MUST be discoverable within your `$PATH` variable, else Racket will fail to locate it through `find-executable-path`. On macOS/Linux, you can do `echo $PATH` to take a look. Under Windows, you will have to inspect your `PATH` variable and adust it through System Variabe settings.

The arguments supplied should always be strings. There is no implicit casting to strings right now, so make sure your arguments are supplied as strings in the JSON, else it will fail (`subprocess` in Racket only allows strings).

Additional values can be defined as well alongside `programs`. This is the list of all supported values that will be read and will adjust runtime values.

* `sleep_count` - Integer, determines the number of check cycles before attempting to reboot all processes
* `sleep_time` - Integer, delay between sleep check cycles
* `init_sleep` - Integer, initial delay after processes have been started before checks start
* `hard_restarts` - Boolean, determines whether all programs will be shut down and restarted after `sleep_count` cycles has been reached, else tells the program to infinitely check processes

