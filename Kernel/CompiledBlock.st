"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    Copyright (c) 2020, Labware. 
    See (MIT) license in root directory.
"

Class {
	#name : #CompiledBlock,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'format',
		'executableCode',
		'method'
	],
	#classVars : [
		'ArgCount',
		'TempCount',
		'Id',
		'CapturesSelf',
		'CapturesHome',
		'EnvCount'
	],
	#category : #Kernel
}

{ #category : #initialization }
CompiledBlock class >> ensureFormatCorrectness [
	self
		ASSERT: Id end <= SmallInteger maximum;
		ASSERT: ArgCount end <= SmallInteger maximum;
		ASSERT: TempCount end <= SmallInteger maximum;
		DENY: (Id intersects: ArgCount);
		DENY: (Id intersects: TempCount);
		DENY: (ArgCount intersects: TempCount)
]

{ #category : #'instance creation' }
CompiledBlock class >> fromArray: anArray [
	| block |
	block := self new: anArray size - 2.
	^block loadFrom: anArray
]

{ #category : #initialization }
CompiledBlock class >> initializeClassVars [

	ArgCount := (1 thru: 6).
	TempCount := (7 thru: 14).
	Id := (15 thru: 22).
	CapturesSelf := (1 bitShift: 23 - 1).
	CapturesHome := (1 bitShift: 24 - 1).
	EnvCount := (25 thru: 31).
]

{ #category : #initialization }
CompiledBlock class >> maxArgCount [
	^(2 raisedTo: ArgCount length) - 1
]

{ #category : #initialization }
CompiledBlock class >> maxTempCount [
	^(2 raisedTo: TempCount length) - 1
]

{ #category : #accessing }
CompiledBlock >> argumentCount [
	^format bitsAt: ArgCount
]

{ #category : #accessing }
CompiledBlock >> argumentCount: anInteger [
	format := format bitsAt: ArgCount put: anInteger
]

{ #category : #accessing }
CompiledBlock >> arity [
	^self argumentCount
]

{ #category : #accessing }
CompiledBlock >> bindMethod: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #accessing }
CompiledBlock >> blockCode [
	^executableCode code
]

{ #category : #accessing }
CompiledBlock >> blockExecutableCode [
	"
	required to let the optimizing compiler inline this code
	without confusing with CompiledMethod>>#executableCode
	"
	^executableCode
]

{ #category : #accessing }
CompiledBlock >> blockExecutableCode [
	"
	required to let the optimizing compiler inline this code
	without confusing with CompiledMethod>>#executableCode
	"
	^executableCode
]

{ #category : #accessing }
CompiledBlock >> blockNumber [
	^format bitsAt: Id
]

{ #category : #accessing }
CompiledBlock >> blockNumber: anInteger [
	format := format bitsAt: Id put: anInteger
]

{ #category : #accessing }
CompiledBlock >> environmentCount [
	^format bitsAt: EnvCount
]

{ #category : #accessing }
CompiledBlock >> format [
	^format
]

{ #category : #accessing }
CompiledBlock >> format: anInteger [
	format := anInteger
]

{ #category : #testing }
CompiledBlock >> hasMethodEnvironment [
	^self size >= 2 and: [(self at: 2) notNil]
]

{ #category : #comparing }
CompiledBlock >> hasReceiver [
	| index |
	index := Closure receiverIndex.
	^self size >= index andNot: [(self at: index) isNil]
]

{ #category : #accessing }
CompiledBlock >> initialize [
	super initialize.
	format := 0
]

{ #category : #accessing }
CompiledBlock >> invalidateExecutableCode [
	executableCode := nil
]

{ #category : #testing }
CompiledBlock >> isBlock [
	^true
]

{ #category : #testing }
CompiledBlock >> isCallback [
	^method isCallback
]

{ #category : #testing }
CompiledBlock >> isDebuggable [
	^method isDebuggable
]

{ #category : #comparing }
CompiledBlock >> loadFrom: anArray [
	method := anArray at: 1.
	format := anArray at: 2.
	3 to: anArray size do: [:i | | ai |
		ai := anArray at: i.
		self at: i - 2 put: ai]
]

{ #category : #private }
CompiledBlock >> maxArity [
	^(1 bitShift: ArgCount length) - 1
]

{ #category : #private }
CompiledBlock >> maxBlockNumber [
	^(1 bitShift: Id length) - 1
]

{ #category : #accessing }
CompiledBlock >> method [
	^method
]

{ #category : #accessing }
CompiledBlock >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #services }
CompiledBlock >> newClosure [
	^Closure newFrom: self
]

{ #category : #comparing }
CompiledBlock >> executableCode [
	^executableCode
]

{ #category : #comparing }
CompiledBlock >> executableCode: anObject [
	anObject block: self.
	executableCode := anObject
]

{ #category : #accessing }
CompiledBlock >> tempCount [
	^format bitsAt: TempCount
]

{ #category : #accessing }
CompiledBlock >> tempCount: anInteger [
	format := format bitsAt: TempCount put: anInteger
]

{ #category : #accessing }
CompiledBlock >> templateIndex [
	| n |
	n := self blockNumber.
	^method literals
		findFirst: [:literal | literal isBlock and: [literal blockNumber = n]]
		ifAbsent: [self ASSERT: false]
]

{ #category : #private }
CompiledBlock >> temporaryLimit [
	^(1 bitShift: TempCount length) - 1
]
