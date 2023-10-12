"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #List,
	#superclass : #SequenceableCollection,
	#instVars : [
		'start',
		'end',
		'contents'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
List class >> new [
	^self new: 10
]

{ #category : #'instance creation' }
List class >> new: anInteger [
	^self basicNew initialize: anInteger
]

{ #category : #'instance creation' }
List class >> new: size withAll: anObject [
	| instance |
	instance := self new: size.
	instance stretchToContents.
	anObject notNil ifTrue: [instance atAllPut: anObject].
	^instance
]

{ #category : #'instance creation' }
List class >> withAll: aCollection [
	| collection |
	collection := self new: aCollection size.
	collection addAll: aCollection.
	^collection
]

{ #category : #operations }
List >> , aCollection [
	aCollection isCollection ifFalse: [super , aCollection].
	^self copy addAll: aCollection; yourself
]

{ #category : #errors }
List >> absentElement [
	^self error: 'element not found'
]

{ #category : #adding }
List >> add: anObject [
	^self basicAdd: anObject
]

{ #category : #adding }
List >> add: anObject after: anotherObject [
	| index |
	index := self indexOf: anotherObject ifAbsent: [^self absentElement].
	^self add: anObject afterIndex: index
]

{ #category : #adding }
List >> add: anObject afterIndex: anInteger [
	self makeRoomBehind: anInteger.
	^self at: anInteger + 1 put: anObject
]

{ #category : #adding }
List >> add: anObject at: anInteger [
	self makeRoomBehind: anInteger - 1.
	^contents at: start + anInteger - 1 put: anObject
]

{ #category : #adding }
List >> add: anObject before: anotherObject [
	| index |
	index := self indexOf: anotherObject ifAbsent: [^self absentElement].
	^self add: anObject beforeIndex: index
]

{ #category : #adding }
List >> add: anObject beforeIndex: anInteger [
	self makeRoomBehind: anInteger - 1.
	^self at: anInteger put: anObject
]

{ #category : #adding }
List >> addAll: aCollection [
	^aCollection isSequenceableCollection
		ifTrue: [self addAllLast: aCollection]
		ifFalse: [super addAll: aCollection]
]

{ #category : #adding }
List >> addAllFirst: aCollection [
	| pending n |
	pending := aCollection size.
	[| free |
		free := start - 1.
		(pending > 0 and: [free = 0]) ifTrue: [
			self makeRoomBefore.
			free := start - 1].
		n := free min: pending.
		n > 0]
		whileTrue: [
			contents
				replaceFrom: start - n
				to: start - 1
				with: aCollection
				startingAt: pending - n + 1.
			start := start - n.
			pending := pending - n].
	^aCollection
]

{ #category : #adding }
List >> addAllLast: aCollection [
	| index m n |
	index := 1.
	m := aCollection size.
	[| free pending |
		pending := m - index + 1.
		free := contents size - end.
		(pending > 0 and: [free = 0]) ifTrue: [
			start > 1 ifTrue: [self compact] ifFalse: [self grow].
			free := contents size - self size].
		n := free min: pending.
		n > 0]
		whileTrue: [
			contents
				replaceFrom: end + 1
				to: end + n
				with: aCollection
				startingAt: index.
			end := end + n.
			index := index + n].
	^aCollection
]

{ #category : #adding }
List >> addFirst: anObject [
	start = 1 ifTrue: [self makeRoomBefore].
	start := start - 1.
	contents at: start put: anObject.
	^anObject
]

{ #category : #adding }
List >> addLast: anObject [
	^self basicAdd: anObject
]

{ #category : #copying }
List >> allButIndex: anInteger [
	^self copy removeIndex: anInteger
]

{ #category : #converting }
List >> asList [
	^self
]

{ #category : #accessing }
List >> at: anInteger [
	^self at: anInteger ifAbsent: [self outOfBoundsIndex: anInteger]
]

{ #category : #accessing }
List >> at: anInteger ifAbsent: aBlock [
	| index |
	index := anInteger + start - 1.
	(start <= index and: [index <= end]) ifFalse: [^aBlock value].
	^contents at: index
]

{ #category : #accessing }
List >> at: anInteger put: anObject [
	| index |
	index := anInteger + start - 1.
	(start <= index and: [index <= end])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^contents at: index put: anObject
]

{ #category : #accessing }
List >> atAllPut: anObject [
	start to: end do: [:i | contents at: i put: anObject]
]

{ #category : #accessing }
List >> atValid: anInteger [
	^contents at: anInteger + start - 1
]

{ #category : #private }
List >> basicAdd: anObject [
	end = contents size ifTrue: [self makeRoomBehind].
	end := end + 1.
	contents at: end put: anObject.
	^anObject
]

{ #category : #accessing }
List >> collectionSize [
	^end - start + 1
]

{ #category : #private }
List >> compact [
	| size e |
	start = 1 ifTrue: [^self].
	size := self size.
	e := end.
	contents
		replaceFrom: 1
		to: size
		with: contents
		startingAt: start.
	start := 1.
	end := size.
	contents replaceFrom: end + 1 to: e withObject: nil
]

{ #category : #copying }
List >> copyFrom: startIndex to: endIndex [
	| n copy |
	n := endIndex - startIndex + 1 max: 0.
	copy := self species new: self size.
	copy stretchTo: n.
	^copy replaceFrom: 1 to: n with: self startingAt: startIndex
]

{ #category : #copying }
List >> copyWith: anObject [
	^self copy add: anObject; yourself
]

{ #category : #enumerating }
List >> do: aBlock [
	start to: end do: [:i | aBlock evaluateWith: (contents at: i)]
]

{ #category : #private }
List >> grow [
	self growTo: contents size + self growSize
]

{ #category : #private }
List >> growTo: anInteger [
	| copy |
	copy := contents class new: anInteger.
	copy
		replaceFrom: start
		to: end
		with: contents
		startingAt: start.
	contents := copy
]

{ #category : #inquiries }
List >> includes: anObject [
	start to: end do: [:i | anObject = (contents at: i) ifTrue: [^true]].
	^false
]

{ #category : #private }
List >> initialize: anInteger [
	start := 1.
	end := 0.
	contents := Array new: anInteger
]

{ #category : #private }
List >> makeRoomBefore [
	| n s |
	n := self collectionSize.
	end := end = contents size
		ifTrue: [
			self grow.
			contents size + end + 1 // 2]
		ifFalse: [contents size].
	s := start.
	start := end - n + 1.
	contents
		replaceFrom: start
		to: end
		with: contents
		startingAt: s;
		replaceFrom: s to: start - 1 withObject: nil
]

{ #category : #private }
List >> makeRoomBehind [
	| s n e |
	start = 1 ifTrue: [^self grow].
	s := start // 2.
	n := self collectionSize.
	e := end.
	end := s + n - 1.
	contents
		replaceFrom: s
		to: end
		with: contents
		startingAt: start;
		replaceFrom: end + 1 to: e withObject: nil.
	start := s
]

{ #category : #private }
List >> makeRoomBehind: anInteger [
	(anInteger = 0 and: [start > 1]) ifTrue: [
		start := start - 1.
		^self].
	end = contents size ifTrue: [self makeRoomBehind].
	end := end + 1.
	contents
		replaceFrom: start + anInteger + 1
		to: end
		with: contents
		startingAt: start + anInteger
]

{ #category : #copying }
List >> postCopy [
	contents := contents copy
]

{ #category : #removing }
List >> remove: anObject ifAbsent: aBlock [
	start to: end do: [:i | 
		anObject = (contents at: i) ifTrue: [
			self removeIndex: i - start + 1.
			^anObject]].
	^aBlock value
]

{ #category : #removing }
List >> removeAll [
	contents replaceFrom: start to: end withObject: nil.
	start := 1.
	end := 0
]

{ #category : #'adding/removing' }
List >> removeAllSuchThat: aBlock [
	| n |
	n := start.
	start to: end do: [:index | | element |
		element := contents at: index.
		(aBlock value: element) ifFalse: [
			contents at: n put: element.
			n := n + 1]].
	contents replaceFrom: n to: end withObject: nil.
	end := n - 1.
	end < start ifTrue: [
		start := 1.
		end := 0]
]

{ #category : #removing }
List >> removeFirst [
	| first |
	start > end ifTrue: [^self absentElement].
	first := contents at: start.
	contents at: start put: nil.
	start := start + 1.
	end < start ifTrue: [
		start := 1.
		end := 0].
	^first
]

{ #category : #removing }
List >> removeIndex: anInteger [
	| absolute |
	absolute := anInteger + start - 1.
	(absolute between: start and: end) ifFalse: [^self absentElement].
	absolute <= (start + end // 2)
		ifTrue: [
			contents
				replaceFrom: start + 1 to: absolute with: contents startingAt: start;
				at: start put: nil.
			start := start + 1]
		ifFalse: [
			contents
				replaceFrom: absolute
				to: end - 1
				with: contents
				startingAt: absolute + 1;
				at: end put: nil.
			end := end - 1].
	end < start ifTrue: [
		start := 1.
		end := 0]
]

{ #category : #removing }
List >> removeLast [
	| last |
	start > end ifTrue: [^self absentElement].
	last := contents at: end.
	contents at: end put: nil.
	end := end - 1.
	end < start ifTrue: [
		start := 1.
		end := 0].
	^last
]

{ #category : #unclassified }
List >> replaceBackwardFrom: first
to: last
with: aCollection
startingAt: position [
	contents
		replaceBackwardFrom: start + first - 1
		to: start + last - 1
		with: aCollection
		startingAt: position
]

{ #category : #unclassified }
List >> replaceForwardFrom: first
to: last
with: aCollection
startingAt: position [
	contents
		replaceForwardFrom: start + first - 1
		to: start + last - 1
		with: aCollection
		startingAt: position
]

{ #category : #accessing }
List >> replaceFrom: firstIndex to: lastIndex with: aCollection [
	| m d n e |
	m := aCollection size.
	d := lastIndex - firstIndex + 1.
	n := self size - d + m.
	n > contents size ifTrue: [self growTo: n // 2 + n].
	e := end.
	end := contents size.
	self
		replaceFrom: firstIndex + m to: n with: self startingAt: lastIndex + 1;
		replaceFrom: firstIndex
		to: firstIndex + m - 1
		with: aCollection
		startingAt: 1.
	end := start + n - 1.
	contents replaceFrom: e + m - d + 1 to: e withObject: nil
]

{ #category : #accessing }
List >> size [
	^self collectionSize
]

{ #category : #sorting }
List >> sortBy: aBlock [
	contents sort: start to: end with: aBlock
]

{ #category : #accessing }
List >> stretchTo: n [
	n < end ifTrue: [self error: 'invalid argument'].
	end := n + start - 1
]

{ #category : #private }
List >> stretchToContents [
	start := 1.
	end := contents size
]

