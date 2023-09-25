"
    Copyright (c) 2023, Javier Pimás.
    Copyright (c) 2020, Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Array,
	#superclass : #ArrayedCollection,
	#type : #variable,
	#category : #Kernel
}

{ #category : #converting }
Array >> asArray [
	^self
]

{ #category : #testing }
Array >> isArray [
	^true
]

