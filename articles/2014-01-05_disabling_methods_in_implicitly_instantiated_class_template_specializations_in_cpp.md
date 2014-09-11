# Disabling methods in implicitly instantiated class template specializations in C++

During my current undertaking of developing a [template based library](https://github.com/KnairdA/BinaryMapping) with the purpose of making it easy to map flat binary structures into `std::tuple` instances, I came upon the problem of enabling methods in a template class only when a argument of the class template equals a specific type.

The specific scenario I am talking about is disabling the _serialize_ and _deserialize_ template methods in all specializations of the
_[Tuple](https://github.com/KnairdA/BinaryMapping/blob/master/src/tuple/tuple.h)_ class template whose _Endianess_ argument is not of the type _UndefinedEndian_. My first working implementation of this requirement looks as follows:

~~~
template <
	typename CustomOrder,
	typename Helper = Endianess
>
inline typename std::enable_if<
	std::is_same<UndefinedEndian, Helper>::value,
	void
>::type serialize() {
	Serializer<InPlaceSorter<CustomOrder>>::serialize(this->tuple_);
}
~~~
{: .language-cpp}

As we can see I am relying on the standard libraries `std::enable_if` template to enable the method only if the _Helper_ template argument equals the type _UndefinedEndian_. One may wonder why I am supplying the `std::enable_if` template with the argument _Helper_ instead of directly specifying the class template argument _Endianess_. This was needed because of the following paragraph of the ISO C++ standard:

> The implicit instantiation of a class template specialization causes the implicit instantiation of the declarations, but not of the definitions or default arguments, of the class member functions, [...]  
> ([ISO C++ Standard draft, N3337](http://www.open-std.org/jtc1/sc22/wg21/), p. 346)

This paragraph means that as soon as we instantiate a class template specialization by actually using it all method declarations are also implicitly instantiated. This leads to a problem as soon as we are generating a invalid method declaration by disabling it, as the _Endianess_ class template argument is not seen as a variable template argument by the time we are declaring the _serialize_ or _deserialize_ methods. So if we want to use `std::enable_if` to disable a method specialization we need to make it dependent on a template argument of that method. This is why 
I defined a additional _Helper_ argument which defaults to the class template's _Endianess_ argument in the declaration of both methods.

The code supplied above works as expected but has at least two flaws: There is an additonal template argument whose sole purpose is to work around the C++ standard to make _[SFINAE](https://en.wikipedia.org/wiki/Substitution_failure_is_not_an_error)_ possible and the return type of the method is obfuscated by the use of the `std::enable_if` template.
Luckily it is not the only way of achieving our goal:

~~~
template <
	typename CustomOrder,
	typename = typename std::enable_if<
		std::is_same<UndefinedEndian, Endianess>::value,
		void
	>::type
>
inline void serialize() {
	Serializer<InPlaceSorter<CustomOrder>>::serialize(this->tuple_);
}
~~~
{: .language-cpp}

In this second example implementation we are moving the `std::enable_if` template from the return type into a unnamed default template argument of the method. This unnamed default
template argument which was not possible prior to the C++11 standard reduces the purpose of the `std::enable_if` template to selectively disabling method specializations. Additionally
the return type can be straight forwardly declared and the _Helper_ template argument was eliminated.

But during my research concerning this problem I came up with one additional way of achieving our goal which one could argue is even better than the second example:

~~~
template <typename CustomOrder>
inline void serialize() {
	static_assert(
		std::is_same<Endianess, UndefinedEndian>::value,
		"Endianess must be UndefinedEndian to use serialize<*>()"
	);

	Serializer<InPlaceSorter<CustomOrder>>::serialize(this->tuple_);
}
~~~
{: .language-cpp}

This implementation of the _serialize_ method renounces any additonal template arguments and instead uses a declaration called `static_assert` which makes any specializations where
the statement `std::is_same<Endianess, UndefinedEndian>::value` resolves to false ill-formed. Additionally it also returns a helpful message to the compiler log during such a situation.

While I finally [decided on](https://github.com/KnairdA/BinaryMapping/commit/ed85e10cf43767576141d94f2b86f3cc1eda9dfb) using the second approach detailed in this article in the library
because it feels better to me, the usage of `static_assert` makes it possible to generate better template error messages and I will certainly try to make use of this feature in the future.

__Update 1:__ The second listing currently only compiles in Clang 3.3 from the test set consisting of g++ 4.8.2 and Clang 3.3. While I believe the listing to be valid according to the standard I need to check if it is a bug in one of the compilers or if it is a situation where the standard doesn't clearly define what the compiler should do. I will update this article as soon as I come to a conclusion in this matter.

__Update 2:__ I found a corresponding [issue](http://gcc.gnu.org/bugzilla/show_bug.cgi?id=57314) in the GCC bug tracker. So this problem is actually a case where the C++ standard is not clearly defined and this also explains the difference in behaviour between Clang and g++. In the liked issue there is also a link to the corresponding core language [issue](http://www.open-std.org/jtc1/sc22/wg21/docs/cwg_active.html#1635). So it seems that I have to either wait for the standard committee to come to a solution or to use listing number three instead of the currently used implementation in my library. 
