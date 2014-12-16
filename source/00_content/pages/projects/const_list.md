# ConstList

…is a experimental compile-time functional-style list library written in C++.

The MIT licensed implementation may be found on [Github] or [cgit].

It was written as a experiment in how far one could take the optional compile-time executability offered by `constexpr` specifically and the C++ template metaprogramming facilities in general. While basic _Cons_ structures and appropriate accessor functions turned out to be quite straight forward to implement, the current problem is the absence of workable arbitrary value comparison in a templated context if one doesn't want to be limited to values that can be used as template parameters such as integers. This means that it is currently impossible to e.g. filter a list using `foldr`.

## Current features

- `Cons` class template for representing constant list structures at compile time
- `make` method template for easily constructing `Cons` structures
- list constructors such as `make` and `concatenate`
- basic list accessors such as `size`, `head`, `tail`, `nth` and `take`
- higher order list operators such as `foldr`, `foldl` and `map`
- higher order list queries such as `any`, `all`, `none` and `count`
- special purpose methods such as `reverse`
- test cases for all of the above
- MIT license

## Usage example

~~~
const int sum{
	ConstList::foldr(
		ConstList::make(1, 2, 3, 4, 5),
		[](const int& x, const int& y) {
			return x + y;
		},
		0
	)
}; // => 15
~~~
{: .language-cpp}

[Github]: https://github.com/KnairdA/ConstList/
[cgit]: http://code.kummerlaender.eu/ConstList/
