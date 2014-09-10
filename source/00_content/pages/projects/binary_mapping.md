# BinaryMapping

…is a collection of C++ templates which may be used to map binary structures into tuples and various other structures.

These structures can then be traversed using integrated containers and iterators. This is useful for many kinds of data serialization tasks.

A explanation of an earlier version of this template library can be found on this [blog]. The source code is available via both [Github] and [cgit].

## Current features

* Support for any kind of flat structure that can be expressed using integral types and arbitrarily sized byte-arrays
* Support for serialization in either big or little endianess
* Offers Container and Iterator templates for fast traversal of collections of tuples or other structures
* Support for developing custom types to be used in the Container and Iterator templates
* Support for nesting structures inside each other
* BitField template offers bit-level access to ByteField byte-arrays
* Doesn't require any external libraries besides the GNU libraries `endian.h`
* Header only library because of heavy usage of template metaprogramming
* Unit Tests based on GoogleTest
* MIT license

[blog]: /article/mapping-binary-structures-as-tuples-using-template-metaprogramming
[Github]: https://github.com/KnairdA/BinaryMapping
[cgit]: http://code.kummerlaender.eu/BinaryMapping/
