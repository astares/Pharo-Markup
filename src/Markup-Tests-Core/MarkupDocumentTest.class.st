"
Unit test for markup document
"
Class {
	#name : #MarkupDocumentTest,
	#superclass : #TestCase,
	#instVars : [
		'document'
	],
	#category : #'Markup-Tests-Core-Model'
}

{ #category : #running }
MarkupDocumentTest >> setUp [
	super setUp.
	document := MarkupDocument new.

]

{ #category : #tests }
MarkupDocumentTest >> tearDown [
	document := nil.
	super tearDown 
]

{ #category : #tests }
MarkupDocumentTest >> testAddNode [

	self deny: document hasNodes.
	document addNode: (MarkupNode named: 'tag').
	self assert: document hasNodes
]

{ #category : #tests }
MarkupDocumentTest >> testHasNodes [

	self deny: document hasNodes 
]
