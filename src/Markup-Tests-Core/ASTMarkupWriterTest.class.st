"
Unit test for ASTMarkupWriter
"
Class {
	#name : #ASTMarkupWriterTest,
	#superclass : #TestCase,
	#instVars : [
		'writer'
	],
	#category : #'Markup-Tests-Core-Base'
}

{ #category : #defaults }
ASTMarkupWriterTest >> defaultTestClass [

	^ASTMarkupWriter 
]

{ #category : #running }
ASTMarkupWriterTest >> setUp [
	super setUp.
	writer := self defaultTestClass new.
	writer stopPrettyPrinting
]

{ #category : #running }
ASTMarkupWriterTest >> tearDown [
	writer := nil.
	super tearDown
]

{ #category : #'tests - tags' }
ASTMarkupWriterTest >> testBeginTag [

	writer beginTag: 'tag'.
	self 
		assert: writer stack size equals: 1;
		assert: writer contents equals: '<tag'
	
]

{ #category : #'tests - basic' }
ASTMarkupWriterTest >> testCData [

	writer cData: 'hello'.
	self assert: writer contents equals: '<![CDATA[hello]]>'
]

{ #category : #'tests - tags' }
ASTMarkupWriterTest >> testCloseTag [

	writer beginTag: 'tag'.
	writer closeTag.
	self 
		assert: writer stack size equals: 1;
		assert: writer contents equals: '<tag'
	
]

{ #category : #'tests - tags' }
ASTMarkupWriterTest >> testCloseTagWithUnfinishedOpen [

	writer beginTag: 'hello'.
	self should: [ writer closeTag ]
		  raise: TagOpeningNotCompleted  

]

{ #category : #'tests - tags' }
ASTMarkupWriterTest >> testCloseTagWithoutOpen [

	self should: [ writer closeTag ]
		  raise: TagClosingNotExpected  

]

{ #category : #'tests - basic' }
ASTMarkupWriterTest >> testComment [

	writer comment: 'hello'.
	self assert: writer contents equals: '<!-- hello -->'
]

{ #category : #tests }
ASTMarkupWriterTest >> testInstanceCreation [
	|instance|
	instance := self defaultTestClass new.
	self 
		assert: instance stream notNil;
		assert: instance contents isEmpty
]

{ #category : #'tests - factory' }
ASTMarkupWriterTest >> testInstanceCreationHTML5 [
	|instance|
	instance := self defaultTestClass html5.
	self 
		assert: instance stream notNil;
		assert: instance contents notEmpty;
		assert: instance contents equals: '<!DOCTYPE html>
'
		

]

{ #category : #'tests - factory' }
ASTMarkupWriterTest >> testInstanceCreationXML [
	|instance|
	instance := self defaultTestClass xml.
	self 
		assert: instance stream notNil;
		assert: instance contents notEmpty;
		assert: instance contents equals: '<?xml version="1.0" encoding="UTF-8"?>
' 
		

]

{ #category : #'tests - factory' }
ASTMarkupWriterTest >> testInstanceCreationXSL [
	|instance|
	instance := self defaultTestClass xsl.
	self 
		assert: instance stream notNil;
		assert: instance contents notEmpty;
		assert: instance contents equals: '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
' 
		

]

{ #category : #'tests - tags' }
ASTMarkupWriterTest >> testOpenTag [

	writer openTag: 'tag'.
	self 
		assert: writer stack size equals: 1;
		assert: writer contents equals: '<tag>'
	
]

{ #category : #'tests - basic' }
ASTMarkupWriterTest >> testRaw [

	writer raw: 'HelloWorld'.
	self assert: writer contents equals: 'HelloWorld'
]

{ #category : #'tests - tags' }
ASTMarkupWriterTest >> testSelfClosingTag [

	writer selfClosingTag: 'tag'.
	self 
		assert: writer stack size equals: 0;
		assert: writer contents equals: '<tag/>'
	
]
