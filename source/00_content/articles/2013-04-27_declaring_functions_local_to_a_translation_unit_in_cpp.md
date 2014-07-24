# Declaring functions local to a translation unit in C++

In a current project of mine I defined the following function marked with the inline hint without declaring it in a header file:

	inline bool checkStorageSection(const void* keyBuffer) {
		return (StorageSection::Edge == readNumber<uint8_t>(
			reinterpret_cast<const uint8_t*>(keyBuffer)+0
		));
	}

This function was not defined in one but in multiple translation units - each instance with the same signature but a slightly different comparison contained in the function body. I expected these functions to be local to their respective translation unit and in the best case to be inlined into their calling member methods. 

While debugging another issue that seemed to be unrelated to these functions I noticed a strange behaviour: The calls in the member methods that should have linked to their respective local function definition all linked to the same definition in a different translation unit (the one displayed above). A quick check in GDB using the _x_-command to display the function addresses confirmed this suspicion:

	// Function address in translation unit A
	0x804e718 <GraphDB::checkStorageSection(void const*)>:  0x83e58955

	// Function address in translation unit B
	0x804e718 <GraphDB::checkStorageSection(void const*)>:  0x83e58955

The address _0x804e718_ was the address of the function definition in translation unit "A" in both cases. At first I suspected that the cause was probably that both definitions were located in the same namespace, but excluding them from the enclosing namespace declaration did not fix the problem.

After that I turned to the language standard and found the following statements concerning linkage:

> A name having namespace scope (3.3.6) has internal linkage if it is the name of  
> — a variable, function or function template that is explicitly declared static  
> ([ISO C++ Standard draft, N3337](http://www.open-std.org/jtc1/sc22/wg21/), p. 55/56)

and:

> A name having namespace scope that has not been given internal linkage above has the same linkage as the enclosing namespace if it is the name of  
> — a variable; or  
> — a function; or  
> ([ISO C++ Standard draft, N3337](http://www.open-std.org/jtc1/sc22/wg21/), p. 56)

Internal linkage is defined as:

> When a name has internal linkage , the entity it denotes can be referred to by names from other scopes in the same translation unit.  
> ([ISO C++ Standard draft, N3337](http://www.open-std.org/jtc1/sc22/wg21/), p. 55)

This means that functions in a namespace that are not explicitly marked as linked internally by the _static_ keyword, have linkage across translation units. So the compiler must have simply selected the first definition of the function and linked all following calls to this function signature to that first instance without checking if there was a definition in the current translation unit. 

So the problem was fixed by simply adding _static_ to the function definition. After this change all calls led to the correct definition.
