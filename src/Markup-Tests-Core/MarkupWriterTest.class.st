"
Unit test for ASTMarkupWriter
"
Class {
	#name : #MarkupWriterTest,
	#superclass : #TestCase,
	#instVars : [
		'writer'
	],
	#category : #'Markup-Tests-Core-Base'
}

{ #category : #defaults }
MarkupWriterTest >> defaultTestClass [

	^MarkupWriter 
]

{ #category : #running }
MarkupWriterTest >> setUp [
	super setUp.
	writer := self defaultTestClass new.
	writer stopPrettyPrinting
]

{ #category : #running }
MarkupWriterTest >> tearDown [
	writer := nil.
	super tearDown
]

{ #category : #'tests - tags' }
MarkupWriterTest >> testBeginTag [

	writer beginTag: 'tag'.
	self 
		assert: writer stack size equals: 1;
		assert: writer contents equals: '<tag'
	
]

{ #category : #'tests - basic' }
MarkupWriterTest >> testCData [

	writer cData: 'hello'.
	self assert: writer contents equals: '<![CDATA[hello]]>'
]

{ #category : #'tests - tags' }
MarkupWriterTest >> testCloseTag [

	writer openTag: 'tag'.
	self assert: writer stack size equals: 1.
	
	writer closeTag.
	self 
		assert: writer stack size equals: 0;
		assert: writer contents equals: '<tag></tag>'
	
]

{ #category : #'tests - tags' }
MarkupWriterTest >> testCloseTagWithUnfinishedOpen [

	writer beginTag: 'hello'.
	self should: [ writer closeTag ]
		  raise: TagOpeningNotCompleted  

]

{ #category : #'tests - tags' }
MarkupWriterTest >> testCloseTagWithoutOpen [

	self should: [ writer closeTag ]
		  raise: TagClosingNotExpected  

]

{ #category : #'tests - basic' }
MarkupWriterTest >> testComment [

	writer comment: 'hello'.
	self assert: writer contents equals: '<!-- hello -->'
]

{ #category : #'tests - tags' }
MarkupWriterTest >> testEmptyTag [

	writer emptyTag: 'tag'.
	self 
		assert: writer stack size equals: 0;
		assert: writer contents equals: '<tag></tag>'
	
]

{ #category : #tests }
MarkupWriterTest >> testInstanceCreation [
	|instance|
	instance := self defaultTestClass new.
	self 
		assert: instance stream notNil;
		assert: instance contents isEmpty
]

{ #category : #'tests - factory' }
MarkupWriterTest >> testInstanceCreationHTML5 [
	|instance|
	instance := self defaultTestClass html5.
	self 
		assert: instance stream notNil;
		assert: instance contents notEmpty;
		assert: instance contents equals: '<!DOCTYPE html>
'
		

]

{ #category : #'tests - factory' }
MarkupWriterTest >> testInstanceCreationXML [
	|instance|
	instance := self defaultTestClass xml.
	self 
		assert: instance stream notNil;
		assert: instance contents notEmpty;
		assert: instance contents equals: '<?xml version="1.0" encoding="UTF-8"?>
' 
		

]

{ #category : #'tests - factory' }
MarkupWriterTest >> testInstanceCreationXSL [
	|instance|
	instance := self defaultTestClass xsl.
	self 
		assert: instance stream notNil;
		assert: instance contents notEmpty;
		assert: instance contents equals: '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
' 
		

]

{ #category : #'tests - nesting' }
MarkupWriterTest >> testNestedBlock [

	writer tag: 'abc' with: [
		writer emptyTag: 'foo'.
	].
	self assert: writer contents equals: '<abc><foo></foo></abc>'
]

{ #category : #'tests - nesting' }
MarkupWriterTest >> testNestedCData [

	writer tag: 'abc' cData: 'hello'.
	self assert: writer contents = '<abc><![CDATA[hello]]></abc>'
]

{ #category : #'tests - tags' }
MarkupWriterTest >> testOpenTag [

	writer openTag: 'tag'.
	self 
		assert: writer stack size equals: 1;
		assert: writer contents equals: '<tag>'
	
]

{ #category : #'tests - basic' }
MarkupWriterTest >> testRaw [

	writer raw: 'HelloWorld'.
	self assert: writer contents equals: 'HelloWorld'
]

{ #category : #'tests - tags' }
MarkupWriterTest >> testSelfClosingTag [

	writer selfClosingTag: 'tag'.
	self 
		assert: writer stack size equals: 0;
		assert: writer contents equals: '<tag/>'
	
]
