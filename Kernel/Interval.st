"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Interval,
	#superclass : #ArrayedCollection,
	#instVars : [
		'start',
		'end',
		'step'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Interval class >> from: beginningInteger to: endInteger [
	^self from: beginningInteger to: endInteger by: 1
]

{ #category : #'instance creation' }
Interval class >> from: beginningInteger to: endInteger by: incrementInteger [
	^self basicNew from: beginningInteger to: endInteger step: incrementInteger
]

{ #category : #arithmetic }
Interval >> - delta [
	^start - delta to: end - delta by: step
]

{ #category : #arithmetic }
Interval >> + delta [
	^start + delta to: end + delta by: step
]

{ #category : #converting }
Interval >> asStretch [
	^start thru: end
]

{ #category : #accessing }
Interval >> at: anInteger [
	| answer |
	anInteger > 0 ifTrue: [
		answer := start + (anInteger - 1 * step).
		(step > 0 and: [answer between: start and: end]) ifTrue: [^answer].
		(step < 0 and: [answer between: end and: start]) ifTrue: [^answer].
		anInteger = self size ifTrue: [^end]].
	^self outOfBoundsIndex: anInteger
]

{ #category : #accessing }
Interval >> at: anInteger put: aNumber [
	^self shouldNotImplement
]

{ #category : #accessing }
Interval >> end [
	^end
]

{ #category : #private }
Interval >> from: startInteger to: endInteger step: stepInteger [
	start := startInteger.
	end := endInteger.
	step := stepInteger.
	step = 0 ifTrue: [^self error: 'zero size steps not allowed']
]

{ #category : #services }
Interval >> reversed [
	^self class from: end to: start by: step negated
]

{ #category : #accessing }
Interval >> size [
	| size x |
	size := 0 max: end - start // step + 1.
	x := step * size + start.
	((step < 0 and: [end <= x]) or: [step > 0 and: [x <= end]])
		ifTrue: [size := size + 1].
	^size
]

{ #category : #private }
Interval >> species [
	^Array
]

{ #category : #accessing }
Interval >> start [
	^start
]

{ #category : #accessing }
Interval >> step [
	^step
]

