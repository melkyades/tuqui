"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    Copyright (c) 2020, Labware.
    See (MIT) license in root directory.
"

Class {
	#name : #CompiledMethod,
	#superclass : #Array,
	#type : #variable,
	#instVars : [
		'format',
		'executableCode',
		'treecodes',
		'class',
		'selector',
		'source'
	],
	#classVars : [
		'ArgCount',
		'BlockCount',
		'TempCount',
		'CapturesSelf',
		'HasEnvironment',
		'HasFrame',
		'Debuggable',
		'EnvCount'
	],
	#category : #Kernel
}

{ #category : #initialization }
CompiledMethod class >> initializeFormatFlags [
	ArgCount := (1 thru: 6).
	BlockCount := (7 thru: 13).
	TempCount := (14 thru: 21).
	CapturesSelf := (1 bitShift: 22 - 1).
	HasEnvironment := (1 bitShift: 23 - 1).
	HasFrame := (1 bitShift: 24 - 1).
	Debuggable := (1 bitShift: 25 - 1).
	EnvCount := (26 thru: 31)
]

{ #category : #initialization }
CompiledMethod class >> maxArgCount [
	^(2 raisedTo: ArgCount length) - 1
]

{ #category : #initialization }
CompiledMethod class >> maxBlockCount [
	^(2 raisedTo: BlockCount length) - 1
]

{ #category : #initialization }
CompiledMethod class >> maxTempCount [
	^(2 raisedTo: TempCount length) - 1
]

{ #category : #'instance creation' }
CompiledMethod class >> new: anInteger [
	| cm |
	cm := super new: anInteger.
	^cm initialize
]

{ #category : #comparing }
CompiledMethod >> = anObject [
	^self == anObject
]

{ #category : #queries }
CompiledMethod >> addSymbolsIn: anArray to: aSet [
	anArray do: [:elem | 
		elem isSymbol
			ifTrue: [aSet add: elem]
			ifFalse: [elem class == Array ifTrue: [self addSymbolsIn: elem to: aSet]]]
]

{ #category : #accessing }
CompiledMethod >> argumentCount [
	^format bitsAt: ArgCount
]

{ #category : #accessing }
CompiledMethod >> argumentCount: anInteger [
	format := format bitsAt: ArgCount put: anInteger
]

{ #category : #converting }
CompiledMethod >> asOverridden [
	^self
]

{ #category : #accessing }
CompiledMethod >> blockCount [
	^format bitsAt: BlockCount
]

{ #category : #accessing }
CompiledMethod >> blockCount: anInteger [
	format := format bitsAt: BlockCount put: anInteger
]

{ #category : #enumerating }
CompiledMethod >> blocks [
	self hasBlocks ifFalse: [^#()].
	^self select: [:literal | literal isBlock]
]

{ #category : #enumerating }
CompiledMethod >> blocksDo: aBlock [
	self
		select: [:b | b isBlock and: [b method == self]]
		thenDo: [:b | aBlock evaluateWith: b]
]

{ #category : #accessing }
CompiledMethod >> treecodes [
	^treecodes
]

{ #category : #accessing }
CompiledMethod >> treecodes: aByteArray [
	treecodes := aByteArray
]

{ #category : #testing }
CompiledMethod >> canBeInstalled [
	^self isExpression not
]

{ #category : #accessing }
CompiledMethod >> classBinding [
	^class
]

{ #category : #accessing }
CompiledMethod >> classBinding: aClass [
	class := aClass
]

{ #category : #queries }
CompiledMethod >> currentVersion [
	^class compiledMethodAt: selector
]

{ #category : #accessing }
CompiledMethod >> environmentCount [
	^format bitsAt: EnvCount
]

{ #category : #accessing }
CompiledMethod >> environmentCount: anInteger [
	format bitsAt: EnvCount put: anInteger
]

{ #category : #accessing }
CompiledMethod >> executableCode [
	^executableCode
]

{ #category : #services }
CompiledMethod >> flushFromCaches [
	<primitive: FlushMethod>
]

{ #category : #accessing }
CompiledMethod >> format [
	^format
]

{ #category : #accessing }
CompiledMethod >> format: anInteger [
	format := anInteger
]

{ #category : #testing }
CompiledMethod >> hasBlocks [
	^self blockCount > 0
]

{ #category : #services }
CompiledMethod >> hasEnvironment [
	^self environmentCount > 0
]

{ #category : #comparing }
CompiledMethod >> hash [
	^selector hashWith: class
]

{ #category : #accessing }
CompiledMethod >> hasExecutableCode [
	^executableCode != nil
]

{ #category : #initialization }
CompiledMethod >> initialize [
	super initialize.
	format := 0
]

{ #category : #actions }
CompiledMethod >> install [
	class addSelector: selector withMethod: self
]

{ #category : #accessing }
CompiledMethod >> invalidateExecutableCode [
	executableCode := nil.
	self blocksDo: [:b | b invalidateExecutableCode]
]

{ #category : #testing }
CompiledMethod >> isCompiledMethod [
	^true
]

{ #category : #testing }
CompiledMethod >> isCurrentVersion [
	^class notNil and: [self == (class compiledMethodAt: selector)]
]

{ #category : #testing }
CompiledMethod >> isDebuggable [
	^format isOnBit: Debuggable
]

{ #category : #accessing }
CompiledMethod >> isDoit [
	^false
]

{ #category : #testing }
CompiledMethod >> isExpression [
	^false
]

{ #category : #testing }
CompiledMethod >> isFFIMethod [
	^false
]

{ #category : #unclassified }
CompiledMethod >> isNativized [
	^executableCode !== notNil
]

{ #category : #testing }
CompiledMethod >> isOverridden [
	^false
]

{ #category : #accessing }
CompiledMethod >> literals [
	^Array withAll: self
]

{ #category : #accessing }
CompiledMethod >> method [
	^self
]

{ #category : #accessing }
CompiledMethod >> executableCode [
	^executableCode
]

{ #category : #accessing }
CompiledMethod >> executableCode: anObject [
	code method: self.
	executableCode := anObject
]

{ #category : #accessing }
CompiledMethod >> executableCodeAddress [
	self prepareForExecution.
	^executableCode executableCodeAddress
]

{ #category : #copying }
CompiledMethod >> postCopy [
	super postCopy.
	self
		withIndexDo: [:b :i | | c |
			b isBlock ifTrue: [
				c := b copy method: self.
				self at: i put: c]];
		updateExecutableCode
]

{ #category : #unclassified }
CompiledMethod >> prepareForExecution [
	self isNativized ifFalse: [Kernel prepareForExecution: self].
]

{ #category : #accessing }
CompiledMethod >> primitiveNumber [
	^0
]

{ #category : #printing }
CompiledMethod >> printString [
	class printString, '>>', selector
]

{ #category : #accessing }
CompiledMethod >> selector [
	^selector
]

{ #category : #accessing }
CompiledMethod >> selector: aSymbol [
	selector := aSymbol.
	executableCode notNil ifTrue: [self invalidateExecutableCode; nativize]
]

{ #category : #accessing }
CompiledMethod >> selectorAt: index [
	^self at: self size - index + 1
]

{ #category : #accessing }
CompiledMethod >> sendSites [
	^executableCode sendSites
]

{ #category : #'source code support' }
CompiledMethod >> sourceObject [
	^source
]

{ #category : #'source code support' }
CompiledMethod >> sourceObject: aString [
	source := aString
]

{ #category : #accessing }
CompiledMethod >> tempCount [
	^format bitsAt: TempCount
]

{ #category : #accessing }
CompiledMethod >> tempCount: anInteger [
	format := format bitsAt: TempCount put: anInteger
]

{ #category : #accessing }
CompiledMethod >> updateExecutableCode [
	executableCode ifNil: [^self].
	self invalidateExecutableCode; prepareForExecution
]

