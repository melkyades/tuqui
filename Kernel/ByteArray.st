"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ByteArray,
	#superclass : #ArrayedCollection,
	#type : #bytes,
	#category : #Kernel
}

{ #category : #converting }
ByteArray >> asByteArray [
	^self
]

{ #category : #converting }
ByteArray >> asString [
	| string n |
	n := self size.
	(n > 0 and: [(self at: n) = 0]) ifTrue: [n := n - 1].
	string := String new: n.
	^string replaceBytesFrom: 1 to: n with: self startingAt: 1
]

{ #category : #comparing }
ByteArray >> hash [
	| hash |
	hash := self size.
	1
		to: hash
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self at: i)].
	^hash
]

{ #category : #testing }
ByteArray >> isByteArray [
	^true
]

{ #category : #replacing }
ByteArray >> replaceBytesUpTo: count with: aCollection [
	^self replaceBytesFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #replacing }
ByteArray >> replaceFirst: count with: aCollection [
	^self replaceFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #replacing }
ByteArray >> replaceFrom: start to: stop with: aCollection [
	stop - start + 1 <= aCollection sizeInBytes
		ifFalse: [^self error: 'replacement collection has the wrong size'].
	self
		replaceFrom: start
		to: stop
		with: aCollection
		startingAt: 1
]

{ #category : #replacing }
ByteArray >> replaceFrom: start
to: stop
with: collection
startingAt: position [
	collection class isBytes ifTrue: [
		^self replaceBytesFrom: start to: stop with: collection startingAt: position].
	super replaceFrom: start to: stop with: collection startingAt: position
]

{ #category : #accessing }
ByteArray >> sizeInBytes [
	^self size
]
