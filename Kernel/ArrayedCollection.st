"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ArrayedCollection,
	#superclass : #SequenceableCollection,
	#category : #Kernel
}

{ #category : #'instance creation' }
ArrayedCollection class >> with: anObject [
	| array |
	array := self new: 1.
	array at: 1 put: anObject.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: firstObject with: secondObject [
	| array |
	array := self new: 2.
	array
		at: 1 put: firstObject;
		at: 2 put: secondObject.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: firstObject with: secondObject with: thirdObject [
	| array |
	array := self new: 3.
	array
		at: 1 put: firstObject;
		at: 2 put: secondObject;
		at: 3 put: thirdObject.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: firstObject
with: secondObject
with: thirdObject
with: fourthObject [
	| array |
	array := self new: 4.
	array
		at: 1 put: firstObject;
		at: 2 put: secondObject;
		at: 3 put: thirdObject;
		at: 4 put: fourthObject.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: anObject withAll: aCollection [
	| array |
	array := self new: aCollection size + 1.
	array
		at: 1 put: anObject;
		replaceFrom: 2 to: array size with: aCollection.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> withAll: aCollection with: anObject [
	| instance |
	instance := self new: aCollection size + 1.
	instance
		replaceFrom: 1 to: instance size - 1 with: aCollection;
		at: instance size put: anObject.
	^instance
]

{ #category : #adding }
ArrayedCollection >> add: anObject [
	^self shouldNotImplement
]

{ #category : #enumerating }
ArrayedCollection >> collect: aBlock [
	| array size |
	size := self size.
	array := self species new: size.
	1
		to: size
		do: [:index | array at: index put: (aBlock evaluateWith: (self at: index))].
	^array
]

{ #category : #enumerating }
ArrayedCollection >> collect: collectBlock thenSelect: selectBlock [
	| array size |
	array := OrderedCollection new: self size.
	self do: [:x | | fx |
		fx := collectBlock evaluateWith: x.
		(selectBlock evaluateWith: fx) ifTrue: [array add: fx]].
	size := array size.
	^(self species new: size) replaceFrom: 1 to: size with: array
]

{ #category : #services }
ArrayedCollection >> concurrentCollect: aBlock [
	| answer size token |
	size := self size.
	token := Object new.
	answer := self species new: size.
	answer atAllPut: token.
	1
		to: size
		do: [:index | [| x y |
			x := self at: index.
			y := aBlock evaluateWith: x.
			answer at: index put: y] forkThread launch].
	[answer includes: token] whileTrue: [].
	^answer
]

{ #category : #copying }
ArrayedCollection >> copyReplaceFrom: start to: stop with: aCollection [
	| copy n size |
	n := aCollection size.
	size := self size + n - (stop - start + 1).
	copy := self species new: size.
	^copy
		replaceFrom: 1 to: start - 1 with: self startingAt: 1;
		replaceFrom: start to: start + n - 1 with: aCollection;
		replaceFrom: start + n to: size with: self startingAt: stop + 1
]

{ #category : #copying }
ArrayedCollection >> deepCopy [
	^self objectDeepCopy
]

{ #category : #marshalling }
ByteArray >> largeAtOffset: offset [
	| integer lo hi |
	(self at: offset + 8) >= 16r80 ifTrue: [
		integer := 0.
		offset + 8
			to: offset + 1
			by: -1
			do: [:i | integer := (integer bitShift: 8) + ((self at: i) bitXor: 16rFF)].
		^(integer + 1) negated].
	lo := self uLongAtOffset: 0.
	hi := self uLongAtOffset: 4.
	^(hi bitShift: 32) + lo
]

{ #category : #removing }
ArrayedCollection >> remove: anObject ifAbsent: aBlock [
	^self shouldNotImplement
]

{ #category : #accessing }
ArrayedCollection >> reversed [
	| limit result |
	limit := self size + 1.
	result := self species new: limit - 1.
	1 to: limit - 1 do: [:i | result at: i put: (self at: limit - i)].
	^result
]

{ #category : #enumerating }
ArrayedCollection >> select: aBlock [
	| size selected |
	size := self size.
	selected := OrderedCollection new: size.
	1 to: size do: [:i | | element |
		element := self at: i.
		(aBlock evaluateWith: element) ifTrue: [selected add: element]].
	size := selected size.
	^(self species new: size) replaceFrom: 1 to: size with: selected
]

{ #category : #enumerating }
ArrayedCollection >> select: selectBlock thenCollect: collectBlock [
	| size selected |
	size := self size.
	selected := OrderedCollection new: size.
	1 to: size do: [:i | | element |
		element := self at: i.
		(selectBlock evaluateWith: element)
			ifTrue: [selected add: (collectBlock evaluateWith: element)]].
	size := selected size.
	^(self species new: size) replaceFrom: 1 to: size with: selected
]

{ #category : #accessing }
ArrayedCollection >> size [
	^self _size
]

{ #category : #enumerating }
ArrayedCollection >> withIndexCollect: aBlock [
	| answer size |
	size := self size.
	answer := self class new: size.
	1 to: size do: [:index |
		answer at: index put: (aBlock value: (self at: index) value: index)].
	^answer
]

