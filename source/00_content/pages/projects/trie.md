# Trie

…is a basic template based implementation of a prefix tree data structure.

The implementation may be found on [Github] or [cgit].

A prefix tree or _Trie_ is a data structure that can be used to store a dynamic set in a manner optimized for retrieving all keys with a specific prefix. While those keys are often plain character strings this template based implementation of the prefix tree data structure allows for usage with different types.

## Current features

* Specializable tree element type
* Adding, removing and resolving paths in the prefix tree
* Builds on the standard library
* Unit tests based on GoogleTest

## Usage example

The following example demonstrates the usage of the `Trie` class template specialized on a key and value type. While the first is obviously required the second may be ommitted if not required. Further usage examples are available as Google-Test based [test cases].

~~~
Trie<uint8_t, uint8_t> trie;

trie.add({1, 1, 1, 1}, 42);
trie.add({1, 2, 1, 2}, 43);
trie.add({2, 3, 4, 5}, 44);
trie.add({2, 3, 1, 2}, 45);

std::cout << trie.get({1, 1, 1, 1})       << std::endl; // true
std::cout << trie.get({1, 1, 1, 1}).get() << std::endl; // 42
std::cout << trie.get({1, 2})             << std::endl; // false
~~~
{: .language-cpp}

[Github]: https://github.com/KnairdA/Trie 
[cgit]: http://code.kummerlaender.eu/Trie/
[test cases]: https://github.com/KnairdA/Trie/blob/master/test.cc
