"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Character,
	#superclass : #Magnitude,
	#instVars : [
		'value'
	],
	#classVars : [
		'ByteCharacters'
	],
	#category : #Kernel
}

{ #category : #services }
Character class >> digitValue: anInteger [
	| n offset |
	n := anInteger asInteger.
	offset := n < 10 ifTrue: [48] ifFalse: [55].
	^self value: n + offset
]

{ #category : #initialization }
Character class >> initializeCharacters [
	ByteCharacters := (0 to: 255) collect: [:i | super new setValue: i]
]

{ #category : #'instance creation' }
Character class >> new [
	^self shouldNotImplement
]

{ #category : #'instance creation' }
Character class >> value: anInteger [
	^(anInteger >= 0 and: [anInteger + 1 <= ByteCharacters size])
		ifTrue: [ByteCharacters at: anInteger + 1]
		ifFalse: [Character basicNew setValue: anInteger]
]

{ #category : #arithmetic }
Character >> - aMagnitude [
	| subtraction |
	subtraction := aMagnitude isCharacter
		ifTrue: [aMagnitude asInteger]
		ifFalse: [aMagnitude].
	^value - subtraction
]

{ #category : #converting }
Character >> , characterOrString [
	^self asString , characterOrString asString
]

{ #category : #arithmetic }
Character >> + aMagnitude [
	| addend |
	addend := aMagnitude isCharacter
		ifTrue: [aMagnitude asInteger]
		ifFalse: [aMagnitude].
	^self class value: value + addend
]

{ #category : #comparing }
Character >> < aCharacter [
	^value < aCharacter codePoint
]

{ #category : #comparing }
Character >> <= aCharacter [
	^value <= aCharacter codePoint
]

{ #category : #comparing }
Character >> = aCharacter [
	^self class == aCharacter class and: [value = aCharacter codePoint]
]

{ #category : #comparing }
Character >> > aCharacter [
	^value > aCharacter codePoint
]

{ #category : #comparing }
Character >> >= aCharacter [
	^value >= aCharacter codePoint
]

{ #category : #converting }
Character >> asCharacter [
	^self
]

{ #category : #converting }
Character >> asInteger [
	^value
]

{ #category : #converting }
Character >> asString [
	^String with: self
]

{ #category : #comparing }
Character >> between: min and: max [
	^min codePoint <= value and: [value <= max codePoint]
]

{ #category : #accessing }
Character >> codePoint [
	^value
]

{ #category : #comparing }
Character >> hash [
	^value hash
]

{ #category : #testing }
Character >> isCharacter [
	^true
]

{ #category : #private }
Character >> setValue: anInteger [
	value := anInteger
]

{ #category : #copying }
Character >> shallowCopy [
	^self
]

