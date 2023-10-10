"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #SymbolSet,
	#superclass : #Collection,
	#category : #Kernel
}

{ #category : #testing }
SymbolSet >> add: anObject [
	<primitive: SymbolSetAdd>
]

{ #category : #testing }
SymbolSet >> includes: element [
	<primitive: SymbolSetIncludes>
]


{ #category : #inquiries }
SymbolSet >> lookup: anObject [
	<primitive: SymbolSetLookup>
]

