"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Class,
	#superclass : #Species,
	#instVars : [
		'name',
		'subclasses',
		'classVars'
	],
	#category : #Kernel
}

Class class >> newSubclassOf: aClass [
	| meta |
	meta := Metaclass new beSubclassOf: aClass class.
	^meta instanceClass; initializeFrom: aClass.
]

{ #category : #private }
Class >> beNamed: aSymbol in: aSmalltalkSystem [
	| symbol assoc |
	symbol := aSymbol asSymbol.
	assoc := aSmalltalkSystem associationClass key: symbol value: self.
	aSmalltalkSystem basicAdd: assoc.
	name := symbol
]

{ #category : #services }
Class >> beSubclassOf: aClass [
	self installer superclass: aClass; install
]

{ #category : #testing }
Class >> canBeDeleted [
	^self !== Class
]

{ #category : #accessing }
Class >> classVariables [
	^classVars
]

{ #category : #accessing }
Class >> classVarNamed: aString put: anObject [
	| assoc |
	assoc := classVars
				detect: [:as | as key == aString]
				ifNone: [assoc := aString -> anObject. ^classVars := classVars, assoc].
	assoc value: anObject
]

{ #category : #accessing }
Class >> classVarNames [
	^classVars collect: [:assoc | assoc keys]
]

{ #category : #removing }
Class >> delete [
	self canBeDeleted
		ifFalse: [self error: 'System Classes cannot be removed.'].
	Smalltalk removeClass: self
]

{ #category : #services }
Class >> duplicate [
	| copy meta md |
	copy := self objectShallowCopy buildBehavior.
	md := copy methodDictionary.
	md keysAndValuesDo: [:selector :method | md at: selector put: method copy].
	meta := self class objectShallowCopy instanceClass: copy; buildBehavior.
	md := meta methodDictionary.
	md keysAndValuesDo: [:selector :method | md at: selector put: method copy].
	copy behavior: meta instanceBehavior; subclasses: #().
	^copy
]

{ #category : #services }
Class >> duplicateHierarchy [
	| copy |
	copy := self duplicate.
	self subspecies do: [:s | | child |
		child := s duplicateHierarchyFrom: self with: copy.
		child basicBeSubclassOf: copy].
	^copy
]

{ #category : #services }
Class >> duplicateHierarchyFrom: aClass with: aClassCopy [
	| copy |
	self == aClass ifTrue: [^aClassCopy].
	copy := self duplicate.
	self subspecies do: [:s | | child |
		child := s duplicateHierarchyFrom: aClass with: aClassCopy.
		child basicBeSubclassOf: copy].
	^copy
]

{ #category : #accessing }
Class >> fillFrom: aClass [
	| pools |
	super fillFrom: aClass.
	self == aClass ifTrue: [^self].
	self classVariables: aClass classVariables.
	self class fillFrom: aClass class
]

{ #category : #testing }
Class >> hasSubclasses [
	^self subclasses size > 0
]

{ #category : #initialization }
Class >> initializeFrom: aSpecies [
	| md |
	superclass := aSpecies.
	namespaces := #().
	md := MethodDictionary new.
	instanceBehavior := Behavior with: md.
	instanceBehavior classBinding: self.
	format := Object format.
	superclass notNil ifTrue: [
		instanceBehavior next: superclass instanceBehavior.
		format := superclass format]
]

{ #category : #accessing }
Class >> instanceClass [
	^self
]

{ #category : #testing }
Class >> isClass [
	^true
]

{ #category : #testing }
Class >> isDeleted [
	^behavior isNil
]

{ #category : #accessing }
Class >> name [
	^name asString
]

{ #category : #accessing }
Class >> name: aSymbol [
	name := aSymbol asSymbol
]

{ #category : #accessing }
Class >> pointer: pointers variable: variable [
	| flags bits |
	flags := 0.
	variable ifTrue: [flags := flags | Variable].
	format := pointers
		ifTrue: [
			flags := flags | Pointers.
			flags | self instSize]
		ifFalse: [flags].
	variable ifTrue: [
		bits := Variable | Pointers.
		flags := flags & bits.
		self allSubclasses
			do: [:cls | cls format: cls format & bits bitInvert | flags]]
]

{ #category : #'add/remove' }
Class >> removeSubclass: aClass [
	subclasses isNil ifTrue: [^self].
	subclasses := subclasses copyWithout: aClass
]

{ #category : #accessing }
Class >> subclasses [
	subclasses isNil ifTrue: [^#()].
	^name == #Class
		ifTrue: [subclasses reject: [:s | s isMetaclass]]
		ifFalse: [subclasses]
]

{ #category : #accessing }
Class >> subclasses: aCollection [
	subclasses := aCollection isEmpty ifFalse: [aCollection asArray]
]

{ #category : #queries }
Class >> subclassesDo: aBlock [
	subclasses isNil ifTrue: [^self].
	subclasses
		select: [:cls | cls notNil]
		thenDo: [:c | aBlock evaluateWith: c]
]

{ #category : #accessing }
Class >> subspecies [
	subclasses isNil ifTrue: [^#()].
	^subclasses
]

{ #category : #queries }
Class >> subspeciesDo: aBlock [
	subclasses isNil ifTrue: [^self].
	self subspecies do: aBlock
]
