# MetaTerm

…is a vim-like mode based user interface enabling running multiple terminal applications at the same time while preserving the sequence of execution.

_MetaTerm_ is implemented in _QML_ and uses [QMLTermWidget] as its embedded terminal emulator.

Its source code is available on both [Github] and [cgit].

## Usage

_MetaTerm_ starts in insert mode which means that one can simply start typing a command and trigger its execution by pressing _enter_.

The list of running and killed terminal instances is navigable using _vim-like_ keybindings, i.e. using `j` and `k`. Additionally one can jump to the top using `g` and to the bottom using `G`. Navigation is also accessible in command mode via `:next`, `:prev` and `:jump <INDEX>`.

Insert mode may be entered manually using `i` and exited using `Shift+ESC`. The currently selected terminal instance is killable via `d`. Command mode is entered whenever one presses `:` in normal mode.

A list of all running processes and their respective index is exposed via `:ls`.

Settings may be explored and changed using `:set` in command mode, e.g. the window background is changeable via `:set window background <COLOR>`.

Furthermore _MetaTerm_'s command mode exposes a JavaScript prompt through `:exec <COMMAND>`.

## Screenshot

![MetaTerm in action](https://static.kummerlaender.eu/media/metaterm_1.png)

[Github]: https://github.com/KnairdA/MetaTerm/
[cgit]: http://code.kummerlaender.eu/MetaTerm/
[QMLTermWidget]: https://github.com/Swordfish90/QMLTermWidget/
