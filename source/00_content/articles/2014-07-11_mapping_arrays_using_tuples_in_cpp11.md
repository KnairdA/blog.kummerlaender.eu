# Mapping arrays using tuples in C++11

During my proof-of-concept implementation of external functions enabling [XSLT based static site generation](https://github.com/KnairdA/InputXSLT) I came upon the problem of calling a template method specialized on the Nth type of a `std::tuple` specialization using the Nth element of a array-like type instance as input. This was needed to implement a generic template-based interface for implementing [Apache Xalan](http://xalan.apache.org/xalan-c/index.html) external functions. This article aims to explain the particular approach taken to solve this problem.

While it is possible to unpack a `std::tuple` instance into individual predefined objects using `std::tie` the standard library offers no such helper template for `unpacking` an array into individual objects and calling appropriate casting methods defined by a `std::tuple` mapping type. Sadly exactly this functionality is needed so that we are able to call a `constructDocument` member method of a class derived from the [`FunctionBase`](https://github.com/KnairdA/InputXSLT/blob/master/src/function/base.h) external function interface template class using static polymorphism provided through the [curiously recurring template pattern](https://en.wikipedia.org/wiki/Curiously_Recurring_Template_Pattern). This interface template accepts the desired external function arguments as variadic template types and aims to provide the required validation and conversion boilerplate implementation. While we could recursively generate a `std::tuple` specialization instance from an array-like type using a approach simmilar to the one detailed in my article on [mapping binary structures as tuples using template metaprogramming](/article/mapping_binary_structures_as_tuples_using_template_metaprogramming) this wouldn't solve the problem of passing on the resulting values as individual objects. This is why I had to take the new approach of directly calling a template method on individual array elements using a `std::tuple` specialization as a kind of blueprint and passing the result values of this method to the `constructDocument` method as separate arguments.

Extracting array elements obviously requires some way of defining the appropriate indexes and mapping the elements using a tuple blueprint additionally requires this way to be statically resolvable as one can not pass a dynamic index value to `std::tuple_element`. So the first step to fullfilling the defined requirements involved the implementation of a template based index or sequence type.

~~~
template <std::size_t...>
struct Sequence {
	typedef Sequence type;
};

template <
	std::size_t Size,
	std::size_t Index = 0,
	std::size_t... Current
>
struct IndexSequence {
	typedef typename std::conditional<
		Index < Size,
		IndexSequence<Size, Index + 1, Current..., Index>,
		Sequence<Current...>
	>::type::type type;
};
~~~
{: .language-cpp}

This is achieved by the [`IndexSequence` template](https://github.com/KnairdA/InputXSLT/blob/49e2010b489ab6d5516a9abd896c67738e0dc1cc/src/support/type/sequence.h) above by recursively specializing the `Sequence` template using static recursion controlled by the standard libraries template metaprogramming utility template `std::conditional`. This means that e.g. the type `Sequence<0, 1, 2, 3>` can also be defined as `IndexSequence<4>::type`.

Now all that is required to accomplish the goal is instantiating the sequence type and passing it to a variadic member template as [follows](https://github.com/KnairdA/InputXSLT/blob/master/src/function/base.h):

~~~
[...]
this->callConstructDocument(
	parameters,
	locator,
	typename IndexSequence<parameter_count>::type()
)
[...]
template <std::size_t... Index>
inline xalan::XalanDocument* callConstructDocument(
	const XObjectArgVectorType& parameters,
	const xalan::Locator* locator,
	Sequence<Index...>
) const {
	[...]
	return this->document_cache_->create(
		static_cast<const Implementation*>(this)->constructDocument(
			valueGetter.get<typename std::tuple_element<
				Index,
				std::tuple<Types...>
			>::type>(parameters[Index])...
		)
	);
}
~~~
{: .language-cpp}

As we can see a `IndexSequence` template specialization instance is passed to the variadic `callConstructDocument` method to expose the actual sequence values as `Index`. This method then resolves the `Index` parameter pack as both the array and `std::tuple` index inside the calls to the `valueGetter.get` template method which is called for every sequence element because of this. What this means is that we are now able to implement non-template `constructDocument` methods inside XSLT external function implementations such as [FunctionTransform](https://github.com/KnairdA/InputXSLT/blob/master/src/function/transform.h). The values passed to these methods are automatically extracted from the argument array and converted into their respective types as required.

While this article only provided a short overview of mapping arrays using tuples in C++11 one may view the full implementation on [Github](https://github.com/KnairdA/InputXSLT/blob/master/src/function/base.h) or [cgit](http://code.kummerlaender.eu/InputXSLT/tree/src/function/base.h).

**Update:** The recently passed C++14 standard adds a [`std::integer_sequence`](http://en.cppreference.com/w/cpp/utility/integer_sequence) template to the standard library which covers the same use case as the custom `Sequence`  and `IndexSequence` templates detailed in this article. `FunctionBase` was already [modified](https://github.com/KnairdA/InputXSLT/commit/b9d62d5ce1e3f92a8ab34239c6e4044ad57180df) accordingly as one should obviously rely on the standard's version of a integer sequence in the future.
