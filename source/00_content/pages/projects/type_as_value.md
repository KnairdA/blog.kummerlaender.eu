# TypeAsValue

…is a template metaprogramming library intended for compile time computation written in C++.

As its name implies it follows the overall concept of viewing types as values and templates as functions manipulating those values. This view on template metaprogramming lends itself quite well to a _Scheme_ like way of doing functional programming.

_TypeAsValue_ is currently primarily a reimplementation of my previous attempt at this problem: [ConstList]. As detailed in the appropriate [blog article] the mixed approach between generic lambda expressions, `constexpr` marked functions and template metaprogramming doesn't offer sufficient flexibility which led me to approach compile time computation in a slightly different manner via this new library.

Its MIT licensed source code is available on both [Github] and [cgit].

## Current features

* guaranteed evaluation during compile time
* basic math and logic operations
* conditionals
* `Cons` structure
* `List` function as helper for `Cons` construction
* basic list operators such as `Nth`, `Length`, `Take` and `Append`
* higher order list operation `Fold`
* higher order list operations such as `Map` and `Filter` expressed in terms of `Fold`
* higher order list queries such as `Any`, `All` and `None`
* list generators such as `Iota` and `ListTabulate`
* `static_assert` based test cases for all of the above

## Usage example

~~~
// λ (length (filter odd? (list 1 2 3)))
// 2

const std::size_t count = tav::Length<
	tav::Filter<
		tav::Odd,
		tav::List<tav::Int<1>, tav::Int<2>, tav::Int<3>>::type
	>::type
>::type::value;
~~~
{: .language-cpp}

[ConstList]: /page/const_list/
[blog article]: /article/a_look_at_compile_time_computation_in_cpp/
[Github]: https://github.com/KnairdA/TypeAsValue/
[cgit]: http://code.kummerlaender.eu/TypeAsValue/
