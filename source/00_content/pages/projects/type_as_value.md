# TypeAsValue

…is a template metaprogramming library intended for compile time computation written in C++.

As its name implies it follows the overall concept of viewing types as values and templates as functions manipulating those values.

This library is a expanded reimplementation of my previous attempt at this problem: [ConstList]. As detailed in the appropriate [blog article] the mixed approach between generic lambda expressions, `constexpr` marked functions and template metaprogramming doesn't offer sufficient flexibility which led me to approach compile time computation in a slightly different manner via this new library. As one might notice this boils down to using _Scheme_ as a metaphor for C++ template metaprogramming. In fact all [test cases] and [examples] are documented by representing their logic in _Scheme_.

Its MIT licensed source code is available on both [Github] and [cgit].

Furthermore an overview of this library alongside some background information is available in the form of a blog article on [using _Scheme_ as a metaphor for template metaprogramming].

## Current features

* guaranteed evaluation during compile time
* basic math and logic operations
* conditionals such as `If` and `Cond`
* `Cons` constructor for `Pair` type
* `List` function as helper for `Pair` based list construction
* basic list operators such as `Nth`, `Length`, `Take` and `Append`
* list generators such as `Iota` and `MakeList`
* higher order list operation `Fold`
* higher order list operations such as `Map` and `Filter` expressed in terms of `Fold`
* higher order list queries such as `Find`, `Any`, `All` and `None`
* higher order list generators such as `ListTabulate`
* higher order list operations such as `TakeWhile`, `Partition` and `Sort`
* basic partial function application support using `Apply`
* `static_assert` based test cases for all of the above
* MIT license

## Usage example

```cpp
// λ (length (filter odd? (list 1 2 3)))
// 2

const std::size_t count = tav::Length<
    tav::Filter<
        tav::Odd,
        tav::List<tav::Int<1>, tav::Int<2>, tav::Int<3>>
    >
>::value;
```

More extensive [examples] are available in the form of implementations of the _Sieve of Eratosthenes_ as well as of a _Turing machine_.

[ConstList]: /page/const_list/
[blog article]: /article/a_look_at_compile_time_computation_in_cpp/
[using _Scheme_ as a metaphor for template metaprogramming]: /article/using_scheme_as_a_metaphor_for_template_metaprogramming/
[Github]: https://github.com/KnairdA/TypeAsValue/
[cgit]: http://code.kummerlaender.eu/TypeAsValue/
[test cases]: https://github.com/KnairdA/TypeAsValue/blob/master/test.cc
[examples]: https://github.com/KnairdA/TypeAsValue/blob/master/example/
