# Tuqui in a nutshell

- Tuqui is a toy Smalltalk-like language for teaching compilers and VMs.
- Syntax and semantics are pretty much the same than Smalltalk
- This is a reduced thing, at the cost of a few important missing things: processes, errors, unicode, streams, ffi, floats, fractions, among others
- The idea is to keep the language as small as possible while keeping metacircularity
- It is not meant to be used for real, just for allowing code to be executed and compilers and VMs to be implemented for it

# Implementations

There are no VMs in this repo. You have to look for an implementation that suits your needs among the following:

 ## Tuqui/Pharo

 An implementation that reads the source from pharo and allows executing code in a simulated image.

