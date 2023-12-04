"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #SmallInteger,
	#superclass : #Integer,
	#classVars : [
		'Maximum',
		'Minimum'
	],
	#category : #Kernel
}

{ #category : #testing }
SmallInteger class >> canBeDeleted [
	^false
]

{ #category : #initialization }
SmallInteger class >> initializeConstants [
	Maximum := (1 bitShift: WordSize * 8 - 2) - 1.
	Minimum := Maximum negated - 1
]

{ #category : #constants }
SmallInteger class >> maximum [
	^Maximum
]

{ #category : #constants }
SmallInteger class >> minimum [
	^Minimum
]

{ #category : #arithmetic }
SmallInteger >> - aNumber [
	aNumber _isSmallInteger ifFalse: [^(aNumber - self) negated].	
	^(self _smiMinus: aNumber) ifNil: [self asLargeInteger - aNumber]
]

{ #category : #comparing }
SmallInteger >> != aNumber [
	^self == aNumber ifTrue: [false] ifFalse: [true]
]

{ #category : #arithmetic }
SmallInteger >> % aNumber [
	^self \\ aNumber
]

{ #category : #bits }
SmallInteger >> & anInteger [
	^self bitAnd: anInteger
]

{ #category : #arithmetic }
SmallInteger >> * aNumber [
	aNumber _isSmallInteger ifFalse: [^aNumber * self].
	^(self _smiTimes: aNumber) ifNil: [self asLargeInteger * aNumber]
]

{ #category : #arithmetic }
SmallInteger >> // aNumber [
	| result quotient answer |
	aNumber == 0 ifTrue: [^self zeroDivisorOn: #'//'].
	aNumber _isSmallInteger
		ifTrue: [
			result := self _quotientTowardZero: aNumber.
			^(self >= 0 = (aNumber >= 0) or: [result * aNumber = self])
				ifTrue: [result]
				ifFalse: [result - 1]]
		ifFalse: [
			aNumber isInteger
				ifTrue: [^self = 0 | (self positive = aNumber positive)
					ifTrue: [0]
					ifFalse: [-1]].
			quotient := self / aNumber.
			answer := quotient truncated.
			^(quotient < 0 and: [quotient ~= answer])
				ifTrue: [answer - 1]
				ifFalse: [answer]]
]

{ #category : #arithmetic }
SmallInteger >> \\ aNumber [
	aNumber == 0 ifTrue: [^self zeroDivisorOn: #'\\'].
	aNumber _isSmallInteger
		ifTrue: [^self _remainderTowardZero: aNumber]
		ifFalse: [
			aNumber isLargeInteger
				ifTrue: [aNumber positive == self positive ifTrue: [^self]].
			^super \\ aNumber]
]

{ #category : #underprimitives }
SmallInteger >> _isSmallInteger [
	^true
]

{ #category : #arithmetic }
SmallInteger >> | anInteger [
	^self bitOr: anInteger
]

{ #category : #arithmetic }
SmallInteger >> + aNumber [
	aNumber _isSmallInteger ifFalse: [^aNumber + self].
	^(self _smiPlus: aNumber) ifNil: [self asLargeInteger + aNumber].
]

{ #category : #arithmetic }
SmallInteger >> < aNumber [
	^aNumber _isSmallInteger
		ifTrue: [self _smiLowerThan: aNumber] 
		ifFalse: [aNumber > self]
]

{ #category : #comparing }
SmallInteger >> <= aNumber [
	^aNumber _isSmallInteger
		ifTrue: [self _smiLowerEqualThan: aNumber] 
		ifFalse: [aNumber >= self]
]

{ #category : #comparing }
SmallInteger >> = aNumber [
	^aNumber _isSmallInteger
		ifTrue: [self _smiEquals: aNumber] 
		ifFalse: [aNumber = self]
]

{ #category : #comparing }
SmallInteger >> > aNumber [
	^aNumber _isSmallInteger
		ifTrue: [self _smiGreaterThan: aNumber] 
		ifFalse: [aNumber < self]
]

{ #category : #comparing }
SmallInteger >> >= aNumber [
	^aNumber _isSmallInteger
		ifTrue: [self _smiGreaterEqualThan: aNumber] 
		ifFalse: [aNumber <= self]
]

{ #category : #accessing }
SmallInteger >> at: index put: anObject [
	^self shouldNotImplement
]

{ #category : #private }
SmallInteger >> basicHash [
	^self
]

{ #category : #'meta accessing' }
SmallInteger >> behavior: aBehavior [
	self shouldNotImplement
]

{ #category : #bits }
SmallInteger >> bitAnd: anInteger [
	anInteger _isSmallInteger ifFalse: [^anInteger bitAnd: self].
	^self _smiBitAnd: anInteger
]

{ #category : #bits }
SmallInteger >> bitAt: anInteger [
	anInteger < 1 ifTrue: [self error: 'non positive index'].
	self = 0 ifTrue: [^0].
	^super bitAt: anInteger
]

{ #category : #bits }
SmallInteger >> bitOr: anInteger [
	anInteger _isSmallInteger ifFalse: [^anInteger bitOr: self].
	^self _smiBitOr: anInteger
]

{ #category : #bits }
SmallInteger >> bitShift: anInteger [
	anInteger = 0 ifTrue: [^self].
	^anInteger > 0
		ifTrue: [self bitShiftLeft: anInteger]
		ifFalse: [self bitShiftRight: 0 - anInteger]
]

{ #category : #bits }
SmallInteger >> bitShiftLeft: anInteger [
	| result bits total bytes hi lo shift |
	anInteger < (WordSize * 8 - 1) ifTrue: [
		result := self _bitShiftLeft: anInteger.
		result ifNotNil: [^result]].
	^self error: 'too big'].
]

{ #category : #unclassified }
SmallInteger >> bitShiftRight: anInteger [
	^anInteger <= (WordSize * 8 - 2)
		ifTrue: [self _bitShiftRight: anInteger]
		ifFalse: [self >= 0 ifTrue: [0] ifFalse: [-1]]
]

{ #category : #bits }
SmallInteger >> bitXor: anInteger [
	anInteger _isSmallInteger ifFalse: [^anInteger bitXor: self].
	^self _smiBitXor: anInteger
]

{ #category : #accessing }
SmallInteger >> byteAt: anInteger [
	^self at: anInteger
]

{ #category : #accessing }
SmallInteger >> byteAt: anInteger put: byte [
	^self at: anInteger put: byte
]

{ #category : #arithmetic }
SmallInteger >> gcd: anInteger [
	| n m |
	n := self.
	m := anInteger.
	[n = 0] whileFalse: [n := m \\ (m := n)].
	^m abs
]

{ #category : #comparing }
SmallInteger >> hash [
	^self
]

{ #category : #private }
SmallInteger >> hashMultiply [
	^self hashMultiply: 16r19660D
]

{ #category : #private }
SmallInteger >> hashMultiply: aNumber [
	| low14a high14a low14b high14b |
	(self < 162 and: [aNumber == 16r19660D]) ifTrue: [^self * 16r19660D].
	low14a := self bitAnd: 16r3FFF.
	high14a := (self bitShift: -14) bitAnd: 16r3FFF.
	low14b := aNumber bitAnd: 16r3FFF.
	high14b := (aNumber bitShift: -14) bitAnd: 16r3FFF.
	^16r4000 * (low14b * high14a + (high14b * low14a) bitAnd: 16r3FFF)
		+ (low14b * low14a)
		bitAnd: 16rFFFFFFF
]

{ #category : #bits }
SmallInteger >> highBit [
	self < 0 ifTrue: [^self error: 'not valid for negative numbers'].
	^(WordSize _bitShiftLeft: 3) - self _leadingZeroBitCount
]

{ #category : #accessing }
SmallInteger >> highDigit [
	| n b |
	n := self sizeInBytes.
	b := self at: n.
	b = 0 ifTrue: [^self at: n - 1].
	^b
]

{ #category : #testing }
SmallInteger >> isSmallInteger [
	^true
]

{ #category : #unclassified }
SmallInteger >> negated [
	self = Minimum ifTrue: [^Maximum + 1].
	^super negated
]

{ #category : #unclassified }
SmallInteger >> printString [
        | result abs digitValue char|

        self = 0 ifTrue: [^ '0'].

        result := ''.

        abs := self abs.
        [abs > 0] whileTrue: [
            digitValue := abs \\ 10.
			char := String new: 1.
			char byteAt: 1 put: digitValue + 48.
            result := char, result.
            abs := abs // 10.
        ].

        self < 0 ifTrue: [
            result := '-', result.
        ].

        ^ result.
]

{ #category : #arithmetic }
SmallInteger >> quo: aNumber [
	| result |
	aNumber == 0 ifTrue: [^self zeroDivisorOn: #quo:].
	aNumber _isSmallInteger
		ifTrue: [^self _quotientTowardZero: aNumber]
		ifFalse: [
			result := self abs // aNumber abs.
			^self sign == aNumber sign ifTrue: [result] ifFalse: [0 - result]]
]

{ #category : #arithmetic }
SmallInteger >> quoRem1: anInteger [
	^{self // anInteger. self \\ anInteger}
]

{ #category : #arithmetic }
SmallInteger >> rem: aNumber [
	^super rem: aNumber
]

{ #category : #accessing }
SmallInteger >> sizeInBytes [
	^self = 0
		ifTrue: [1]
		ifFalse: [WordSize - (self _leadingZeroBitCount _bitShiftRight: 3)]
]
