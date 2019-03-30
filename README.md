![Baba on Bug is not You](baba-on-bug-is-not-you.gif)

## Setup

Copy your game's `Data/` directory as a subfolder of this repository's `game/` directory, in such a way that the directory `game/Data/` will exist.

The game files are ignored from git through `.gitignore` for convenience.

### Modify `values.lua` so that *bobiny-loader* starts

In order to start *bobiny-loader*, we need to modify one game file.

Add the following line at the top of the game file `game/Data/values.lua` :

```lua
require((__BOBINY_T or "") .. "BobinyLoader/bobiny-loader")
```

## Run tests

- Linux is `./test/run_tests.lua`
- Windows is `lua test\run_tests.lua`
