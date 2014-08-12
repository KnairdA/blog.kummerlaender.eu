# SimpleParser

…is a simple parser for resolving mathematical terms.

The term is parsed by generating a binary expression tree using the Shunting-Yard algorithm. The implementation itself does not use any external libraries and relies fully on the features provided by the C++ language and the standard library.

This application marks the first steps in C++ I took a couple of years back and is available on [Github] or [cgit].

### Current features

* Calculating terms with basic operators while respecting the priority of each operator
* Support for parentheses
* Support for alphabetic constants
* Export of the expression tree as [Graphviz] dot for visualization

[Graphviz]: http://www.graphviz.org/
[Github]: https://github.com/KnairdA/SimpleParser
[cgit]: http://code.kummerlaender.eu/SimpleParser/
