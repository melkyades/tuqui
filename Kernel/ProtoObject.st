"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ProtoObject,
	#superclass : nil,
	#category : #Kernel
}

{ #category : #'instance creation' }
ProtoObject class >> new [
	^self basicNew initialize
]

{ #category : #comparing }
ProtoObject >> !== anObject [
	^self == anObject ifTrue: [false] ifFalse: [true]
]

{ #category : #comparing }
ProtoObject >> = other [
	^self == other
]

{ #category : #comparing }
ProtoObject >> == other [
	<primitive: Equal>
]

{ #category : #accessing }
ProtoObject >> basicAt: anInteger [
	<primitive: BasicAt>
]

{ #category : #private }
ProtoObject >> basicAt: anInteger put: anObject [
	<primitive: BasicAtPut>
]

{ #category : #system }
ProtoObject >> basicHash [
	<primitive: Hash>
]

{ #category : #system }
ProtoObject >> basicHash: anInteger [
	<primitive: BasicHashPut>
]

{ #category : #private }
ProtoObject >> basicSize [
	<primitive: BasicSize>
]

{ #category : #services }
ProtoObject >> become: anotherObject [
	<primitive: Become>
]

{ #category : #'meta accessing' }
ProtoObject >> behavior [
	<primitive: Behavior>
]

{ #category : #'meta accessing' }
ProtoObject >> behavior: aBehavior [
	<primitive: SetBehavior>
]

{ #category : #system }
ProtoObject >> class [
	^self behavior classBinding
]

{ #category : #system }
ProtoObject >> doesNotUnderstand: aMessage [
	self
		error: 'Message #' , aMessage selector , ' not understood by: '
			, aMessage receiver printString
			, ' with: ('
			, stream contents
			, ')'.
	self _halt
]

{ #category : #errors }
ProtoObject >> error: aString [
	<primitive: Error>
]

{ #category : #system }
ProtoObject >> halt [
	<primitive: Halt>
]

{ #category : #accessing }
ProtoObject >> hash [
	^self basicHash
]

{ #category : #testing }
ProtoObject >> hasIndexedSlots [
	^self class instancesAreArrayed
]

{ #category : #comparing }
ProtoObject >> identityHash [
	^self basicHash
]

{ #category : #services }
ProtoObject >> ifNil: aBlock [
	^self
]

{ #category : #services }
ProtoObject >> ifNotNil: aBlock [
	^aBlock argumentCount = 1
		ifTrue: [aBlock evaluateWith: self]
		ifFalse: [aBlock evaluate]
]

{ #category : #system }
ProtoObject >> instVarAt: i [
	<primitive: InstVarAt>
]

{ #category : #system }
ProtoObject >> instVarAt: i put: anObject [
	<primitive: InstVarAtPut>
]

{ #category : #system }
ProtoObject >> isNil [
	^false
]

{ #category : #system }
ProtoObject >> notNil [
	^true
]

{ #category : #system }
ProtoObject >> perform: aSymbol [
	<primitive: Perform>
]

{ #category : #system }
ProtoObject >> perform: aSymbol with: anObject [
	^self perform: aSymbol withArguments: {anObject}
]

{ #category : #system }
ProtoObject >> perform: aSymbol withArguments: anArray [
	<primitive: PerformWithArguments>
]

{ #category : #system }
ProtoObject >> yourself [
	^self
]

