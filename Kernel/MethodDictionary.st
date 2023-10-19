"
    Copyright (c) 2023, Javier Pimas. 
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #MethodDictionary,
	#superclass : #Object,
	#category : #Kernel
}

{ #category : #constants }
MethodDictionary class >> basicNew [
	<primitive: VMDictionaryNew>
]

{ #category : #accessing }
MethodDictionary >> at: aSymbol [
	<primitive: VMDictionaryAt>
]

{ #category : #accessing }
MethodDictionary >> at: aSymbol put: aCompiledMethod [
	<primitive: VMDictionaryAtPut>
]
	
{ #category : #copying }
MethodDictionary >> copy [
	^self objectShallowCopy postCopy
]

{ #category : #private }
MethodDictionary >> flushCache [
	| class | 
	class := self classBinding.
	self keysDo: [:selector | selector flushCacheFor: class]
]

{ #category : #testing }
MethodDictionary >> isMethodDictionary [
	^true
]

{ #category : #accessing }
MethodDictionary >> keys [
	<primitive: VMDictionaryKeys>
]

{ #category : #copying }
MethodDictionary >> postCopy [
	table := table copy owner: self
]

{ #category : #removing }
MethodDictionary >> removeKey: aSymbol [
	<primitive: VMDictionaryRemoveKey>
]

