# sleepless

Keep your MacBook awake with the lid closed, so long-running jobs (AI agents, builds, downloads) keep going. Works on battery and without an external display.

It works like `caffeinate`: it runs in the foreground of a terminal window, and when that window closes, normal sleep comes back.

## Why not `caffeinate`?

`caffeinate` stops the Mac from going to sleep when it is idle, but closing the lid still puts it to sleep. `sleepless` uses `pmset disablesleep` instead. That setting turns off system sleep entirely, including on lid close.

## Usage

```sh
sleepless          # stay awake until the window closes, Ctrl+C, or 20% battery
sleepless 2h       # same, but stop after 2 hours at the latest (also: 90m, 30m, ...)
sleepless status   # show state, battery and remaining time (from any window)
sleepless off      # force off, e.g. if the process was killed with kill -9
```

Normal sleep is restored automatically when:

- the terminal window is closed or you press Ctrl+C
- the duration is over
- the battery reaches 20%
- the Mac reboots

Only one instance runs at a time. It does not start if the battery is already at 20% or below.

## Install

```sh
git clone https://github.com/thielbased/sleepless.git
cd sleepless
./install.sh
```

`install.sh` asks for your password once. It installs the command to `/usr/local/bin/sleepless` and adds `/etc/sudoers.d/sleepless`. That rule lets your user run exactly two commands without a password:

```
<you> ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1
```

sudoers matches arguments literally, so the rule allows nothing beyond those two commands. It is checked with `visudo` before it is installed.

## Uninstall

```sh
./uninstall.sh
```

This restores normal sleep and removes both files.

## Notes

- A closed MacBook under heavy load has less airflow and can get hot. Don't leave it running at full load inside a bag.
- `pmset disablesleep` depends on hardware and macOS version. Check that it worked with `pmset -g | grep SleepDisabled` (it should show `1`).
- Inspired by [Aboudjem/Sleepless](https://github.com/Aboudjem/Sleepless), a menu-bar app built on the same mechanism.
