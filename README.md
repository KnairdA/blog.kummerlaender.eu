# blog.kummerlaender.eu

This repository contains a implementation of my existing [Symphony CMS based blog](https://github.com/KnairdA/symphony_blog) using static site generation in XSLT enabled by [InputXSLT](https://github.com/KnairdA/InputXSLT) and [BuildXSLT](https://github.com/KnairdA/BuildXSLT).

## Overview:

The `detail` directory contains a chain of transformations which are processed by the build system as specified in `make.xml`.

The first of these transformations `list.xsl` traverses and lists the `source` directory as a base for all further processing. This `source` directory contains four so called _levels_ which depict the different stages of the static generation process.

Based on the results of the `list.xsl` transformation the next transformation `plan.xsl` schedules a number of different tasks to be processed by `process.xsl`. Examples for these tasks are cleaning the `target` directory, linking files and folders and of course generating transformation stylesheets contained within the various levels of the `source` tree.

After the various tasks are processed by `process.xsl` the results of all tasks are summarized by `summarize.xsl` to provide the user with a easy to read plain-text output.

## Levels:

The first level `00_content` contains the actual content source of the blog to be generated. This includes articles and pages formatted in Markdown and meta-data such as the page title, public URL and primary author in `meta.xml`. It is notable that this first level doesn't contain any actual transformations and as such only provides a way to store the input to levels further down the processing pipeline.

The second level `01_data` reads the contents of the `00_content` level and generates data sources for articles, pages and tags. These data sources contain e.g. the augmented contents of articles already converted from Markdown into _XHTML_ and separated into title, data and content areas.

The third level `02_meta` further augments and groups these data sources. For example articles are grouped by year, tags and categories are resolved and augmented with article data provided by the previous level and articles are paginated in preparation for generating the primary article stream.

Last but not least the fourth level `99_content` takes all the data sources generated in lower levels and generates the actual website pages.

## Data Source and target resolution:

Every transformation contained in one of the levels contains a `meta` variable defining the required data sources and target paths. This information is read during task processing by the `process.xsl` transformation and used to provide each transformation with the data sources it requires and write the output to the path it desires. This definition of requirements and targets directly inside each transformation is an essential part of how this static site generation concept works.

The system currently provides a couple of different data source reading modes such as `full` for reading a complete XML file as input, `iterate` for iterating the second-level elements of a given XML source and `expression` for evaluating a arbitrary XPath expression against a given XML file. Target modes include `plain` for writing a the result into a given file at the appropriate target level and `xpath` for evaluating a XPath expression to generate the target path. This XPath evaluation functionality in combination with the `iterate` data source mode is especially helpful in situations where one wants to generate multiple output files from a single transformation such as when generating article pages or the pages of the article stream.
