# Mapping binary structures as tuples using template metaprogramming

My current programming related interests are centered mainly around low level data storage and querying techniques - i.e. implementing my own database.
The first step in this direction was a graph storage library based on Google [LevelDB](https://code.google.com/p/leveldb/). While the resulting prototype [libGraphStorage](https://github.com/KnairdA/GraphStorage/)
performs fairly well it just doesn't fulfill all my expectations concerning performance and storage requirements. Additionally the decision of building a graph storage on top of
a key value store proofed to be too limiting as my mental image of the kind of system I wanted to develop changed over time. While I now have a clearer plan about what I want to 
build I am also back to square one of actually implementing anything. As I chose to abandon the concept of building higher level data structures on top of existing key-value store
libraries in favor of building everything from the system calls up by myself, I am now faced among other things with implementing nice abstractions around mapping raw binary data
into various structures.

For the purpose of this article I am going to limit myself to flat structures with fixed length fields. The result I am aiming for is a template which enables me to
write mappings like [EdgeId](https://github.com/KnairdA/GraphStorage/blob/master/src/storage/id/edge_id.cc) in a more compact and efficient way. This also includes support for handling
differences in endianness and In-place modification of the structure fields. 

## Mapping buffers as tuples

To be able to easily work with structure definitions using template metaprogramming I am relying on the standard libraries [_std::tuple_](http://en.cppreference.com/w/cpp/utility/tuple)
template.

~~~
template<typename Tuple>
class BinaryMapping {
	public:
		BinaryMapping(uint8_t* const buffer):
			buffer_(buffer) {
			TupleReader::read(this->tuple_, buffer);
		}

		template <size_t Index>
		decltype(*std::get<Index>(Tuple{})) get() {
			return *std::get<Index>(this->tuple_);
		}

		template <size_t Index,
				  typename Value = decltype(*std::get<Index>(Tuple{}))>
		void set(const Value value) {
			*std::get<Index>(this->tuple_) = value;
		}

	private:
		uint8_t* const buffer_;
		Tuple tuple_;

};
~~~
{: .language-cpp}

This implementation of a template class _BinaryMapping_ provides _get_ and _set_ template methods for accessing values in a given binary buffer using the mapping provided by a given
Tuple template argument. The most notable element of this class is the usage of the _decltype_ keyword which was introduced in C++11. This keyword makes it easier to declare types 
dependent on template arguments or other types that are difficult to declare using the standard notations. This is possible because _decltype_ exposes the return type of an expression
during the compilation phase. So the expression `decltype(*std::get<Index>(Tuple{}))` is replaced with the return type of the expression `*std::get<Index>(Tuple{})` during template
instantiation. As the return type of this expression is dependent on the template arguments _Index_ and _Tuple_ the return type of the template method which is using a _decltype_ expression
as its return type is also dependent on the template arguments.

As you may have noticed the above template class is not complete as I have not included a implementation of the _TupleReader::read_ method which does the actual work of mapping the binary 
buffer as a tuple. This mapping is achieved by the following recursive template methods:

~~~
struct TupleReader {
	template <typename Tuple, size_t Index = 0, off_t Offset = 0>
	static inline typename std::enable_if<
		Index == std::tuple_size<Tuple>::value, void
	>::type read(Tuple&, uint8_t*) { }

	template <typename Tuple, size_t Index = 0, off_t Offset = 0>
	static inline typename std::enable_if<
		Index < std::tuple_size<Tuple>::value, void
	>::type read(Tuple& tuple, uint8_t* buffer) {
		std::get<Index>(tuple) = reinterpret_cast<
			typename std::tuple_element<Index, Tuple>::type
		>(buffer+Offset);

		read<Tuple,
		     Index  + 1,
		     Offset + sizeof(decltype(*std::get<Index>(Tuple{})))>(
			tuple, buffer
		);
	}
};
~~~
{: .language-cpp}

Template metaprogramming in C++ offers a Turing-complete language which is fully executed during compilation. This means that any problem we may solve during the runtime of a _normal_ program
may also be solved during compilation using template metaprogramming techniques. This kind of programming is comparable to functional programming as we have to rely on recursion and pattern
matching.  
The above coding contains two overloads of the _read_ method. The first is our exit condition which stops the recursion as soon as we have processed every tuple element. The second one matches
every element of a given tuple and sets the pointer of each element to the matching position in the binary buffer. To make this work I use the following four standard library templates:

[_std::enable\_if_](http://en.cppreference.com/w/cpp/types/enable_if) makes it possible to exclude template instantiations from overload resolution based on a condition passed as a template
argument. The condition has to be a statically resolvable boolean expression, the second argument of the template is the type to be returned when the condition resolves to a true value.
_TupleReader_ uses this template to match the recursive version of the _read_ method to any _Index_ value below the tuple element count and the empty version to the case where the _Index_
argument equals the tuple element count. This equals an escape condition for the recursion started by the second overload of the _read_ method as it increases the _Index_ on each call.

[_std::get_](http://en.cppreference.com/w/cpp/utility/tuple/get) returns a reference to the Nth element of the given tuple as specified by the corresponding template argument. 
The methods in _TupleReader_ use this template to set the pointer on each element to the appropriate buffer offset.

[_std::tuple\_size_](http://en.cppreference.com/w/cpp/utility/tuple/tuple_size) returns the number of elements in the _std::tuple_ instantiation passed as the template argument. This value is
used as a reference value to compare the current recursion index to.

[_std::tuple\_element_](http://en.cppreference.com/w/cpp/utility/tuple/tuple_element) returns the type of the Nth element of a given _std::tuple_ instantiation as specified by the template
argument. I use this template to get the type to which the current buffer offset has to be cast to match the pointer of the corresponding tuple element.

While the _Index_ argument of the _read_ template method is increased by one, the _Offset_ value is increased by the size of the current tuple element type so the current total buffer offset
is always available as a template argument.

The classes _TupleReader_ and _BinaryMapping_ are enough to map a binary structure as a _std::tuple_ instantiation like in the following example where I define a _TestRecord_ tuple containing
a pointer to _uint64\_t_ and _uint16\_t_ integers:

~~~
typedef std::tuple<uint64_t*, uint16_t*> TestRecord;

uint8_t* buffer = reinterpret_cast<uint8_t*>(
	std::calloc(10, sizeof(uint8_t))
);

BinaryMapping<TestRecord> mapping(buffer);

mapping.set<0>(42);
mapping.set<1>(1337);

std::cout << mapping.get<0>() << std::endl;
std::cout << mapping.get<1>() << std::endl;
~~~
{: .language-cpp}

## Endianness

As you may remember this does not take endianness into account as I defined as a requirement in the beginning. I first thought about including support for different endianness types into the
_BinaryMapping_ template class which worked, but led to problems as soon as I mixed calls to _get_ and _set_. The resulting problems could of course have been fixed but this would probably
have conflicted with In-place modifications of the buffer. Because of that I chose to implement endianness support in a separate set of templates.

~~~
struct BigEndianSorter {
	template <class Key>
	static void write(uint8_t*, const Key&);

	template <typename Key>
	static Key read(uint8_t* buffer);
};
~~~
{: .language-cpp}

To be able to work with different byte orderings I abstracted the basic operations down to _read_ and _write_ template methods contained in a _struct_ so I would be able to provide separate
implementations of these methods for each type of endianness. The following template specialization of the _write_ method which does an In-place reordering of a _uint64\_t_ should be enough
to understand the basic principle:

~~~
template <>
void BigEndianSorter::write<uint64_t>(uint8_t* buffer, const uint64_t& number) {
	*reinterpret_cast<uint64_t*>(buffer) = htobe64(number);
}
~~~
{: .language-cpp}

As soon as I had the basic endianness conversion methods implemented in a manner which could be used to specialize other template classes I was able to build a generic implementation of a
serializer which respects the structure defined by a given _std::tuple_ instantiation:

~~~
template <class ByteSorter>
struct Serializer {
	template <typename Tuple, size_t Index = 0, off_t Offset = 0>
	static inline typename std::enable_if<
		Index == std::tuple_size<Tuple>::value, void
	>::type serialize(uint8_t*) { }

	template <typename Tuple, size_t Index = 0, off_t Offset = 0>
	static inline typename std::enable_if<
		Index < std::tuple_size<Tuple>::value, void
	>::type serialize(uint8_t* buffer) { 
		ByteSorter::template write<typename std::remove_reference<
			decltype(*std::get<Index>(Tuple{}))
		>::type>(
			buffer+Offset,
			*reinterpret_cast<typename std::tuple_element<Index, Tuple>::type>(
				buffer+Offset
			)
		);

		serialize<Tuple,
		          Index  + 1,
		          Offset + sizeof(decltype(*std::get<Index>(Tuple{})))>(
			buffer
		);
	}

	template <typename Tuple, size_t Index = 0, off_t Offset = 0>
	static inline typename std::enable_if<
		Index == std::tuple_size<Tuple>::value, void
	>::type deserialize(uint8_t*) { }

	template <typename Tuple, size_t Index = 0, off_t Offset = 0>
	static inline typename std::enable_if<
		Index < std::tuple_size<Tuple>::value, void
	>::type deserialize(uint8_t* buffer) { 
		*reinterpret_cast<typename std::tuple_element<Index, Tuple>::type>(
			buffer+Offset
		) = *ByteSorter::template read<
			typename std::tuple_element<Index, Tuple>::type
		>(buffer+Offset);

		deserialize<Tuple,
		            Index  + 1,
		            Offset + sizeof(decltype(*std::get<Index>(Tuple{})))>(
			buffer
		);
	}
};
~~~
{: .language-cpp}

It should be evident that the way both the _serialize_ and _deserialize_ template methods are implemented is very similar to the _TupleReader_ implementation. In fact the only difference
is that no actual _std::tuple_ instantiation instance is touched and instead of setting pointers to the buffer we are only reordering the bytes of each section of the buffer corresponding to
a tuple element. This results in a complete In-place conversion between different byte orderings using the methods provided by a _ByteSorter_ template such as _BigEndianSorter_.

## Conclusion

At last I am now able to do everything I planned in the beginning in a very compact way using the _Serializer_, _TupleReader_ and _BinaryMapping_ templates. In practice this now looks like this:

~~~
typedef std::tuple<uint64_t*, uint16_t*> TestRecord;

uint8_t* buffer = reinterpret_cast<uint8_t*>(
	std::calloc(10, sizeof(uint8_t))
);

BinaryMapping<TestRecord> mapping(buffer);

mapping.set<0>(42);
mapping.set<1>(1001);

Serializer<BigEndianSorter>::serialize<TestRecord>(buffer);

uint8_t* testBuffer = reinterpret_cast<uint8_t*>(
	std::calloc(10, sizeof(uint8_t))
);

std::memcpy(testBuffer, buffer, 10);

Serializer<BigEndianSorter>::deserialize<TestRecord>(testBuffer);

BinaryMapping<TestRecord> testMapping(testBuffer);

std::cout << testMapping.get<0>() << std::endl;
std::cout << testMapping.get<1>() << std::endl;

std::free(buffer);
std::free(testBuffer);
~~~
{: .language-cpp}

The above coding makes use of all features provided by the described templates by first setting two values using _BinaryMapping_ specialized on the _TestRecord_ tuple, serializing them using
_Serializer_ specialized on the _BigEndianSorter_, deserializing the buffer back to the host byte ordering and reading the values using another _BinaryMapping_.

I find the template metaprogramming based approach to mapping binary structures into tuples described in this article to be very nice and clear. While template metaprogramming takes a while to
get into it is a very powerful method for describing code in a generic way. I would certainly not recommend to try and fit everything in a template based approach but in some cases - especially
when one would otherwise be required to write lots of boilerplate code repeatedly - it just fits and works out rather nicely. The best example for this would probably be the standard library
which basically is _just_ a large library of templates.  
The next step in extending the templates explained in this article would probably be adapting the _BinaryMapping_ template to offer sliding window like iteration over larger buffers and extending
the supported data types.

__Update:__ The current version of a small C++ template library extending the _BinaryMapping_ templates detailed in this article may be found on [Github](https://github.com/KnairdA/BinaryMapping/) or [cgit](http://code.kummerlaender.eu/BinaryMapping/).
