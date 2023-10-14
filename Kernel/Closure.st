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
		'Indexes'
	],
	#category : #Kernel
}

{ #category : #initialization }
Closure class >> initializeIndexes [
	Indexes := self addNamespace
		at: 'ReceiverIndex' put: 1;
		at: 'ParentEnvironmentIndex' put: 2;
		yourself
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
Closure >> arityError: anInteger [
	| arity msg count |
	arity := block argumentCount.
	count := anInteger = 0 ifTrue: ['none'] ifFalse: [anInteger asString].
	msg := 'The ' , self class name , ' expects ' , arity printString
		, (' argument' pluralize: arity > 1)
		, ', but was called with '
		, count.
	^self error: msg
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

{ #category : #converting }
Closure >> canReturn [
	| env |
	homeFrame == nil ifTrue: [^false].
	homeFrame stackPointer < self _thisContext ifTrue: [^false].
	homeFrame hasBlocks ifFalse: [^false].
	env := self methodEnvironment.
	homeFrame environment == env ifTrue: [^true].
	^homeFrame methodEnvironment == env
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
Closure >> evaluateAtomically [
	self errorVMSpecific
]

{ #category : #handling }
Closure >> evaluateFor: anObject [
	^self value: anObject
]

{ #category : #handling }
Closure >> evaluateWith: value [
	self errorVMSpecific
]

{ #category : #handling }
Closure >> evaluateWith: anObject with: anotherObject [
	self errorVMSpecific
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
Closure >> fork [
	^self newProcess fork
]

{ #category : #handling }
Closure >> forkAt: aNumber [
	^self forkAt: aNumber named: 'forked from block'
]

{ #category : #handling }
Closure >> forkAt: aNumber named: aString [
	^self newProcess name: aString; priority: aNumber; fork
]

{ #category : #handling }
Closure >> forkNamed: aString [
	^self forkAt: Processor activePriority named: aString
]

{ #category : #handling }
Closure >> forkThread [
	^Thread newOn: self
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

{ #category : #handling }
Closure >> newProcessWith: anArray [
	| message |
	message := MessageSend
		receiver: self
		selector: #valueWithArguments:
		argument: anArray.
	^Process evaluating: message
]

{ #category : #accessing }
Closure >> numArgs [
	^self argumentCount
]


{ #category : #handling }
Closure >> printOn: aStream [
	self class printOn: aStream.
	aStream nextPut: $(.
	block basicPrintOn: aStream.
	(1 to: self size)
		do: [:i | | field |
			field := self at: i.
			field printOn: aStream]
		separatedBy: [aStream space].
	aStream nextPut: $)
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
	<primitive: Value>
]

{ #category : #handling }
Closure >> value: value [
	<primitive: ValueWith>
]

{ #category : #handling }
Closure >> value: first value: second [
	<primitive: ValueWithWith>
]

{ #category : #handling }
Closure >> value: first value: second value: third [
	<primitive: ValueWithWithWith>
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
	<primitive: ValueWithArguments>

]

{ #category : #handling }
Closure >> whileFalse [
	^[self value] whileFalse: []
]

{ #category : #handling }
Closure >> whileFalse: aBlock [
	<primitive: WhileFalse>

]

{ #category : #handling }
Closure >> whileTrue [
	^[self value] whileTrue: []
]

{ #category : #handling }
Closure >> whileTrue: aBlock [
	<primitive: WhileTrue>
]

