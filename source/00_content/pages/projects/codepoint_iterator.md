# CodepointIterator

…is a `std::iterator` derived class implementing the `std::bidirectional_iterator_tag` which iterates through unicode codepoints in a UTF8-encoded string.

The source code is available on both my [Github] profile and [cgit].

## Current features

* Bidirectional iteration through unicode codepoints
* The class itself does not rely on any external libraries
* Dereferencing an instance of the iterator yields the codepoint as `char32_t`
* Unit Tests based on GoogleTest

[Github]: https://github.com/KnairdA/CodepointIterator
[cgit]: http://code.kummerlaender.eu/CodepointIterator/
