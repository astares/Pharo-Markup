"
A markup document
"
Class {
	#name : #MarkupDocument,
	#superclass : #Object,
	#instVars : [
		'nodes'
	],
	#category : #'Markup-Core-Model'
}

{ #category : #operating }
MarkupDocument >> addNode: aMarkupNode [ 

	self nodes add: aMarkupNode 
]

{ #category : #testing }
MarkupDocument >> hasNodes [
	"Return true if the receiver has nodes"
	
	^self nodes notEmpty 
]

{ #category : #accessing }
MarkupDocument >> nodes [

	^nodes ifNil: [ nodes := OrderedCollection new ]
]
