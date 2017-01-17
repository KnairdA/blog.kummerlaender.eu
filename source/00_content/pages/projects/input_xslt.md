# InputXSLT

…is a Apache Xalan based XSLT extension enabling access to external commands, the filesystem and calling further transformations from inside a transformation.

It is used as the base for the static site generation system used to generate the whole website you are currently viewing and is available under the terms of the _Apache License_ via [Github] or [cgit].

## Why?

Contrary to popular opinion I actually like XSLT as a content transformation language and have built - amongst other things - most of my website projects on top of it. While I used the XSLT based [Symphony CMS] for most of these endeavours, the intention behind InputXSLT was to develop XSLT extensions enabling the development of static site generators using XSLT as both a template and application language. The fact that you are currently reading this page proves that this is indeed possible.

## Overview

The following table summarizes all the external functions provided by InputXSLT. They are available under the `InputXSLT` namespace after including `function.inputxslt.application` into the stylesheet element. 

Function           Description
------------------ --------------------------------------------------------------------------------------------------------------
`read-file`        Reading plain text files as text and XML files as node trees
`read-directory`   Traversing filesystem directories
`external-command` Executing external commands including support for providing the input stream and capturing the output stream
`write-file`       Committing plain text or node trees to the filesystem
`generate`         Calling transformations including support for capturing the result or committing it directly to the filesystem

The `ixslt` XSLT frontent provided by InputXSLT also implements a custom include entity resolver alongside to an easy to use interface for implementing further custom extension functions.

## Tradeoffs and compromises

All external functions offered by InputXSLT can be accessed using the XPath expression evaluation subsystems of the XSLT language. While in some cases XSL extension elements would have been the primary choice limitations in the C++ implementation of the Apache Xalan XSLT library made the usage of external functions the path of least resistance. In practice external functions like the one used to call other transformations are wrapped inside utility templates and as such may be used as if they where implemented as extension elements. All other functions like the ones used to access the filesystem fit better within a XPath-expression context and are as such implemented in the most fitting way.

[Github]: https://github.com/KnairdA/InputXSLT
[cgit]: http://code.kummerlaender.eu/InputXSLT
[Symphony CMS]: http://getsymphony.com
