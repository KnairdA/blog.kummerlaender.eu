# justify

...is a single purpose program for block justification of UTF-8 encoded monospace text.

Textual input is read from _STDIN_ and written to _STDOUT_ in its justified form. The default output width of 60 characters may be customized via `--length`. Optionally an offset of leading spaces may be defined using `--offset`.

i.e. `echo "$the_paragraph_above" | justify --length 40` results in:

	Textual input  is  read from _STDIN_ and
	written  to  _STDOUT_  in  its justified
	form.  The  default output  width  of 60
	characters    may   be    customized via
	`--length`.  Optionally   an   offset of
	leading   spaces  may  be  defined using
	`--offset`.

The MIT licensed source code is available on both [Github] and [cgit].

[Github]: https://github.com/KnairdA/justify/
[cgit]: https://code.kummerlaender.eu/justify/
