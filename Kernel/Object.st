"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Object,
	#superclass : #ProtoObject,
	#category : #Kernel
}

{ #category : #converting }
Object >> -> anObject [
	^Association key: self value: anObject
]

{ #category : #comparing }
Object >> != anObject [
	^(self = anObject) not
]

{ #category : #debugging }
Object >> ASSERT: aBoolean [
	aBoolean value ifFalse: [self error: 'assertion failed!'].
	^aBoolean
]

{ #category : #private }
Object >> at: anInteger [
	<primitive: At>
]

{ #category : #private }
Object >> at: anInteger put: anObject [
	<primitive: AtPut>
]

{ #category : #accessing }
Object >> byteAt: anInteger [
	^self basicAt: anInteger
]

{ #category : #accessing }
Object >> byteAt: anInteger put: byte [
	^self basicAt: anInteger put: byte
]

{ #category : #'instance behavior' }
Object >> changeClassTo: aClass [
	self class == aClass ifFalse: [self behavior: aClass instanceBehavior]
]

{ #category : #copying }
Object >> copy [
	^self shallowCopy postCopy
]

{ #category : #copying }
Object >> deepCopy [
	^self objectDeepCopy postCopy
]

{ #category : #evaluating }
Object >> evaluate [
	^self
]

{ #category : #evaluating }
Object >> evaluateWith: anObject [
	^self evaluateWithArguments: {anObject}
]

{ #category : #evaluating }
Object >> evaluateWith: arg1 with: arg2 [
	^self evaluateWithArguments: {arg1. arg2}
]

{ #category : #evaluating }
Object >> evaluateWithArguments: anArray [
	^self evaluate
]

{ #category : #testing }
Object >> hasClassBehavior [
	^self behavior == self class instanceBehavior
]

{ #category : #private }
Object >> hash: anInteger [
	self basicHash: anInteger
]

{ #category : #testing }
Object >> ifNil: aBlock ifNotNil: anotherBlock [
	^anotherBlock evaluateWith: self
]

{ #category : #testing }
Object >> ifNotNil: aBlock ifNil: anotherBlock [
	^aBlock evaluateWith: self
]

{ #category : #initialization }
Object >> initialize [
]

{ #category : #testing }
Object >> isArray [
	^false
]

{ #category : #testing }
Object >> isAssociation [
	^false
]

{ #category : #testing }
Object >> isBlock [
	^false
]

{ #category : #testing }
Object >> isClosure [
	^false
]

{ #category : #testing }
Object >> isBoolean [
	^false
]

{ #category : #testing }
Object >> isByteArray [
	^false
]

{ #category : #testing }
Object >> isCharacter [
	^false
]

{ #category : #testing }
Object >> isClass [
	^false
]

{ #category : #testing }
Object >> isClosure [
	^false
]

{ #category : #testing }
Object >> isCollection [
	^false
]

{ #category : #testing }
Object >> isCompiledMethod [
	^false
]

{ #category : #testing }
Object >> isDictionary [
	^false
]

{ #category : #testing }
Object >> isInteger [
	^false
]

{ #category : #testing }
Object >> isKindOf: aClass [
	^self class inheritsFrom: aClass
]

{ #category : #testing }
Object >> isMethodDictionary [
	^false
]

{ #category : #testing }
Object >> isNumber [
	^false
]

{ #category : #testing }
Object >> isList [
	^false
]

{ #category : #testing }
Object >> isSpecies [
	^false
]

{ #category : #testing }
Object >> isString [
	^false
]

{ #category : #testing }
Object >> isSymbol [
	^false
]

{ #category : #'instance behavior' }
Object >> methodFor: aSymbol [
	^self behavior findMethodFor: aSymbol
]

{ #category : #services }
Object >> methodFor: aSymbol in: aClass [
	^self behavior findMethodFor: aSymbol in: aClass
]

{ #category : #copying }
Object >> objectDeepCopy [
	| class ivars copy |
	class := self class.
	class instancesAreFixed
		ifTrue: [
			ivars := 0.
			copy := class basicNew]
		ifFalse: [
			ivars := self basicSize.
			copy := class basicNew: ivars].
	class instancesHavePointers
		ifTrue: [
			1 to: ivars + class instSize do: [:index | | ivar |
				ivar := self instVarAt: index.
				copy instVarAt: index put: ivar copy]]
		ifFalse: [
			1 to: ivars do: [:index | | byte |
				byte := self basicAt: index.
				copy basicAt: index put: byte]].
	^copy
]

{ #category : #copying }
Object >> objectShallowCopy [
	| copy class |
	class := self class.
	copy := class instancesAreArrayed
		ifTrue: [class basicNew: self basicSize]
		ifFalse: [class basicNew].
	self shallowCopyTo: copy.
	^copy
]

{ #category : #services }
Object >> perform: aSymbol with: firstObject with: secondObject [
	^self perform: aSymbol withArguments: {firstObject. secondObject}
]

{ #category : #services }
Object >> perform: aSymbol
with: arg1
with: arg2
with: arg3 [
	^self perform: aSymbol withArguments: {arg1. arg2. arg3}
]

{ #category : #copying }
Object >> postCopy [
	
]

{ #category : #printing }
Object >> printOn: aStream [
	aStream nextPutAll: self class name withArticle
]

{ #category : #'instance behavior' }
Object >> removeInstanceBehavior [
	self behavior: self class instanceBehavior
]

{ #category : #'instance behavior' }
Object >> removeMethods: aMethodDictionary [
	| behavior copy |
	self hasInstanceBehavior ifFalse: [^self].
	behavior := self behavior.
	copy := behavior copyWithout: aMethodDictionary.
	copy == behavior ifFalse: [self behavior: copy]
]

{ #category : #replacing }
Object >> replaceBytesBackwardFrom: stop
to: start
with: aCollection
startingAt: position [
	| i j |
	i := stop.
	j := position.
	[start <= i] whileTrue: [
		self byteAt: i put: (aCollection byteAt: j).
		i := i - 1.
		j := j - 1]
]

{ #category : #replacing }
Object >> replaceBytesForwardFrom: start
to: stop
with: aCollection
startingAt: position [
	| i j |
	i := start.
	j := position.
	[i <= stop] whileTrue: [
		self byteAt: i put: (aCollection byteAt: j).
		i := i + 1.
		j := j + 1]
]

{ #category : #replacing }
Object >> replaceBytesFrom: start
to: stop
with: aCollection
startingAt: position [
	| end |
	(self == aCollection and: [
		end := position + stop - start.
		start between: position and: end])
		ifTrue: [
			self
				replaceBytesBackwardFrom: stop
				to: start
				with: aCollection
				startingAt: end]
		ifFalse: [
			self
				replaceBytesForwardFrom: start
				to: stop
				with: aCollection
				startingAt: position]
]

{ #category : #services }
Object >> respondsTo: aSymbol [
	| cm |
	cm := self methodFor: aSymbol.
	^cm !== nil
]

{ #category : #copying }
Object >> shallowCopy [
	^self objectShallowCopy
]

{ #category : #copying }
Object >> shallowCopyTo: anObject [
	| n |
	self class isBytes ifTrue: [
		anObject class isBytes ifFalse: [self error: 'cannot copy'].
		n := self sizeInBytes min: anObject sizeInBytes.
		1 to: n do: [:i | | byte |
			byte := self byteAt: i.
			anObject byteAt: i put: byte].
		^anObject].
	anObject class isBytes ifTrue: [self error: 'cannot copy'].
	n := self class instSize min: anObject class instSize.
	1 to: n do: [:index | | slot |
		slot := self instVarAt: index.
		anObject instVarAt: index put: slot].
	self class instancesAreArrayed ifTrue: [
		n := self basicSize min: anObject basicSize.
		1 to: n do: [:index | | slot |
			slot := self basicAt: index.
			anObject basicAt: index put: slot]].
	^anObject
]

{ #category : #errors }
Object >> shouldNotImplement [
	self error: 'inappropriate message for this object'
]

{ #category : #accessing }
Object >> size [
	^self basicSize
]

{ #category : #private }
Object >> species [
	^self class
]

{ #category : #errors }
Object >> subclassResponsibility [
	^self error: 'subclass responsibility'
]

{ #category : #evaluating }
Object >> value [
	^self
]
