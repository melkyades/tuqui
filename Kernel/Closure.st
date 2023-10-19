"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Closure,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'block',
		'homeFrame'
	],
	#classVars : [
		'ReceiverIndex ParentEnvironmentIndex'
	],
	#category : #Kernel
}

{ #category : #initialization }
Closure class >> initializeIndexes [
	ReceiverIndex := 1.
	ParentEnvironmentIndex := 2
]

{ #category : #gs }
Closure class >> newFrom: aBlock [
	| size closure |
	size := aBlock environmentCount + self instSize.
	closure := self new: size.
	closure basicAt: 1 put: aBlock.
	^closure
]

{ #category : #private }
Closure class >> receiverIndex [
	^ReceiverIndex
]

{ #category : #accessing }
Closure >> argumentCount [
	^block argumentCount
]

{ #category : #accessing }
Closure >> arity [
	^block arity
]

{ #category : #errors }
Closure >> basicAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self outOfBoundsIndex: anInteger].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _basicAt: anInteger
]

{ #category : #private }
Closure >> block [
	^block
]

{ #category : #accessing }
Closure >> blockNumber [
	^block blockNumber
]

{ #category : #evaluating }
Closure >> cull: a cull: b [
	^self argumentCount < 2
		ifTrue: [self cull: a]
		ifFalse: [self value: a value: b]
]

{ #category : #services }
Closure >> do: aClosure [
	1 to: self size do: [:index | | slot |
		slot := self at: index.
		aClosure value: slot]
]

{ #category : #handling }
Closure >> evaluate [
	^self value
]

{ #category : #handling }
Closure >> evaluateFor: anObject [
	^self value: anObject
]

{ #category : #handling }
Closure >> evaluateWith: value [
	<primitive: ClosureValueWith>
]

{ #category : #handling }
Closure >> evaluateWith: anObject with: anotherObject [
	<primitive: ClosureValueWithWith>
]

{ #category : #evaluating }
Closure >> evaluateWithArguments: anArray [
	| n args |
	n := self argumentCount.
	n = 0 ifTrue: [^self value].
	args := anArray size > n
		ifTrue: [anArray copyFrom: 1 to: n]
		ifFalse: [anArray].
	^self valueWithArguments: args
]

{ #category : #handling }
Closure >> hasMethodEnvironment [
	^self size >= ParentEnvironmentIndex
]

{ #category : #testing }
Closure >> isClosure [
	^true
]

{ #category : #handling }
Closure >> method [
	^block method
]

{ #category : #accessing }
Closure >> method: aCompiledMethod [
	block := aCompiledMethod at: block templateIndex
]

{ #category : #handling }
Closure >> methodEnvironment [
	^self at: ParentEnvironmentIndex
]

{ #category : #handling }
Closure >> methodEnvironment: environment [
	self at: ParentEnvironmentIndex put: environment
]

{ #category : #accessing }
Closure >> methodFrame [
	^homeFrame methodFrame
]

{ #category : #handling }
Closure >> needsArgument [
	^self argumentCount > 0
]

{ #category : #handling }
Closure >> newProcess [
	^Process sending: #value to: self
]

{ #category : #accessing }
Closure >> numArgs [
	^self argumentCount
]

{ #category : #handling }
Closure >> receiver [
	^self at: ReceiverIndex
]

{ #category : #handling }
Closure >> receiver: anObject [
	self at: ReceiverIndex put: anObject
]

{ #category : #handling }
Closure >> repeat [
	[true] whileTrue: [self value]
]

{ #category : #handling }
Closure >> repeatUntil: aBlock [
	[
		self value.
		aBlock value] whileFalse
]

{ #category : #accessing }
Closure >> tempCount [
	^block tempCount
]

{ #category : #accessing }
Closure >> templateIndex [
	^block templateIndex
]

{ #category : #handling }
Closure >> value [
	<primitive: ClosureValue>
]

{ #category : #handling }
Closure >> value: value [
	<primitive: ClosureValueWith>
]

{ #category : #handling }
Closure >> value: first value: second [
	<primitive: ClosureValueWithWith>
]

{ #category : #handling }
Closure >> value: first value: second value: third [
	<primitive: ClosureValueWithWithWith>
]

{ #category : #evaluating }
Closure >> value: arg1
value: arg2
value: arg3
value: arg4 [
	^self valueWithArguments: {arg1. arg2. arg3. arg4}
]

{ #category : #evaluating }
Closure >> valueSelector [
	^block valueSelector
]

{ #category : #handling }
Closure >> valueWithArguments: arguments [
	<primitive: ClosureValueWithArguments>

]

{ #category : #handling }
Closure >> whileFalse [
	^[self value] whileFalse: []
]

{ #category : #handling }
Closure >> whileFalse: aBlock [
	<primitive: ClosureWhileFalse>

]

{ #category : #handling }
Closure >> whileTrue [
	^[self value] whileTrue: []
]

{ #category : #handling }
Closure >> whileTrue: aBlock [
	<primitive: ClosureWhileTrue>
]

