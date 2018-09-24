# Notes on function interposition in C++

To counterbalance the vastly increased amount of time I am spending on purely theoretical topics since I started studying mathematics, my most recent leisure time project was to familiarize myself with function interposition in C++ on Linux. This article will document some of the ins and outs of using this technique in an actual project in addition to describing how the acquisition of the interposed function's pointer may be reasonably abstracted by a function template.

## Basics

Most if not all of the applications and services one commonly uses are not monolithic executables that one could execute on the _bare metal_ but depend on a number of separate libraries that provide useful abstractions the actual application is built upon. As most application share a common set of library dependencies it would be quite wasteful to package each application with its own separate copy of a given library. This is why most libraries are commonly _linked dynamically_ which means that e.g. a call to _random library function_ `f` is not resolved during compilation by replacing it with the library provided source code or a fixed reference to the implementation of `f` but resolved respectively linked at runtime. For Linux applications this dynamic resolution is commonly performed by _the dynamic linker_ `ld.so`.

Instance specific configuration of this library is possible via a set of environment variables. One of these variables is `LD_PRELOAD` which enables us to provide "[...] a list of additional, user-specified, ELF shared objects to be loaded before all others that can be used to selectively override functions in other shared objects." (`ld.so` manpage, section on `LD_PRELOAD`).

This feature is what is commonly referred to as function interposition and is what will be discussed in the following sections. Other options for intercepting function calls such as `ptrace` are not covered by this particular article.

## Use case

Function interposition is useful in various practical scenarios such as providing custom memory allocators as drop in replacements for the appropriate standard library functions as well as monitoring the function calls of a application as an additional debugging avenue. Furthermore `LD_PRELOAD`'s nature of replacing library functions with custom logic in a not necessarily obvious manner makes it a security risk which is why it is disabled for e.g. `setuid` applications. But even with this restriction it may be used as a foundation for userland rootkits - for instance one could hijack the library functions used to interface with the file system and change what certain applications see. Such shenanigans could then in turn be used to manipulate the source code of an application during compilation while continuing to display the unchanged source code to the user via her chosen text editor and file hashing tool. More information on this kind of attack can be obtained e.g. in the _31c3_ talk on [reproducible builds] which is where I was first confronted with this risk.

However the use case that led me to dive into this topic was to develop a tool to be dropped in front of any `LD_PRELOAD` supported program that would then monitor all relevant file system interactions and generate a nice summary of what was changed to be used for documentation purposes. The result of this undertaking is available on [Github] and [Gitea].

[reproducible builds]: https://media.ccc.de/v/31c3_-_6240_-_en_-_saal_g_-_201412271400_-_reproducible_builds_-_mike_perry_-_seth_schoen_-_hans_steiner

## Requirements for successful interposition

To interpose a given function the library provided to the dynamic linker via `LD_PRELOAD` simply needs to contain a function symbol of the same name and signature.While this is not a problem in C it can be problematic in C++ as the compiler per default performs _name mangling_ to convert a given function signature to a plain string[^1]. Luckily this can be prevented by enclosing the functions to be interposed in an `external "C"` block.

Note that this only applies if we want to specifically interpose C functions from C++. There is nothing stopping us from interposing any function in a shared library as long as we can get the compiler to generate the correct symbol name. Accordingly this also works for C++ class member functions or functions of libraries written in other languages such as D.

To check if the symbols are exported correctly we can use `nm` which ĺists the symbols in ELF object files.

```sh
> nm libChangeLog.so | grep "open\|write"
000000000009e866 T open
000000000009e99b T write
000000000009ea5d T writev
000000000009f61a W _Z11track_writei
000000000009f6ec W _Z11track_writeRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
[...]
```

As we can see interposing this library would lead to the application calling the library's `open`, `write` and `writev` functions instead of the standard C library's. Note that the C++ source additionally needs to be compiled as position-independent code to be usable as a shared library at all. If one uses _clang_ or _g++_ this is easily achieved by adding the `-fPIC` option.

[^1]: This is required to e.g. support function overloading which is not available in C. Of course this also means that our interposed functions can not be overloaded. Function names may be demangled via the `--demangle` option of `nm`.

## Acquiring a pointer to the actual function

Although we can now replace functions in a target application with our own logic the goal remains to merely interpose a function which means that we have to call the actual function at some point. The dynamic linker library offers a function to acquire the address of the next symbol with a given name in the resolution stack in the form of `dlsym`. This function is defined in the `dlfcn.h` header and requires the interposed library to be linked to `ld.so`.

```c
void* dlsym(void* handle, const char* symbol);
```

While `handle` can be used to restrict the resolution to a specific shared library we pass a special pseudo-handle `RTLD_NEXT` which instructs the function to return the address of the next symbol whose name equals the null-terminated `symbol` parameter.

Note that `RTLD_NEXT` is only defined by `dlfcn.h` if `_GNU_SOURCE` is defined during preprocessing - i.e. before the header is included. This may happen implicitly if `features.h` is included. If this should not be the case a plain `#define _GNU_SOURCE` satisfies the requirement.

If we were working in C we could directly assign the returned pointer of type `void*` to a function pointer of the function's signature. However this sort of cast is not allowed in C++ which is why we need to manually copy the address of the symbol into a function pointer. This may be achieved using `std::memcpy`.

```cpp
const void* symbol_address{ dlsym(RTLD_NEXT, "write") };
ssize_t (actual_function*)(int, const void*, size_t){};

std::memcpy(&actual_function, &symbol_address, sizeof(symbol_address));
```

To prevent `dlsym` from being unneccessarily called more than once for a given symbol name one probably wants to persist the function pointer to e.g. a static variable local to the function body.

```cpp
static ssize_t (actual_function*)(int, const void*, size_t){};

if ( !actual_function ) {
	const void* symbol_address{ dlsym(RTLD_NEXT, "write") };

	std::memcpy(&actual_function, &symbol_address, sizeof(symbol_address));
}
```

This logic should be placed in the function body and not for instance in a global initialization function as it is not guaranteed that such a function will be executed prior to any calls to interposed functions. The next section will describe an approach to reduce unneccessary code duplication in this context.

## Abstracting function pointer handling

The most straight forward approach to abstracting the usage of `dlsym` is to wrap it in a more C++-like function template. To prevent unneccessary duplication of the functions return and parameter types as well as to hide the _strange_ syntax of function pointer declaration we first define a template alias as follows:

```cpp
template <class Result, typename... Arguments>
using ptr = Result(*)(Arguments...);
```

This allows us to define function pointers in a fashion simmilar to `std::function` and can be used as the template parameter of our actual `dlsym` abstraction.

```cpp
template <typename FunctionPtr>
FunctionPtr get_ptr(const std::string& symbol_name) {
	const void* symbol_address{ dlsym(RTLD_NEXT, symbol_name.c_str()) };

	FunctionPtr actual_function{};
	std::memcpy(&actual_function, &symbol_address, sizeof(symbol_address));

	return actual_function;
}
```

This extraction of all `dlsym` calls into a single function template will come in handy during the section on _problems in practice_. Furthermore it allows us to write the exemplary interposition of the `write` library function in the following way which I for one find to be more maintainable and overall nicer looking than its c-style equivalent.

```cpp
ssize_t write(int fd, const void* buffer, size_t count) {
	static actual::ptr<ssize_t, int, const void*, size_t> actual_write{};

	if ( !actual_write ) {
		actual_write = actual::get_ptr<decltype(actual_write)>("write");
	}

	// <-- custom logic to be interposed in all `write` calls

	return actual_write(fd, buffer, count);
}
```

## Problems in practice

The approach detailed in the sections above was enough to develop my transparent file system change tracking tool to a point where it could monitor the actions of the core utilities as well as generate _diffs_ of files edited in _vim_. But while checking out the current state of the [neovim] project I discovered that interposing `libChangeLog.so` led to a deadlock during startup.

This deadlock was caused by the custom memory allocation library [jemalloc] used by _neovim_ because it calls `mmap` during its initialization phase. The problem with this is that it already leads to executing `libChangeLog`’s `mmap` version whose static `actual_mmap` function pointer is not initialized at this point in time. This is detected by our current logic and leads to a call to `dlsym` to remedy this situation. Sadly `dlsym` in turn requires memory allocation via `calloc` which leads us back to initializing _jemalloc_ and as such to a deadlock.

I first saw this as a bug in _jemalloc_ which seemed to be confirmed by a short search in my search engine of choice. This prompted me to create an appropriate [bug report] which was dismissed as a problem in the way `mmap` was interposed and not as a problem in the library. Thus it seems to be accepted practice that it is not the responsibility of a preloaded library to cater to the needs of other libraries relying on function interposition. This is of course a valid position as the whole issue is a kind of chicken and egg problem where both sides can be argued.

Issues of this kind are common when implementing interpositions of low level c-library functions as they are not only used everywhere but are also non-monolithic and may easily depend on each other if they are augmented by custom logic. If we want to interpose more than a single function or add logic depending on other library calls it is quite certain that we will run into issues simmilar to the one detailed in this section. While those issues can be fixed this can easily require the interposition of further functions which can possibly quickly spin out of control.

[neovim]: https://neovim.io/
[jemalloc]: http://www.canonware.com/jemalloc/
[bug report]: https://github.com/jemalloc/jemalloc/issues/329

### Implementing a static memory allocator

To return to our issue at hand I was left with the only option of working around the deadlock by adapting `libChangeLog` to call `dlsym` without relying on the wrapped application’s memory allocator of choice. The most straight forward way to do this is to provide another custom memory allocator alongside the payload function interpositions of `mmap` and friends.

Such a static memory allocator is implemented by `libChangeLog` in commit [af756d] and basically consists of a statically sized array allocated in the object file itself alongside a stacked allocation _"algorithm"_ without any support for releasing and reusing memory of the static buffer once allocated.

This custom allocation logic is then selectively called by [interpositions of](https://github.com/KnairdA/change/blob/master/src/bootstrap.cc) `free`, `malloc` and `calloc`. The choice between using the _real_ allocator and the static allocator depends on a `dlsym` recursion counter maintained by a [`init::dlsymContext`] scope guard helper class. As we already abstracted all usage of `dlsym` to a single function template the introduction of a static allocator for `dlsym` required only small changes to the existing function interpositions.

[af756d]: https://github.com/KnairdA/change/commit/af756d78ac042a2eed2417c5250d4b675d43bf93
[`init::dlsymContext`]: https://github.com/KnairdA/change/blob/af756d78ac042a2eed2417c5250d4b675d43bf93/src/init/alloc.h

## Summary

As a conclusion one could say that function interposition is useful for both debugging applications and building programs that monitor other processes on such a low level that one doesn't need to care about the language they are written in nor needs to customize the monitoring logic for specific applications as long as everything _works as expected_. Furthermore it is a nice approach to familiarizing oneself with the lower level workings of Linux userland applications.

Although this approach depends on interfacing with C code it can be reasonably abstracted using C++ and as such can also make use of the higher level functionality offered by this language.

One should however expect to dive deeper into C library internals and debug lower level issues while actually wanting to implement higher level functionality. Furthermore we probably will not get away with just implementing an interposition of the function we are interested in but also other functions that depend on it in some fashion in some wrapped applications. Definitely exepect quite a few coredumps and deadlocks during development.

For a real world example of how function interposition using `LD_PRELOAD` and C++ may be used to build a small but hopefully useful application feel free to check out [_change_] on [Github] or [Gitea].

[_change_]: https://tree.kummerlaender.eu/projects/change/
[Github]: https://github.com/KnairdA/change/
[Gitea]: https://code.kummerlaender.eu/adrian/change/
