"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #ScriptConsole,
	#superclass : #Object,
	#category : #AWFY
}

{ #category : #private }
ScriptConsole class >> println: aString [
	| all |
	all := aString replaceAll: '\n' with: String cr.
	Tuqui transcript nextPutAll: all , String cr
]

{ #category : #private }
ScriptConsole >> println: aString [
	Tuqui transcript nextPutAll: aString
]

