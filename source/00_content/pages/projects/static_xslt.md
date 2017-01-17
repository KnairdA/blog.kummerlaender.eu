# StaticXSLT

…is the XSLT based static site generation framework especially developed to generate this website.

Its MIT licensed source code is available on both [Github] and [cgit].

The implementation of a pure[^1] XSLT solution to the problem of static site generation required the development of a collection of external functions enabling access to the filesystem, external applications and other transformations from inside XSLT. These external functions are not part of this project and were developed separately as [InputXSLT]. Additionally a basic XSLT build system was developed to make _StaticXSLT_ usable for different projects which is available as [BuildXSLT].

The prime example of how this framework may be used in practice is the implementation of [this website]. 

## Overview

The implementation of the static site generator is contained within the `src/steps` directory of the linked repository and consists of four XSL transformations that all form a link in the generation chain module executed by [BuildXSLT].

These transformations traverse the given source directory, plan tasks[^2] to be executed, process those tasks and summarize the result for the user.

```
common:~# ixslt --input make.xml --transformation ../BuildXSLT/build.xsl
Tasks processed:  19
Tasks successful: 19
▶ Generation successful.
common:~#
```

The first of these transformations `list.xsl` traverses and lists a `source` directory containing various _levels_ depicting the different stages of the actual static site generation process as a base for all further processing.

Based on the results of the `list.xsl` transformation the next transformation `plan.xsl` schedules a number of different tasks to be processed by `process.xsl`. Examples for these tasks are cleaning a `target` directory, linking files and folders and of course generating transformation stylesheets contained within the various _levels_ of the `source` tree.

After the various tasks are processed by `process.xsl` the results of all tasks are summarized by `summarize.xsl` to provide the user with a easy to read plain-text output.

## Levels

A _level_ is simply a folder within a given `source` directory which may in turn contain a arbitrary number of transformations and source documents inside subfolders. All transformations within these _levels_ are processed by the _StaticXSLT_ transformation chain which handles datasource dependency resolution and preserves the correct result path context. _Levels_ are processed according to their alphabetic order. Subfolders of _level_ directories that do not contain any XSLT stylesheets and non-stylesheet files are automatically symlinked to their appropriate target directory.

## Data Source and target resolution

Every transformation contained in one of the _levels_ contains a `meta` variable defining the required data sources and target paths. This information is read during task processing by the `process.xsl` transformation and used to provide each transformation with the data sources it requires and write the output to the path it desires. This definition of requirements and targets directly inside each transformation is an essential part of how this static site generation concept works.

The system currently provides a couple of different data source reading modes such as `full` for reading a complete XML file as input, `iterate` for iterating the second-level elements of a given XML source and `expression` for evaluating a arbitrary XPath expression against a given XML file. Target modes include `plain` for writing a the result into a given file at the appropriate target level and `xpath` for evaluating a XPath expression to generate the target path. This XPath evaluation functionality in combination with the `iterate` data source mode is especially helpful in situations where one wants to generate multiple output files from a single transformation such as when generating article pages or the pages of the article stream.

## Differentiation and limitations

This approach to static site generation is novel in the manner that it is the only publicly available XSLT based solution to this problem domain that I am aware of, which uses XSLT as both the application and template language. I extended XSLT with [InputXSLT] and developed this static site generation in the attempt of producing something as flexible as [Symphony CMS] that generates static output.

The current implementation of the concept described on this page is limited in the sense that it doesn't support incremental regeneration but generates the whole website from scratch on each run. While this problem should also be solvable in pure XSLT, I currently do not plan on solving it as it is fast enough for my current use cases and largely depends on the speed of the used Markdown processor and syntax highlighter anyway.

[^1]: Pure as in all templates, data source aggregation and the generation logic itself is implemented in XSLT. Tasks like e.g. syntax highlighting and Markdown processing are still handled by external programs called from within XSLT.
[^2]: Tasks include cleaning directories, generating transformations and symlinking directories and files into the target directory

[Github]: https://github.com/KnairdA/StaticXSLT/
[cgit]: http://code.kummerlaender.eu/StaticXSLT/
[BuildXSLT]: /page/build_xslt/
[InputXSLT]: /page/input_xslt/
[this website]: /page/this_website/
[Symphony CMS]: http://getsymphony.com
