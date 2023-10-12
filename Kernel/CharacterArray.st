"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CharacterArray,
	#superclass : #ArrayedCollection,
	#category : #Kernel
}

{ #category : #comparing }
CharacterArray >> < aString [
	^(aString <= self) not
]

{ #category : #comparing }
CharacterArray >> <= aString [
	| iterations |
	self isUnicode == aString isUnicode ifFalse: [
		^(self isSymbol or: [aString isSymbol])
			ifTrue: [self asWideSymbol <= aString asWideSymbol]
			ifFalse: [self asWideString <= aString asWideString]].
	iterations := self size min: aString size.
	1 to: iterations do: [:i | | a b |
		a := (self at: i) asLowercase.
		b := (aString at: i) asLowercase.
		a < b ifTrue: [^true].
		a > b ifTrue: [^false]].
	^iterations = self size
]

{ #category : #comparing }
CharacterArray >> > aString [
	^(self <= aString) not
]

{ #category : #comparing }
CharacterArray >> >= aString [
	aString isString ifFalse: [^self error: 'argument is not a String'].
	^aString <= self
]

{ #category : #services }
CharacterArray >> article [
	| article first letter second |
	self isEmpty ifTrue: [^self].
	article := self first isVowel ifTrue: ['an'] ifFalse: ['a'].
	first := self first asLowercase.
	letter := self size = 1.
	second := letter ifFalse: [self second asLowercase].
	(first = $f and: [letter orNot: ['aeiloru' includes: second]])
		ifTrue: [^'an'].
	first = $u ifTrue: [
		(letter or: ['ck' includes: second]) ifTrue: [^'a'].
		second = $n
			ifTrue: [(self size = 2 or: [self third isVowel]) ifTrue: [^'a']]].
	(first = $e and: [second = $u]) ifTrue: [^'a'].
	^article
]

{ #category : #converting }
CharacterArray >> asInteger [
	^Integer fromString: self
]

{ #category : #converting }
CharacterArray >> asNumber [
	^Number fromString: self
]

{ #category : #converting }
CharacterArray >> asString [
	^self
]

{ #category : #accessing }
CharacterArray >> at: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
]

{ #category : #accessing }
CharacterArray >> basicAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
]

{ #category : #accessing }
CharacterArray >> basicAt: anInteger put: aCharacter [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
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
CharacterArray >> byteAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _byteAt: anInteger
]

{ #category : #accessing }
CharacterArray >> byteAt: position put: asciiValue [
	position _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= position and: [position <= self _size])
		ifFalse: [^self outOfBoundsIndex: position].
	(0 <= asciiValue and: [asciiValue < 256])
		ifFalse: [^self error: 'invalid character'].
	^self _byteAt: position put: asciiValue
]

{ #category : #private }
CharacterArray >> characterAtValid: index [
	| value |
	value := self _byteAt: index.
	^Character value: value
]

{ #category : #validation }
CharacterArray >> checkCharacter: aCharacter [
	aCharacter isCharacter
		ifFalse: [^self error: 'Improper store into indexable object']
]

{ #category : #private }
CharacterArray >> codeAt: i [
	^self byteAt: i
]

{ #category : #comparing }
CharacterArray >> equals: aString [
	| size |
	self class == aString class ifFalse: [^false].
	size := self basicSize.
	size = aString basicSize ifFalse: [^false].
	1
		to: size
		do: [:i | (aString _byteAt: i) = (self _byteAt: i) ifFalse: [^false]].
	^true
]

{ #category : #comparing }
CharacterArray >> equalsCaseInsensitive: aString [
	self size = aString size ifFalse: [^false].
	^self <= aString andNot: [self < aString]
]

{ #category : #comparing }
CharacterArray >> hash [
	| hash |
	hash := self size.
	1
		to: hash
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self byteAt: i)].
	^hash
]

{ #category : #inquiries }
CharacterArray >> includes: aCharacter [
	aCharacter isCharacter ifFalse: [^false].
	1 to: self size do: [:i | (self at: i) = aCharacter ifTrue: [^true]].
	^false
]

{ #category : #testing }
CharacterArray >> includesString: aString [
	^aString isEmpty or: [(self indexOfString: aString) > 0]
]

{ #category : #parsing }
CharacterArray >> indexOfLastChar: aCharacter [
	self size
		to: 1
		by: -1
		do: [:index | (self at: index) = aCharacter ifTrue: [^index]].
	^0
]

{ #category : #parsing }
CharacterArray >> indexOfLastString: aString [
	^self indexOfLastString: aString before: self size
]

{ #category : #parsing }
CharacterArray >> indexOfLastString: aString before: anInteger [
	^self indexOfLastString: aString from: 1 to: anInteger
]

{ #category : #parsing }
CharacterArray >> indexOfLastString: aString from: start to: stop [
	| n limit base i |
	n := aString size.
	limit := n + start.
	base := stop + 1.
	i := 1.
	[
		base < limit ifTrue: [^0].
		i <= n]
		whileTrue: [
			i := (self at: base - i) = (aString at: n - i + 1) ifTrue: [i + 1] ifFalse: [
				base := base - 1.
				1]].
	^i > 1 ifTrue: [base - n] ifFalse: [0]
]

{ #category : #parsing }
CharacterArray >> indexOfString: aString [
	^self indexOfString: aString startingAt: 1
]

{ #category : #parsing }
CharacterArray >> indexOfString: aString from: start to: stop [
	| n limit base i |
	n := aString size.
	limit := stop - n.
	base := start - 1.
	i := 1.
	[
		base > limit ifTrue: [^0].
		i <= n]
		whileTrue: [
			i := (self at: base + i) = (aString at: i) ifTrue: [i + 1] ifFalse: [
				base := base + 1.
				1]].
	^i > 1 ifTrue: [base + 1] ifFalse: [0]
]

{ #category : #parsing }
CharacterArray >> indexOfString: aString startingAt: anInteger [
	^self indexOfString: aString from: anInteger to: self size
]

{ #category : #parsing }
CharacterArray >> indexOfSubcollection: aString
from: start
to: stop
td1: anArray [
	^self indexOfString: aString from: start to: stop td1: anArray
]

{ #category : #testing }
CharacterArray >> isString [
	^true
]

{ #category : #private }
CharacterArray >> primitiveSize [
	^self _size
]

{ #category : #replacing }
CharacterArray >> replaceAll: aString with: anotherString [
	| string strm index fragment n |
	string := aString asString.
	string isEmpty ifTrue: [^self].
	index := self indexOfSubcollection: string startingAt: 1.
	index = 0 ifTrue: [^self].
	strm := self asString class new writeStream.
	fragment := self copyFrom: 1 to: index - 1.
	strm nextPutAll: fragment.
	n := string size.
	[index > 0] whileTrue: [| next limit |
		next := self indexOfString: string from: index + n to: self size.
		limit := next = 0 ifTrue: [self size + 1] ifFalse: [next].
		fragment := self copyFrom: index + n - 1 + 1 to: limit - 1.
		strm nextPutAll: anotherString; nextPutAll: fragment.
		index := next].
	^strm contents
]

{ #category : #replacing }
CharacterArray >> replaceAllChar: aCharacter with: aString [
	| index writer string n |
	self ASSERT: aCharacter isCharacter.
	index := self indexOf: aCharacter.
	index = 0 ifTrue: [^self].
	writer := self class new writeStream.
	string := self copyFrom: 1 to: index - 1.
	writer nextPutAll: string; nextPutAll: aString.
	n := self size.
	[index + 1 <= n] whileTrue: [| next |
		next := self
			indexOf: aCharacter
			between: index + 1
			and: n
			ifAbsent: [n + 1].
		string := self copyFrom: index + 1 to: next - 1.
		writer nextPutAll: string.
		next <= n ifTrue: [writer nextPutAll: aString].
		index := next].
	^writer contents
]

{ #category : #replacing }
CharacterArray >> replaceAllChar: aCharacter withChar: anotherCharacter [
	| copy |
	copy := self copy.
	1
		to: self size
		do: [:i | (self at: i) = aCharacter
			ifTrue: [copy at: i put: anotherCharacter]].
	^copy
]

{ #category : #accessing }
CharacterArray >> size [
	^self _size
]

{ #category : #services }
CharacterArray >> split: aString [
	"
	' +- ' split: '2 +- 3 +- 4 +- 5'
	"
	| stream substrings |
	self size = 1 ifTrue: [^self first split: aString].
	stream := aString readStream.
	substrings := OrderedCollection new.
	[stream atEnd] whileFalse: [| s |
		s := stream upToAll: self.
		substrings add: s].
	^substrings
]

{ #category : #comparing }
CharacterArray >> stringHash [
	| hash |
	hash := self size.
	1
		to: hash
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self byteAt: i)].
	^hash
]

{ #category : #parsing }
CharacterArray >> upTo: aCharacter [
	| index |
	index := self findFirst: [:ch | ch = aCharacter] ifAbsent: [self size + 1].
	^self copyFrom: 1 to: index - 1
]

{ #category : #services }
CharacterArray >> withArticle [
	^self article , ' ' , self
]

