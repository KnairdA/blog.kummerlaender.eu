# Introduction to expressing and controlling object ownership in C++11

_This is a theoretical introduction to my findings on memory management in C++11. You will not find code examples in this article because I think a explanation of what something is and how it is linked to other things is sometimes more helpful than a row of code snippets. Also I am only actively using C++ in a free time project (as of today unpublished) since about 3/4 of a year and there are already lots of nice code samples out there :) For more information on using the classes mentioned in this article I suggest checking out [cppreference.com](http://en.cppreference.com/w/cpp/memory)._

One important step to prevent memory errors in C++ applications is tracking the ownership of object instances.
Thereby the important aspect is not tracking who instantiated an object, but who is responsible for freeing the object.

For every object allocated by _new_ or _std::malloc_ there has to be an corresponding _delete_ or _std::free_ - otherwise
we will leak memory on the heap because it is never released back into the hands of the operating system.

This specific property of memory management in C++ is what makes tracking object ownership so important. If we do not know who owns
an object instance, we do not know who has to release the memory allocated for it. This means that we always have to think about freeing memory before letting a scope exit throw away our pointer to it. If we loose all pointers to a heap allocated object it will not automatically disappear but stay in memory _"forever"_.

* Before we exit a scope by _return_, all memory allocated by _new_ or _std::malloc_ has to be freed
* Before we exit a scope by throwing an exception, all memory allocated by _new_ or _std::malloc_ has to be freed

This is a lot to think about and it is easy to forget places where a scope is exited. These potential error sources only get more as a program grows in complexity.

Luckily there is one thing that is guaranteed by the ISO C++ standard itself to be executed in all cases before a scope is exited:
Destructors of stack-allocated objects. To quote the standard:

> As control passes from a throw-expression to a handler, destructors are invoked for all automatic objects
> constructed since the try block was entered. The automatic objects are destroyed in the reverse order of the
> completion of their construction.  
> ([ISO C++ Standard draft, N3337](http://www.open-std.org/jtc1/sc22/wg21/), p. 380)

This property enables us to delegate the freeing of memory to object destructors - we can wrap memory management in classes which can 
then be used as normal scope bound variables. This approach to memory management called <abbr title="Resource Acquisition Is Initialization">[RAII](http://en.wikipedia.org/wiki/Resource_Acquisition_Is_Initialization)</abbr>
was invented by Bjarne Stroustrup, the creator
of C++, and enables us to free our minds from constantly worrying about possibilities for memory leaking. Without this technique C++
code would mostly consist of code to allocate and free memory, and as such is vital to writing readable and at the same time exception safe code.

We could write appropriate classes to wrap our object instance pointers by ourselves but luckily the current C++ standard library version includes
shiny new _smart pointer_ templates that give us flexible and standardised templates that do just that: wrap our pointers and limit their
lifetime to a scope.

## std::unique_ptr

> A unique pointer is an object that owns another object and manages that other object through a pointer.
> More precisely, a unique pointer is an object u that stores a pointer to a second object p and will dispose of
> p when u is itself destroyed (e.g., when leaving block scope (6.7)). In this context, u is said to own p.  
> ([ISO C++ Standard draft, N3337](http://www.open-std.org/jtc1/sc22/wg21/), p. 513)

As the standard states and the name implies a `std::unique_ptr` is an object that owns another object (pointer) uniquely. A `std::unique_ptr` can not be
copied, only moved and destroys the owned object in its destructor. This behavior implies that the contained object only has one owner - if we return
such a smart pointer from a function we say that the caller gains unique ownership over the returned object. But we can still retrieve a copy of the
contained pointer - because of that the `std::unique_ptr` only implies that it is unique, it does not enforce it other than by being non copyable.
This possibility to retrieve the raw pointer is not a weakness because it enables us to use normal raw pointers as a way to imply: you are allowed to
use this object instance in any way you like, but you are not required to think about its destruction.

## std::shared_ptr

> The shared\_ptr class template stores a pointer, usually obtained via new. shared\_ptr implements semantics
> of shared ownership; the last remaining owner of the pointer is responsible for destroying the object, or
> otherwise releasing the resources associated with the stored pointer.  
> ([ISO C++ Standard draft, N3337](http://www.open-std.org/jtc1/sc22/wg21/), p. 524)

In comparison to a `std::unique_ptr` a `std::shared_ptr` is usually not the unique owner of the contained object. It implements reference counting and
only destroys the managed memory if it is the only remaining - unique - owner when its destructor is executed. If we return a `std::shared_ptr` from a
function we say that the caller gains shared ownership over the returned object. This has the effect of making it hard to know when a contained object
will finally be released but as with the `std::unique_ptr` the task of worrying about this issue is handled automatically in the background.
I seldomly have the requirement to share ownership of an object with other objects, but there is one case I can think of were we can take advantage
of the reference counting part of the `std::shared_ptr` implementation: A factory class that needs to keep a pointer to the instantiated object (in my case
event subscribers) because it passes events into it but wants to give the caller an easy way to state that it is no longer using the object and wants to remove it from
the subscriber list. If we use a `std::shared_ptr` for this example we can regularly check the smart pointers for uniqueness and if that is the case remove
it from our subscriber list. As long as we have one or more owners outside the factory that are using the object to retrieve events we know that it is still
required to be supplied, if that is no longer the case we can safely remove it from the subscriber list.

## std::weak_ptr

> The weak\_ptr class template stores a weak reference to an object that is already managed by a shared\_ptr.
> To access the object, a weak\_ptr can be converted to a shared_ptr using the member function lock.  
> ([ISO C++ Standard draft, N3337](http://www.open-std.org/jtc1/sc22/wg21/), p. 533)

If we want to imply to a owner of a `std::shared_ptr` that she is only granted temporary, non-owning access to the object instance as we did through
raw pointers to the contained object of a `std::unique_ptr`, we can do that by passing a `std::weak_ptr`. This means
that a function returning such a smart pointer is implying that we grant the caller temporary shared ownership while advertising the possibility that
the contained object instance does not exist anymore. We can not assume that we have a usable instance and will have to check before converting the `std::weak_ptr` to
a `std::shared_ptr`.

## What I prefer to use

As I already hinted earlier I am only seldomly using a `std::shared_ptr` and the accompanying `std::weak_ptr` and am mostly relying on the combination of
a single, distinct object owning `std::unique_ptr` that passes around "use only" raw pointers to other objects that are guaranteed to not exceed the lifetime of the owner
itself. These new smart pointers in C++11 really make writing nice and exception safe code easier and make C++ feel more like a language with automatic
garbage collection while still enabling the programmer to use the full possibilities of pointers when it is appropriate. We can take advantage of the
possibilities of automatic memory management without the cost of a full blown automatic garbage collection system.

I for one like this approach to handling memory very much and find C++11 code to be easier on the eyes while making a higher level of abstraction of the program
logic possible. 

As a footnote, smart pointers are only one of many interesting additions in C++11. If you want more you should definitely check out the [other features](http://www.stroustrup.com/C++11FAQ.html)!
