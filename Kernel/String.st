"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #String,
	#superclass : #CharacterArray,
	#type : #bytes,
	#category : #Kernel
}

{ #category : #'instance creation' }
String class >> basicNew: anInteger [
	^self primitiveNewBytes: anInteger + 1
]

{ #category : #'instance creation' }
String class >> fromBytes: aByteArray [
	| n string |
	n := aByteArray sizeInBytes.
	string := self basicNew: n.
	^string
		replaceBytesFrom: 1
		to: n
		with: aByteArray
		startingAt: 1
]

{ #category : #'instance creation' }
String class >> new: anInteger [
	^self primitiveNewBytes: anInteger + 1
]

{ #category : #gs }
String class >> newFrom: aByteArray [
	| string |
	string := self new: aByteArray size.
	^string replaceFirst: aByteArray size with: aByteArray
]

{ #category : #comparing }
String >> = aString [
	| n |
	(self equals: aString) ifTrue: [^true].
	aString isSymbol ifTrue: [^false].
	aString isString ifFalse: [^false].
	n := self size.
	n = aString size ifFalse: [^false].
	1 to: n do: [:i | (self codeAt: i) = (aString codeAt: i) ifFalse: [^false]].
	^true
]

{ #category : #converting }
String >> asSymbol [
	^Symbol intern: self
]

{ #category : #accessing }
String >> at: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
]

{ #category : #accessing }
String >> at: anInteger put: aCharacter [
	^self basicAt: anInteger put: aCharacter
]

{ #category : #accessing }
String >> at: index putCode: codePoint [
	self byteAt: index put: codePoint
]

{ #category : #accessing }
String >> atValid: anInteger [
	^self characterAtValid: anInteger
]

{ #category : #accessing }
String >> basicAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
]

{ #category : #accessing }
String >> basicAt: anInteger put: aCharacter [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	aCharacter isCharacter
		ifFalse: [^self
			error: self class name , ' can''t hold ' , aCharacter class name].
	aCharacter isByteCharacter
		ifFalse: [^self
			error: 'Strings cannot hold Unicode characters greater than 255'].
	^self _byteAt: anInteger put: aCharacter asInteger
]

{ #category : #accessing }
String >> basicSize [
	^self _size - 1
]

{ #category : #accessing }
String >> byteAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _byteAt: anInteger
]

{ #category : #accessing }
String >> byteAt: position put: asciiValue [
	position _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= position and: [position < self _size])
		ifFalse: [^self outOfBoundsIndex: position].
	(0 <= asciiValue and: [asciiValue < 256])
		ifFalse: [^self error: 'invalid character'].
	^self _byteAt: position put: asciiValue
]

{ #category : #converting }
String >> bytes [
	| array |
	array := ByteArray new: self _size.
	^array
		replaceBytesFrom: 1
		to: self sizeInBytes
		with: self
		startingAt: 1
]

{ #category : #accessing }
String >> characterSize [
	^1
]

{ #category : #converting }
String >> existingSymbol [
	^Symbol findInterned: self
]

{ #category : #comparing }
String >> goodHash [
	| hash |
	hash := self size.
	self
		do: [:char | hash := (hash * 16r19660D bitAnd: 16rFFFFFFF)
			bitXor: char asInteger].
	^hash
]

{ #category : #inquiries }
String >> indexOf: anObject
between: start
and: end
ifAbsent: aBlock [
	| index cp |
	self characterSize = 1
		ifFalse: [^super
			indexOf: anObject
			between: start
			and: end
			ifAbsent: aBlock].
	cp := anObject codePoint.
	index := start.
	[index <= end] whileTrue: [
		(self byteAt: index) = cp ifTrue: [^index].
		index := index + 1].
	^aBlock value
]

{ #category : #parsing }
String >> indexOfString: aString
from: start
to: stop
td1: anArray [
	| m k |
	m := aString size.
	m = 0 ifTrue: [^0].
	k := start.
	[k + m - 1 <= stop] whileTrue: [| i byte delta |
		i := 1.
		[i <= m and: [(aString at: i) = (self at: k + i - 1)]]
			whileTrue: [i := i + 1].
		i > m ifTrue: [^k].
		k + m > stop ifTrue: [^0].
		byte := self byteAt: k + m.
		delta := (anArray at: byte + 1) ifNil: [m + 1].
		k := k + delta].
	^0
]

{ #category : #accessing }
String >> length [
	^self size
]

{ #category : #private }
String >> primitiveReplaceFrom: start to: stop withObject: aCharacter [
	self checkCharacter: aCharacter.
	aCharacter isUnicode
		ifTrue: [self error: 'Strings cannot hold Unicode characters'].
	start to: stop do: [:i | self at: i put: aCharacter].
	^aCharacter

]

{ #category : #replacing }
String >> replaceFirst: count with: aCollection [
	^self replaceFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #replacing }
String >> replaceFrom: start
to: stop
with: aString
startingAt: position [
	aString class isBytes
		ifTrue: [self
			replaceBytesFrom: start
			to: stop
			with: aString
			startingAt: position]
		ifFalse: [super
			replaceFrom: start
			to: stop
			with: aString
			startingAt: position]
]

{ #category : #replacing }
String >> replaceFrom: start to: stop withObject: aCharacter [
	start > 0 ifFalse: [
		self
			error: 'Invalid argument in ' , self storeString
				, '>>#replaceFrom:to:withObject:'].
	^self primitiveReplaceFrom: start to: stop withObject: aCharacter
]

{ #category : #accessing }
String >> size [
	^self _size - 1
]

{ #category : #accessing }
String >> sizeInBytes [
	^self size
]
