# blog.kummerlaender.eu

This repository contains a implementation of my existing [Symphony CMS based blog](https://github.com/KnairdA/symphony_blog) using static site generation in XSLT enabled by [InputXSLT](https://github.com/KnairdA/InputXSLT) and [BuildXSLT](https://github.com/KnairdA/BuildXSLT) using the [StaticXSLT](https://github.com/KnairdA/StaticXSLT) module.

## Usage:

The `make.xml` file contains the build instructions to be processed by [BuildXSLT](https://github.com/KnairdA/BuildXSLT) which may be executed as follows:

```
ixslt --input make.xml --transformation ../BuildXSLT/build.xsl --include ../StaticXSLT
```

## Levels:

The first level `00_content` contains the actual content source of the blog to be generated. This includes articles and pages formatted in Markdown and meta-data such as the page title, public URL and primary author in `meta.xml`. It is notable that this first level doesn't contain any actual transformations and as such only provides a way to store the input to levels further down the processing pipeline.

The second level `01_data` reads the contents of the `00_content` level and generates data sources for articles, pages and tags. These data sources contain e.g. the augmented contents of articles already converted from Markdown into _XHTML_ and separated into title, data and content areas.

The third level `02_meta` further augments and groups these data sources. For example articles are grouped by year, tags and categories are resolved and augmented with article data provided by the previous level and articles are paginated in preparation for generating the primary article stream.

Last but not least the fourth level `99_content` takes all the data sources generated in lower levels and generates the actual website pages.
