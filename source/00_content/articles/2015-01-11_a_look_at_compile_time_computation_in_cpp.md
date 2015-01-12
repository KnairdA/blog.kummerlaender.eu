# A look at compile time computation in C++

The C++ language landscape may be pretty old by now but that doesn't mean that its continental plates have ceased their movement and no new and exciting things happen anymore. To the contrary the recently approved _C++14_ standard continues in the footsteps of _C++11_ by continuing to modernize and empower the language by e.g. introducing _generic lambda expressions_ and relaxing the restrictions on the `constexpr` keyword introduced by _C++11_ back in 2011. Especially the last improvement caused me to think about how one could use the new language features to perform compile time computation in a fashion actually applicable in practice. This is what I want to talk about in this article.

Besides C-style macros C++ templates present one additional language element that is guaranteed by the standard to be executed at compile time. In this context the [proof] that this template system is Turing complete manages to both illustrate its power and demonstrate its bewildering complexity. As it is pretty unrealistic that one would implement _common application logic_ in terms of a Turing machine just to achieve compile time computation, a easier way of expressing _compile time programs_ has to be found.

## Spectroscopy of `constexpr`

## Compile time list processing

My first attempt at facilitating compile time computation is a _functional-style_ list library based on template metaprogramming: [ConstList]. This library handles lists in a fashion simmilar to how it is done in languages such as Scheme or Haskell, i.e. by providing functions such as `fold` and `map` which manipulate a basic list type based on _Cons_ expressions. As an example one may consider how ConstList's `map` function is expressed in terms of `foldr`:

~~~
template <
	typename Cons,
	typename Function
>
constexpr auto map(const Cons& cons, const Function& function) {
	return foldr(
		cons,
		[&function](auto car, auto cdr) {
			return concatenate(make(function(car)), cdr);
		},
		make()
	);
}
~~~
{: .language-cpp}

The `foldr` implementation is also quite straightforward and simply applies a given function to each pair of the _Cons_ structure using static recursion. Note that this approach of _lambda expression based_ template metaprogramming would have been much more verbose in C++11 as many list manipulators such as `map` and `foldr` make use of C++14's _generic lambda expressions_. While the [test cases] provide a set of - in my opinion - reasonably nice list transformations and queries they also present the core problem of the particular approach taken in ConstList, as it is impossible to return lists of varying lengths depending on their contents. This pervasive limitation exists because the only way to vary types at compile time depending on values is to use these values as template parameters. That is the _Cons_ list type tree would have to be both list declaration and definition, analogously to e.g. `std::integral_constant`. Obviously this is quite different from how types and values were separated into templates and member constants in ConstList. One would have to think of types as values and templates as functions that modify those values instead.

To summarize: The approach taken in my implementation of ConstList may be a nice exercise in template metaprogramming and writing functional style C++ code but its practical applications in compile time computation are unreasonably narrow.

## Types as values…

…and templates as functions.

[proof]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.14.3670
[ConstList]: /page/const_list/
[test cases]: https://github.com/KnairdA/ConstList/blob/master/test.cc
