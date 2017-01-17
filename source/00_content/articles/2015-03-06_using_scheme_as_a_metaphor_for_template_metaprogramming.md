# Using Scheme as a metaphor for template metaprogramming

Back in January I looked at compile time computation in C++ based on handling lists in a _functional fashion_ using a mixture between templates, generic lambda expressions and `constexpr` functions. The conclusion of the [appropriate article] was that the inherent restrictions of the approach taken in [ConstList], namely the missing guarantee on compile time evaluation, inability to make return types depend on actual values and lambda expressions being unable to be declared as constant make viewing types as values and templates as functions the superior approach. This article describes how this approach works out in practice.

While [ConstList] turned out to be of limited use in actually performing compile time computations, its list manipulation and query functionality was already inspired by how lists are handled in _LISP_ respectively its more minimalistic dialect _Scheme_, especially by the functionality described in the latter's [SRFI-1].  
When I started developing a new library porting this basic concept to the _type as value and templates as functions_ approach called [TypeAsValue] it quickly turned out that a _Scheme_ like paradigm maps quite well to template metaprogramming. This was initially very surprising as I did not expect that C++ templates would actually feel like a - admittedly rather verbose - functional programming language if used in a certain way.

```cpp
// (define sum
//         (fold +
//               0
//               (iota 5 2 2))) => 30
using sum = tav::Fold<
	tav::Add,
	tav::Int<0>,
	tav::Iota<
		tav::Size<5>,
		tav::Int<2>,
		tav::Int<2>
	>
>;
```

As we can see compile time computations expressed using this approach are more or less direct mappings of their _Scheme_ equivalent if we overlook the need to explicitly declare types, the different syntax used for defining bindings as well as its immutability.

While [TypeAsValue] started out as a direct reimplementation of my previous attempt I am happy to say that the conclusions drawn concerning the superiority of a stricly template metaprogramming based implementation held true and enabled the implementation of equivalents for large parts of the _Scheme_ list library. This includes actual content dependent list manipulations such as [`tav::Filter`], which were impossible to implement in [ConstList], in addition to e.g. a compile time implementation of _Quick Sort_.

## Types as values

The desire to express values in terms of types restricts the set of usable types to _integral types_ as only those types may be used as template parameters. According to the standard[^0] this includes all _integer types_ i.e. all non-floating-point types such as `bool`, `char` and `int`. In case of [TypeAsValue] all values are expressed as specializations of [`std::integral_constant`] wrapped in template aliases to simplify their declaration.

```cpp
using answer = tav::Int<42>;       // std::integral_constant<int, 42>
using letter = tav::Char<'A'>;     // std::integral_constant<char, 'A'>
using truth  = tav::Boolean<true>; // std::integral_constant<bool, true>
```

This need to explicitly declare all types because deduction during template resolution is not feasible marks one of the instances where the _Scheme metaphor_ does not hold true. Luckily this is not a bad thing as the goal is after all not to develop a exact replica of _Scheme_ in terms of template metaprogramming but to enable compile time computations in a _Scheme like_ fashion. In this context not disregarding the C++ type system is an advantage, especially since it should be possible to enable type deduction where required using a [`tav::Any`] like [`std::integral_constant`] constructor.

Obviously expressing single values as types is not enough, we also require at least an equivalent for _Scheme_'s fundamental pair type, on top of which more complex structures such as lists and trees may be built.

```cpp
template <
	typename CAR,
	typename CDR
>
struct Pair : detail::pair_tag {
	typedef CAR car;
	typedef CDR cdr;

	typedef Pair<CAR, CDR> type;
};
```

As we can see expressing a pair type in terms of a type template is very straight forward. Note that the recursive `type` definition will be discussed further in the next section on _templates as functions_. Each [`tav::Pair`] specialization derives from `detail::pair_tag` to simplify verification of values as pairs in `tav::IsPair`. The naming of the parameters as `CAR` and `CDR` is a reference to pair types being constructed using [`tav::Cons`] analogously to _Scheme_, where the pair `(1 . 2)` may be constructed using `(cons 1 2)`.

To summarize the type concept employed in [TypeAsValue] we can say that all actual values are stored in [`std::integral_constant`] specializations that enable extraction in a template context via their constant `value` member. Those types are then aggregated into structures using the [`tav::Pair`] template. This means that we can easily provide _functions_ to work on these _values_ in the form of type templates and their parameters as will be discussed in the following section.

## Templates as functions

```cpp
template <
	typename X,
	typename Y
>
using Multiply = std::integral_constant<
	decltype(X::value * Y::value),
	X::value * Y::value
>;
```

As we can see basic functionality such as a function respectively template to multiply a number by another is easily implemented in terms of an alias for a value type specialization, including automatic result type deduction using `decltype`. This also applies to higher order functionality which can be expressed only using other templates provided by the library such as the [`tav::Every`] list query.

```cpp
// (define (every predicate list)
//         (fold (lambda (x y) (and x y))
//               #t
//               (map predicate list)))
template <
	template<typename> class Predicate,
	typename                 List
>
using Every = Fold<
	And,
	Boolean<true>,
	Map<Predicate, List>
>;
```

If we ignore the need to explicitly declare the predicate as a _template template parameter_ i.e. as a function this example is very simmilar to its _Scheme_ equivalent. Concerning the function used to fold the list it is actually less verbose than the _Scheme_ version of [`tav::Every`] as we can directly pass [`tav::And`] instead of wrapping it in a lambda expression as is required in _Scheme_ [^1].

Sadly the actual implementations of e.g. [`tav::Fold`] are not as easily expressed. The recursive nature of folding a list or even constructing its underlying pair based structure using the variadic [`tav::List`] requires partial template specializations which are not allowed for template aliases[^2].

```cpp
template <
	template<typename, typename> class Function,
	typename                           Initial,
	typename                           Pair
>
struct fold_pair {
	typedef Function<
		Car<Pair>,
		Eval<fold_pair<Function, Initial, Cdr<Pair>>>
	> type;
};

template <
	template<typename, typename> class Function,
	typename                           Initial
>
struct fold_pair<Function, Initial, void> {
	typedef Initial type;
};
```

While the listing of `tav::detail::fold_pair` shows how the partial specialization of its [`tav::Pair`] parameter allows recursion until the list ends[^3], it also forces us to define its actual type in terms of a public `type` member `typedef`. Such a member type definition can lead to cluttering the code with `typename` keywords which is why [TypeAsValue] employs a simple [`tav::Eval`] template alias to hide all `typename *::type` constructs.

```cpp
template <
	template<typename, typename> class Function,
	typename                           Initial,
	typename                           List
>
using Fold = Eval<detail::fold_pair<Function, Initial, List>>;
```

Hiding member type defintions behind template aliases enables most _higher_ functionality and applications built using its functions to be written in a reasonably minimalistic - _Scheme_ like - fashion as we can see in e.g. the listing of [`tav::Every`]. This also explains why [`tav::Pair`] recursively defines its own type, as we would otherwise have to be quite careful where to resolve it.

### Bindings

Not all programs are sensibly expressed as a nested chain of function calls if we want to reuse some values, separate functionality into appropriately named functions or hide complexity via private bindings. While in _Scheme_ one would use `let` and the like for this purpose, such functionality is not easily replicated in the context of template metaprogramming. This is why [TypeAsValue] uses an alternate and more _C++ like_ solution to this problem by simply making use of the standard object oriented aspects of the language.

```cpp
// (define (quick_sort comparator sequence)
//   (if (null-list? sequence)
//     (list)
//     (let* ([index      (quotient (length sequence) 2)]
//            [pivot      (nth index sequence)]
//            [partitions (partition (lambda (x) (comparator pivot x))
//                                   (delete-nth index sequence))]
//            [lhs        (car partitions)]
//            [rhs        (cdr partitions)])
//       (concatenate (list (quick_sort comparator lhs)
//                          (list pivot)
//                          (quick_sort comparator rhs))))))
template <
	template<typename, typename> class Comparator,
	typename                           Sequence
>
class quick_sort {
	private:
		using index = Divide<Length<Sequence>, Size<2>>;
		using pivot = Nth<index, Sequence>;

		using partitions = Partition<
			Apply<Comparator, pivot, _0>::template function,
			DeleteNth<index, Sequence>
		>;

		using lhs = Car<partitions>;
		using rhs = Cdr<partitions>;

	public:
		using type = Concatenate<
			Eval<quick_sort<Comparator, lhs>>,
			List<pivot>,
			Eval<quick_sort<Comparator, rhs>>
		>;
};

template <template<typename, typename> class Comparator>
struct quick_sort<Comparator, void> {
	typedef void type;
};
```

Above we can see the complete listing of the _Quick Sort_ implementation employed by the [`tav::Sort`] template alias. At first glance this looks rather different from the corresponding _Scheme_ program but if we look closer one could argue that it is a equivalent of a `let` binding where the _private_ section of `tav::detail::quick_sort` contains the bound constants and the _public_ section contains the body.

### Partial function application

While partial application of the `comparator` function in the _Scheme_ _Quick Sort_ implementation is achieved via anonymous functions I have not as of yet thought of a good way to implement full support for lambda expressions in [TypeAsValue]. This is why there is currently only support for _single level_ partial function evaluation using [`tav::Apply`].

To put it simply [`tav::Apply`] implements a [`std::bind`] analog for usage in a template metaprogramming context. This means that it _returns_ a new template for a given template including all its arguments where some or all of those arguments may be placeholders. In this context a placeholder is a specialization of the [`tav::detail::placeholder`] template on an arbitrary integer value that represents the index of the argument to the _returned_ template the placeholder should resolve to.

```cpp
// (define result
//         (map (lambda (x) (+ 2 x))
//              (list 1 2 3)))
// => (list 3 4 5)
using result = tav::Map<
	tav::Apply<tav::Add, tav::Int<2>, tav::_0>::template function,
	tav::List<tav::Int<1>, tav::Int<2>, tav::Int<3>>
>;
```

Note that `tav::_0` is just an alias to `tav::detail::placeholder<0>`. The [`tav::Apply`] template automatically selects a matching implementation as its base class depending on the count of placeholder arguments using [`tav::Cond`]. If there are more than two placeholder arguments it _returns_ a generic variadic template as its `function` alias whereas there is a explicit version for one, two or zero placeholders. The zero placeholder variant of [`tav::Apply`] is useful if function application has to be deferred as is required for e.g. the handling of invalid values.

As we can see this kind of partial function application obviously is no full replacement for actual template based lambda expressions but it serves as a _good enough_ solution until a nice approach to enabling placeholders as arguments in nested templates can be developed. Alternatively one could argue that the scenarios where one could use lambda expressions are better served by defining local templates and bindings as described in the previous section to e.g. increase readability by actually naming functions.

## Examples

While the above listings and explanations should provide a basic overview about what I mean by using _Scheme_ as a metaphor for template metaprogramming, some actual examples of how [TypeAsValue] may be used to perform some concrete compile time computations are certainly useful.

For this reason the library includes two [example applications], namely a implementation of the _Sieve of Eratosthenes_ and a _Turing machine_ [^4] simulator. To further support the analogy between functional and template metaprogramming both of these examples as well as all test cases are documented using their respective _Scheme_ equivalent.

Both of these examples are certainly not what [TypeAsValue] might be used for in practice. I imagine the most viable real word use case for template metaprogramming based compile time computation to be the implementation of complex template based abstractions. For example it could serve as a utility to express base class selections and complex assertions of static parameters in a easily readable and hopefully relatable manner.

## Summary

While the _Scheme_ metaphor for template metaprogramming in C++ certainly has its limits, especially in the area of anonymous functions, I think that this article as well as the actual implementation of [TypeAsValue] are proof that it holds up quite well in many circumstances. As stated in the introduction to this article I was very surprised how close template metaprogramming can feel to a _real_ functional programming language.

All listings in this article as well as the [TypeAsValue] library itself are freely available under the terms of the MIT license on [Github] and [cgit]. Feel free to check them out and contribute - I am especially interested in practical solutions to providing better partial function application support or even full compile time lambda expressions that do not require the whole library to be designed around this concept.

Finally I want to reference the [Boost MPL] library which supports everything and more than the solution described in this article without relying on any _modern_ language features such as variadic templates. All _non-experimental_ projects should probably use it instead of [TypeAsValue], not the least because of greater portability.

[^0]: ISO C++ Standard draft, N3797, § 3.9.1 _Fundamental types_, Section 7
[^1]: `and` needs to be wrapped in anonymous function in _Scheme_ because it is not a function but a macro
[^2]: ISO C++ Standard draft, N3797, § 14.5 _Template declarations_, Section 3
[^3]: _TypeAsValue_ currently represents _Scheme_'s empty list `'()` as `void`
[^4]: Previously proofed in [C++ Templates are Turing Complete](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.14.3670) _(2003)_

[appropriate article]: /article/a_look_at_compile_time_computation_in_cpp/
[ConstList]: /page/const_list/
[TypeAsValue]: /page/type_as_value/
[SRFI-1]: http://srfi.schemers.org/srfi-1/srfi-1.html
[example applications]: https://github.com/KnairdA/TypeAsValue/tree/master/example
[Boost MPL]: http://www.boost.org/doc/libs/1_57_0/libs/mpl/doc/index.html
[Github]: https://github.com/KnairdA/TypeAsValue/
[cgit]: http://code.kummerlaender.eu/TypeAsValue/

[`std::integral_constant`]: http://en.cppreference.com/w/cpp/types/integral_constant
[`std::bind`]: http://en.cppreference.com/w/cpp/utility/functional/bind
[`tav::Filter`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/list/operation/higher/filter.h
[`tav::Any`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/list/operation/higher/query.h
[`tav::Every`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/list/operation/higher/query.h
[`tav::Fold`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/list/operation/higher/fold.h
[`tav::Sort`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/list/operation/higher/sort.h
[`tav::Apply`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/function/apply.h
[`tav::detail::placeholder`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/function/detail/placeholder.h
[`tav::And`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/operation/logic.h
[`tav::Eval`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/type.h
[`tav::Pair`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/pair.h
[`tav::Cons`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/list/cons.h
[`tav::List`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/list/list.h
[`tav::Cond`]: https://github.com/KnairdA/TypeAsValue/blob/299781bccc5c7d1b212198b5a9a55ee9447603c5/src/conditional/cond.h
