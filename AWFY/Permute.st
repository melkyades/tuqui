"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #Permute,
	#superclass : #Benchmark,
	#instVars : [
		'count',
		'v'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
Permute >> benchmark [

    count := 0.
    v     := Array new: 6 withAll: 0.
    self permute: 6.
    ^ count
]

{ #category : #'as yet unclassified' }
Permute >> permute: n [

    count := count + 1.
    (n != 0)
      ifTrue: [
        self permute: n - 1.
        n to: 1 by: -1 do: [ :i |
          self swap: n with: i.
          self permute: n - 1.
          self swap: n with: i ] ]
]

{ #category : #'as yet unclassified' }
Permute >> swap: i with: j [

    | tmp |
    tmp := v at: i.
    v at: i put: (v at: j).
    v at: j put: tmp
]

{ #category : #'as yet unclassified' }
Permute >> verifyResult: result [

    ^ 8660 = result
]

