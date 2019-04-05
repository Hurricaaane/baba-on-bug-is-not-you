![Baba on Bug is not You](baba-on-bug-is-not-you.gif)

This is an experimental modification for the game *Baba is You*.

I have created it for my own personal mod development, in order to test the base game mechanics and possibly add new features on top of the base game.

## Development installation

The following are installation instructions intended for developers.

Copy your game's `Data/` directory as a subfolder of this repository's `game/` directory, in such a way that the directory `game/Data/` will exist.

The game files are ignored from git through `.gitignore` for convenience.

### Modify `values.lua` so that *bobiny-loader* starts

In order to start *bobiny-loader*, we need to modify one game file.

Add the following line at the top of the game file `game/Data/values.lua` :

```lua
require((__BOBINY_T or "") .. "BobinyLoader/bobiny-loader").loadAfterGameInit()
```

## Run tests

- Linux is `./test/run_tests.lua`
- Windows is `lua test\run_tests.lua`

## Visual log

*On Windows, MINGW64 may be used to run the game.*

The visual log is a tool that records the game state to a file, and exposes it through a websocket so that it can be displayed on web page.

- Install [joewalnes/websocketd](https://github.com/joewalnes/websocketd). It is a tool that emits the standard stream of a process to a websocket.

- Run `./start-game.sh`, which logs all lines starting with `#~\t` to a file.

- Run `./log-to-websocketd.sh` which exposes the log file through a websocket using [joewalnes/websocketd](https://github.com/joewalnes/websocketd).

- Run `???` to start the web application.
