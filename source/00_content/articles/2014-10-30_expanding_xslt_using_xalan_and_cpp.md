# Expanding XSLT using Xalan and C++

As you may have noticed I spent the last couple of months developing a [static site generation framework] in XSLT which is now used to generate [this website]. This was only possible in pure XSLT by first implementing a [set of external functions] making functionality such as calling nested transformations, filesystem access and external process spawning available from inside XSLT. I want to use this article to explain how I implemented those functions in C++ using [Apache Xalan] as a foundation.

[Apache Xalan] is a [Xerces] based open source XSLT processor available as both a Java and C++ version. While the former offers more features[^1] I chose the latter as I wanted to implement the required functionality in C++ both to improve my knowledge of this language and because I enjoy developing in it more than I do in Java. This meant that the additional functionality had to be implemented in terms of external functions called from within XPath expressions instead of additional XSLT elements. While I did not like this limitation at first it turned out to be quite workable as most times the external function calls are wrapped within helper templates anyway.

Luckily the Xalan developers anticipated the need for implementing custom functionality on top of their XSLT processor and provided both a [`xalan::Function`] interface class and corresponding methods for embedding implementations of this interface into the [`xalan::XalanTransformer`] class. Basic usage of this interface is [documented] quite well but basic usage apparently does not include returning completely new node trees. It seems that while the interface is perfectly sufficient for returning calculation and query results it simply was not designed with returning arbitrary node trees in mind.

Note that I did not find any real documentation on how to return arbitrary node trees from external functions in Xalan and as such had to rely on extrapolating from offhand comments on mailing lists in addition to debugging and reading its implementation. This means that there may be a more straightforward way of doing what I describe in this article. If this should indeed be the case I would be very happy to hear about it.

## Constructing and returning arbitrary node trees

As Xalan itself offers no easy way of creating node trees from scratch I had to fall back on using the underlying [Xerces] XML library. This increased the problem from creating the node tree and managing its lifetime to creating a [`xercesc::DOMDocument`] instance, constructing the tree in this newly created document, converting it into a [`xalan::XalanDocument`] and wrapping its nodes into a [`xalan::XPathExecutionContext::BorrowReturnMutableNodeRefList`] instance in addition to keeping the result in memory after the function call is concluded.

Because Xerces doesn't fully adhere to the principles of [RAII] I suggest wrapping [`xercesc::DOMDocument`] inside a `std::unique_ptr` specialized on a corresponding custom deleter as follows:

~~~
class document_deleter {
	friend std::unique_ptr<xercesc::DOMDocument, document_deleter>;

	void operator()(xercesc::DOMDocument* document) {
		document->release();
	}
};

typedef std::unique_ptr<
	xercesc::DOMDocument,
	document_deleter
> document_ptr;

document_ptr document(
	xercesc::DOMImplementation::getImplementation()->createDocument(
		nullptr,
		*XercesStringGuard<XMLCh>("content"),
		nullptr
	)
);
~~~
{: .language-cpp}

Notable in the example above is the usage of a special [`XercesStringGuard`] class template I implemented to simplify the conversion between `char` based strings and the custom `XMLCh` type used by Xerces. After one has constructed the desired document tree using the standard DOM manipulations provided by [`xercesc::DOMDocument`] the next step is the conversion of this Xerces specific document into a [`xalan::XalanDocument`] instance usable by Xalan.

As Xalan is based on Xerces it offers a class especially for this task called [`xalan::XercesDOMWrapperParsedSource`] that may be used as follows:

~~~
xalan::XercesParserLiaison parser;
xalan::XercesDOMSupport domSupport(parser);
xalan::XercesDOMWrapperParsedSource parsedSource(
	xercesDocument,
	parser,
	domSupport
);

xalan::XalanDocument* const xalanDocument = parsedSource.getDocument();
~~~
{: .language-cpp}

After one has converted the Xerces document into a Xalan document its parent nodes have to be included into a [`xalan::XPathExecutionContext::BorrowReturnMutableNodeRefList`] which then may finally be passed into `xalan::XObjectFactory::createNodeSet`.

~~~
xalan::XPathExecutionContext::BorrowReturnMutableNodeRefList nodes(
	executionContext
);

nodes->addNodes(
	*xalanDocument->getDocumentElement()->getChildNodes()
);

return executionContext.getXObjectFactory().createNodeSet(nodes);
~~~
{: .language-cpp}

Note that while the listings above should be enough to get you started on implementing external functions which are able to return node trees, they do not contain the logic necessary to keep the [`xalan::XercesDOMWrapperParsedSource`] instance including its helper classes alive through the whole duration of processing a XSL transformation and do not showcase the additional method implementations required to satisfy the [`xalan::Function`] interface.

## Providing a simplified base for external functions

As I had to implement five[^2] separate external functions to fullfill my requirements there were a lot of overlapping implementation details that had to be repeated for each function implementation. These overlapping details were therefore extracted into a variadic [CRTP] template [base class]. This class template currently supports external functions with arbitrary optional or mandatory parameters and reduces external function implementations down to a single member method `constructDocument`.

This `constructDocument` method receives all parameters declared in the `FunctionBase` specialization which in turn provides type conversion and validation support through various helper classes. I suggest simply taking a look at one of the [external function implementations] offered by [InputXSLT]. There you will find a comprehensive example of how [Apache Xalan] may be expanded not just with external functions but also by providing e.g. custom entity resolution logic.

[^1]: e.g. extension elements instead of only extension functions
[^2]: [`read-file`], [`write-file`], [`read-directory`], [`external-command`] and [`generate`]

[static site generation framework]: /page/static_xslt/
[this website]: /page/this_website/
[set of external functions]: /page/input_xslt/
[Apache Xalan]: http://xalan.apache.org/xalan-c/index.html
[Xerces]: http://xerces.apache.org/xerces-c/index.html
[`xalan::Function`]: https://xalan.apache.org/xalan-c/apiDocs/classFunction.html
[`xalan::XalanTransformer`]: https://xalan.apache.org/xalan-c/apiDocs/classXalanTransformer.html
[documented]: http://xalan.apache.org/xalan-c/extensions.html
[RAII]: http://en.wikipedia.org/wiki/Resource_Acquisition_Is_Initialization
[CRTP]: http://en.wikipedia.org/wiki/Curiously_recurring_template_pattern
[`XercesStringGuard`]: https://github.com/KnairdA/InputXSLT/blob/master/src/support/xerces_string_guard.h
[`xercesc::DOMDocument`]: https://xerces.apache.org/xerces-c/apiDocs-3/classDOMDocument.html
[`xalan::XalanDocument`]: https://xalan.apache.org/xalan-c/apiDocs/classXalanDocument.html
[`xalan::XercesDOMWrapperParsedSource`]: https://xalan.apache.org/xalan-c/apiDocs/classXercesDOMWrapperParsedSource.html
[`xalan::XPathExecutionContext::BorrowReturnMutableNodeRefList`]: https://xalan.apache.org/xalan-c/apiDocs/classXPathExecutionContext_1_1GetCachedNodeList.html
[`read-file`]: https://github.com/KnairdA/InputXSLT/blob/master/src/function/read_file.h
[`write-file`]: https://github.com/KnairdA/InputXSLT/blob/master/src/function/write_file.h
[`read-directory`]: https://github.com/KnairdA/InputXSLT/blob/master/src/function/read_directory.h
[`external-command`]: https://github.com/KnairdA/InputXSLT/blob/master/src/function/external_command.h
[`generate`]: https://github.com/KnairdA/InputXSLT/blob/master/src/function/generate.h
[base class]: https://github.com/KnairdA/InputXSLT/blob/master/src/function/base.h
[InputXSLT]: /page/input_xslt/
[external function implementations]: https://github.com/KnairdA/InputXSLT/tree/master/src/function
