"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Integer,
	#superclass : #Number,
	#category : #Kernel
}

{ #category : #inspecting }
Integer class >> aspects [
	^#(#hex #bin #oct)
]

{ #category : #arithmetic }
Integer >> / aNumber [
	| gcd |
	aNumber isInteger ifFalse: [^aNumber reciprocal * self].
	gcd := self gcd: aNumber.
	^gcd = aNumber abs
		ifTrue: [self // aNumber]
		ifFalse: [self error: 'fraction result']
]

{ #category : #bits }
Integer >> << bits [
	bits < 0 ifTrue: [self error: 'negative arg'].
	^self bitShift: bits
]

{ #category : #bits }
Integer >> >> bits [
	bits < 0 ifTrue: [self error: 'negative arg'].
	^self bitShift: 0 - bits
]

{ #category : #arithmetic }
Integer >> alignedTo: anInteger [
	^self + anInteger - 1 // anInteger * anInteger
]

{ #category : #testing }
Integer >> anyMask: bits [
	^(self bitAnd: bits) != 0
]

{ #category : #converting }
Integer >> asBoolean [
	^self != 0
]

{ #category : #converting }
Integer >> asCharacter [
	^Character value: self
]


{ #category : #arithmetic }
Integer >> benchFibonacci [
	"
	Handy send-heavy benchmark
	(result // seconds to run) = approx calls per second
	| r t |
	t := Time millisecondsToRun: [r := 26 benchFib].
	(r * 1000) // t
	138000 on a Mac 8100/100
	"
	^self < 2
		ifTrue: [1]
		ifFalse: [(self - 1) benchFibonacci + (self - 2) benchFibonacci + 1]
]

{ #category : #benchmarking }
Integer >> benchSieve [
	"
	Bytecode heavy benchmark
	(500000 // time to run) = approx bytecodes per second
	5000000 // (Time millisecondsToRun: [10 benchSieve]) * 1000
	3059000 on a Mac 8100/100
	"
	| size flags prime k count |
	size := 8190.
	1 to: self do: [:iter |
		count := 0.
		flags := (Array new: size) atAllPut: true.
		1 to: size do: [:i |
			(flags at: i) ifTrue: [
				prime := i + 1.
				k := i + prime.
				[k <= size] whileTrue: [
					flags at: k put: false.
					k := k + prime].
				count := count + 1]]].
	^count
]

{ #category : #bits }
Integer >> bitAt: anInteger [
	^self >= 0
		ifTrue: [1 bitAnd: (self bitShift: 1 - anInteger)]
		ifFalse: [1 - (1 bitAnd: (self bitInvert bitShift: 1 - anInteger))]
]

{ #category : #bits }
Integer >> bitInvert [
	^-1 - self
]

{ #category : #bits }
Integer >> bitShift: anInteger [
	| factor |
	factor := 2 raisedToInteger: anInteger abs.
	^anInteger positive ifTrue: [self * factor] ifFalse: [self // factor]
]

{ #category : #bits }
Integer >> bitShiftRight: anInteger [
	^self bitShift: 0 - anInteger
]

{ #category : #arithmetic }
Integer >> factorial [
	self > 1 ifTrue: [^(self - 1) factorial * self].
	self < 0 ifTrue: [^self error: 'not valid for negative numbers'].
	^1
]

{ #category : #testing }
Integer >> isInteger [
	^true
]

{ #category : #testing }
Integer >> isOnBit: n [
	^(self bitAnd: n) = n
]

{ #category : #arithmetic }
Integer >> lcm: anInteger [
	| gcd |
	gcd := self gcd: anInteger.
	^gcd = 0 ifTrue: [1] ifFalse: [(self // gcd * anInteger) abs]
]

{ #category : #bits }
Integer >> lowBit [
	| count mask |
	self = 0 ifTrue: [^nil].
	count := mask := 1.
	[self isOnBit: mask] whileFalse: [
		mask := mask bitShift: 1.
		count := count + 1].
	^count
]

{ #category : #arithmetic }
Integer >> rem: aNumber [
	aNumber = 0 ifTrue: [^self zeroDivisorOn: #rem:].
	^super rem: aNumber
]

{ #category : #arithmetic }
Integer >> rounded [
	^self
]

{ #category : #enumerating }
Integer >> timesRepeat: aBlock [
	| n |
	n := 1.
	[n <= self] whileTrue: [
		aBlock value.
		n := n + 1]
]
