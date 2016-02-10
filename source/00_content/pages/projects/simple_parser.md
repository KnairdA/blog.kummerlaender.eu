# SimpleParser

…is a simple parser for resolving mathematical terms.

The term is parsed by generating a binary expression tree using the [Shunting-Yard] algorithm. The implementation itself does not use any external libraries and relies fully on the features provided by the C++ language and the standard library.

This application marks the first steps in C++ I took a couple of years back and is available on [Github] or [cgit].

## Current features

* Calculating terms with basic operators while respecting the priority of each operator
* Support for parentheses
* Support for alphabetic constants
* Export of the expression tree as [Graphviz] `dot` for visualization

## Visualization

The ability to export the internal binary expression tree resulting from the parsed term as [Graphviz] `dot` is useful for both visualization and debugging purposes. In the following image you can see the depiction of the tree resulting from the arbitrarily chosen term `2.5*(2+3-(3/2+1*(21+11+(5*2))))`:

![Visualization of the parsed tree using Graphviz](https://static.kummerlaender.eu/media/parser_tree.png)

[Graphviz]: http://www.graphviz.org/
[Github]: https://github.com/KnairdA/SimpleParser/
[cgit]: http://code.kummerlaender.eu/SimpleParser/
[Shunting-Yard]: http://en.wikipedia.org/wiki/Shunting-yard_algorithm
