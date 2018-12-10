"
Unit tests for MarkupNode
"
Class {
	#name : #MarkupNodeTest,
	#superclass : #TestCase,
	#instVars : [
		'document'
	],
	#category : #'Markup-Tests-Core-Model'
}

{ #category : #tests }
MarkupNodeTest >> testInstanceCreation [ 
	
	|instance|
	instance := MarkupNode named: 'tag'.
	self 
		assert: instance name equals: 'tag';
		assert: instance attributes isEmpty
	
]
