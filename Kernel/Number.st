"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Number,
	#superclass : #Magnitude,
	#category : #Kernel
}

{ #category : #'instance creation' }
Number class >> new [
	^self shouldNotImplement
]

{ #category : #'instance creation' }
Number class >> new: anInteger [
	^self shouldNotImplement
]

{ #category : #arithmetic }
Number class >> zero [
	^0
]

{ #category : #arithmetic }
Number >> \\ aNumber [
	^self - (self // aNumber * aNumber)
]

{ #category : #arithmetic }
Number >> abs [
	^self < self class zero ifTrue: [self negated] ifFalse: [self]
]

{ #category : #testing }
Number >> even [
	^self \\ 2 = 0
]

{ #category : #testing }
Number >> isZero [
	^self = self class zero
]

{ #category : #arithmetic }
Number >> negated [
	^0 - self
]

{ #category : #testing }
Number >> negative [
	^self < self class zero
]

{ #category : #testing }
Number >> odd [
	^self even not
]

{ #category : #testing }
Number >> positive [
	^self >= self class zero
]

{ #category : #arithmetic }
Number >> rem: aNumber [
	| quo |
	quo := self quo: aNumber.
	^self - (quo * aNumber)
]

{ #category : #copying }
Number >> shallowCopy [
	^self
]

{ #category : #accessing }
Number >> sign [
	self > 0 ifTrue: [^1].
	self < 0 ifTrue: [^-1].
	^0
]

{ #category : #arithmetic }
Number >> squared [
	^self * self
]

{ #category : #testing }
Number >> strictlyPositive [
	^self > self class zero
]

{ #category : #converting }
Number >> to: stop [
	^Interval from: self to: stop
]

{ #category : #converting }
Number >> to: stop by: step [
	^Interval from: self to: stop by: step
]

{ #category : #enumerating }
Number >> to: stop by: step do: aBlock [
	| index |
	step = 0 ifTrue: [self error: 'step cannot be zero'].
	index := self.
	step > 0
		ifTrue: [
			[index <= stop] whileTrue: [
				aBlock value: index.
				index := index + step]]
		ifFalse: [
			[stop <= index] whileTrue: [
				aBlock value: index.
				index := index + step]]
]

{ #category : #enumerating }
Number >> to: stop do: aBlock [
	| index |
	index := self.
	[index <= stop] whileTrue: [
		aBlock value: index.
		index := index + 1]
]
