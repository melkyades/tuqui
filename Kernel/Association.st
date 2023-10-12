"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Association,
	#superclass : #Object,
	#instVars : [
		'key',
		'value'
	],
	#category : #Kernel
}

{ #category : #comparing }
Association >> = anAssociation [
	^anAssociation isAssociation
		and: [key = anAssociation key]
		and: [value = anAssociation value]
]

{ #category : #comparing }
Association >> hash [
	^key hash
]

{ #category : #testing }
Association >> isAssociation [
	^true
]

{ #category : #comparing }
Association >> key [
	^key
]

{ #category : #accessing }
Association >> key: anObject [
	key := anObject
]

{ #category : #printing }
Association >> printOn: aStream [
	key printOn: aStream.
	aStream nextPutAll: ' -> '.
	value printOn: aStream
]

{ #category : #accessing }
Association >> value [
	^value
]

{ #category : #accessing }
Association >> value: anObject [
	value := anObject
]

