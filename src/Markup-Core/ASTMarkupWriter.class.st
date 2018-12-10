"
A markup writer
"
Class {
	#name : #ASTMarkupWriter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'stack',
		'pretty',
		'indentCharacter',
		'indentLevel'
	],
	#category : #'Markup-Core-Base'
}

{ #category : #factory }
ASTMarkupWriter class >> html5 [
	^(self new)
		writeHTML5Header;
		yourself
]

{ #category : #'instance creation' }
ASTMarkupWriter class >> new [
	^self on: String new writeStream

]

{ #category : #'instance creation' }
ASTMarkupWriter class >> on: aStream [
	^(self basicNew)
		initialize;
		initWithStream: aStream;
		yourself
]

{ #category : #factory }
ASTMarkupWriter class >> xml [
	^(self new)
		writeXMLHeader;
		yourself
]

{ #category : #factory }
ASTMarkupWriter class >> xsl [
	^(self new)
		writeXSLHeader;
		yourself
]

{ #category : #'writing - tag handling' }
ASTMarkupWriter >> beginTag: aTagName [
	"Begin a tag - without closing and allowing to add attributes."
	
	self indent.
	stack push: aTagName.
	stream 
		nextPut: $<;
		nextPutAll: aTagName
]

{ #category : #'writing - basic operations' }
ASTMarkupWriter >> cData: aStringOrBlock [
	self raw: '<![CDATA['.
 	aStringOrBlock isBlock 
		ifTrue: [	 aStringOrBlock value ]
		ifFalse: [ self raw: aStringOrBlock ].				
	self raw: ']]>'
]

{ #category : #'writing - tag handling' }
ASTMarkupWriter >> closeTag [

	self closeTag: nil
]

{ #category : #'writing - tag handling' }
ASTMarkupWriter >> closeTag: expectedTag [
	|top openedTagName |
	
	[ top := stack top ]
		on: Error 
		do: [ TagClosingNotExpected signal: 'Closing "',expectedTag asString,'" but no end tags were expected' ].
	
	top last asString = self openTagIsCompletedMarker
		ifFalse: [ TagOpeningNotCompleted signal: 'Opening tag "',top asString,'" was not completed.' ]
		ifTrue:  [ openedTagName := top allButLast ]. 
	
	expectedTag ifNotNil: [
		openedTagName = expectedTag ifFalse: [ ClosingWrongTag signal: 'Closing ',expectedTag asString,' but expected', top asString ]].

	stack pop.
	stream 
		nextPutAll: '</';
		nextPutAll: openedTagName asString;
		nextPutAll: '>'.
	self newLine.
	
	
]

{ #category : #'writing - basic operations' }
ASTMarkupWriter >> comment: aStringOrBlock [
	self 
		raw: '<!-- ';
		raw: aStringOrBlock value;
		raw: ' -->'
]

{ #category : #accessing }
ASTMarkupWriter >> contents [
	^stream contents
]

{ #category : #defaults }
ASTMarkupWriter >> defaultIdentCharacter [

	^Character tab
]

{ #category : #'private - indenting' }
ASTMarkupWriter >> indent [
	pretty ifFalse: [ ^self ].
	stack isEmpty ifTrue: [ ^self ].
	 
	stack size timesRepeat: [
		stream nextPut: indentCharacter 
	]
]

{ #category : #accessing }
ASTMarkupWriter >> indentCharacter [ 
	^indentCharacter
]

{ #category : #accessing }
ASTMarkupWriter >> indentCharacter: aCharacter [
	indentCharacter := aCharacter 
]

{ #category : #'private - initialization' }
ASTMarkupWriter >> initWithStream: aStream [
	self stream: aStream
]

{ #category : #initialization }
ASTMarkupWriter >> initialize [
	super initialize.
	self stack: Stack new.
	indentCharacter := self defaultIdentCharacter.
	pretty := true
]

{ #category : #'writing - basic operations' }
ASTMarkupWriter >> newLine [

	pretty ifTrue: [ stream cr ]
]

{ #category : #'writing - tag handling' }
ASTMarkupWriter >> openTag: aTagName [
	"Open a tag - without closing and without further possibility to add attributes."
	
	self indent.
	stack push: aTagName, self openTagIsCompletedMarker.
	stream 
		nextPut: $<;
		nextPutAll: aTagName;
		nextPut: $>
]

{ #category : #'private - accessing' }
ASTMarkupWriter >> openTagIsCompletedMarker [

	^'>'
]

{ #category : #'writing - basic operations' }
ASTMarkupWriter >> raw: string [

	stream nextPutAll: string
]

{ #category : #'writing - tag handling' }
ASTMarkupWriter >> selfClosingTag: aTagName [

	self beginTag: aTagName.
	stack pop	.
	stream nextPutAll: '/>'.
	self newLine.
]

{ #category : #'private - accessing' }
ASTMarkupWriter >> stack [

	^stack
]

{ #category : #'private - accessing' }
ASTMarkupWriter >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
ASTMarkupWriter >> stopPrettyPrinting [
	pretty := false
]

{ #category : #'private - accessing' }
ASTMarkupWriter >> stream [

	^stream
]

{ #category : #'private - accessing' }
ASTMarkupWriter >> stream: aStream [

	stream := aStream
]

{ #category : #accessing }
ASTMarkupWriter >> usePrettyPrinting [
	pretty := true
]

{ #category : #'private - headers' }
ASTMarkupWriter >> writeHTML5Header [
	self 
		raw: '<!DOCTYPE html>';
		newLine
]

{ #category : #'private - headers' }
ASTMarkupWriter >> writeXMLHeader [
	self 
		raw: '<?xml version="1.0" encoding="UTF-8"?>';
		newLine
]

{ #category : #'private - headers' }
ASTMarkupWriter >> writeXSLHeader [
	self 
		raw: '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">';
		newLine
]
