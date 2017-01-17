# CodepointIterator

…is a `std::iterator` derived class implementing the `std::bidirectional_iterator_tag` which iterates through unicode codepoints in a UTF8-encoded string.

The source code is available on both my [Github] profile and [cgit].

For readers versed in German a [blog article] describing the implementation in a more detailed manner is available.

## Current features

* Bidirectional iteration through unicode codepoints
* The class itself does not rely on any external libraries
* Dereferencing an instance of the iterator yields the codepoint as `char32_t`
* Unit Tests based on GoogleTest

## Usage example

While all features of this class are demonstrated by Google-Test based [Unit-Tests] we can see a basic `UTF8::CodepointIterator` usage example in the following code snippet. The [example text] is written in Old Norse runes.


```cpp
std::string test(u8"ᛖᚴ ᚷᛖᛏ ᛖᛏᛁ ᚧ ᚷᛚᛖᚱ ᛘᚾ ᚦᛖᛋᛋ ᚨᚧ ᚡᛖ ᚱᚧᚨ ᛋᚨᚱ");

for ( UTF8::CodepointIterator iter(test.cbegin());
	  iter != test.cend();
	  ++iter ) {
	std::wcout << static_cast<wchar_t>(*iter);
}
```

[Github]: https://github.com/KnairdA/CodepointIterator
[cgit]: http://code.kummerlaender.eu/CodepointIterator/
[Unit-Tests]: https://github.com/KnairdA/CodepointIterator/blob/master/test.cc
[example text]: http://www.columbia.edu/~fdc/utf8/
[blog article]: /article/notizen_zu_cpp_und_unicode
