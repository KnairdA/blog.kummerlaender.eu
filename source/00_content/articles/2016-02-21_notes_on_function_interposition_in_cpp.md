# Notes on function interposition in C++

To counterbalance the fastly increased amount of time I am spending on purely theoretical topics since I started studying mathematics, my most recent leisure time project was to familiarize myself with function interposition in C++ on Linux. This article will document some of the ins and outs of using this technique in an actual project in addition to describing how the acquisition of the interposed function's pointer may be reasonably abstracted by a function template.

## Basics

Most if not all of the applications and services one commonly uses are not monolithic executables that one could execute on the _bare metal_ but depend on a number of separate libraries that provide useful abstractions the actual application is built upon. As most application share a common set of library dependencies it would be quite wasteful to package each application with its own separate copy of a given library. This is why most libraries are commonly _linked dynamically_ which means that e.g. a call to _random library function_ `f` is not resolved during compilation by replacing it with the library provided source code or a fixed reference to the implementation of `f` but resolved respectively linked at runtime. For Linux applications this dynamic resolution is commonly performed by _the dynamic linker_ `ld.so`.

Instance specific configuration of this library is possible via a set of environment variables. One of these variables is `LD_PRELOAD` which enables us to provide "[...] a list of additional, user-specified, ELF shared objects to be loaded before all others [that] can be used to selectively override functions in other shared objects." (`ld.so` manpage, section on `LD_PRELOAD`).

This feature is what is commonly referred to as function interposition and is what will be discussed in the following sections. Other options for intercepting function calls such as `ptrace` are not covered by this particular article.

## Use case

Function interposition is useful in various practical scenarios such as providing custom memory allocators as drop in replacements for the appropriate standard library functions as well as monitoring the function calls of a application as an additional debugging avenue. Furthermore `LD_PRELOAD`'s nature of replacing library functions with custom logic in a not necessarily obvious manner makes it a security risk which is why it is disabled for e.g. `setuid` applications. But even with this restriction it may be used as a foundation for userland rootkits - for instance one could hijack the library functions used to interface with the file system and change what certain applications see. Such shenanigans could then in turn be used to manipulate the source code of an application during compilation while continuing to display the unchanged source code to the user via her chosen text editor and file hashing tool. More information on this kind of attack can be obtained e.g. in the _31c3_ talk on [reproducible builds] which is where I was first confronted with this risk.

However the use case that led me to dive into this topic was to develop a program to be dropped in front of any `LD_PRELOAD` supported program that would then monitor all relevant file system interactions and generate a nice summary of what was changed to be used for documentation purposes. The result of this undertaking is available on [Github] and [cgit].

[reproducible builds]: https://media.ccc.de/v/31c3_-_6240_-_en_-_saal_g_-_201412271400_-_reproducible_builds_-_mike_perry_-_seth_schoen_-_hans_steiner
[Github]: https://github.com/KnairdA/change/
[cgit]: https://code.kummerlaender.eu/change/

## Requirements for successful interposition

To interpose a given function the library provided to the dynamic linker via `LD_PRELOAD` simply needs to contain a function symbol of the same name and signature.While this is not a problem in C it can be problematic in C++ as the compiler per default performs _name mangling_ to convert a given function signature to a plain string[^1]. Luckily this can be prevented by enclosing the functions to be interposed in an `external "C"` block.

To check if the symbols are exported correctly we can use `nm` which ĺists the symbols in ELF object files.

	> nm libChangeLog.so | grep "open\|write"
	000000000009e866 T open
	000000000009e99b T write
	000000000009ea5d T writev
	000000000009f61a W _Z11track_writei
	000000000009f6ec W _Z11track_writeRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	[...]

As we can see interposing this library would lead to the application calling the library's `open`, `write` and `writev` functions instead of the standard C library's. Note that the C++ source additionally needs to be compiled as position-independent code to be usable as a shared library at all. If one uses _clang_ or _g++_ this is easily achieved by adding the `-fPIC` option.

[^1]: This is required to e.g. support function overloading which is not available in C. Of course this also means that our interposed functions can not be overloaded. Function names may be demangled via the `--demangle` option of `nm`.

## Acquiring a pointer to the actual function

Although we can now replace functions in a target application with our own logic the goal remains to merely interpose a function which means that we have to call the actual function at some point. The dynamic linker library offers a function to acquire the address of the next symbol with a given name in the resolution stack in the form of `dlsym`. This function is defined in the `dlfcn.h` header and requires the interposed library to be linked to `ld.so`.

~~~
void* dlsym(void* handle, const char* symbol);
~~~
{:.language-c}



## Abstracting function pointer handling

## Problems in practice

### Implementing a static memory allocator

## Summary
