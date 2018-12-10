"
A markup writer
"
Class {
	#name : #MarkupWriter,
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
MarkupWriter class >> html5 [
	^(self new)
		writeHTML5Header;
		yourself
]

{ #category : #'instance creation' }
MarkupWriter class >> new [
	^self on: String new writeStream

]

{ #category : #'instance creation' }
MarkupWriter class >> on: aStream [
	^(self basicNew)
		initialize;
		initWithStream: aStream;
		yourself
]

{ #category : #factory }
MarkupWriter class >> xml [
	^(self new)
		writeXMLHeader;
		yourself
]

{ #category : #factory }
MarkupWriter class >> xsl [
	^(self new)
		writeXSLHeader;
		yourself
]

{ #category : #'writing - tag handling' }
MarkupWriter >> beginTag: aTagName [
	"Begin a tag - without closing and allowing to add attributes."
	
	self indent.
	stack push: aTagName.
	stream 
		nextPut: $<;
		nextPutAll: aTagName
]

{ #category : #'writing - basic operations' }
MarkupWriter >> cData: aStringOrBlock [
	self raw: '<![CDATA['.
 	aStringOrBlock isBlock 
		ifTrue: [	 aStringOrBlock value ]
		ifFalse: [ self raw: aStringOrBlock ].				
	self raw: ']]>'
]

{ #category : #'writing - tag handling' }
MarkupWriter >> closeTag [

	self closeTag: nil
]

{ #category : #'writing - tag handling' }
MarkupWriter >> closeTag: expectedTag [
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
MarkupWriter >> comment: aStringOrBlock [
	self 
		raw: '<!-- ';
		raw: aStringOrBlock value;
		raw: ' -->'
]

{ #category : #accessing }
MarkupWriter >> contents [
	^stream contents
]

{ #category : #defaults }
MarkupWriter >> defaultIdentCharacter [

	^Character tab
]

{ #category : #'writing - tag handling' }
MarkupWriter >> emptyTag: aTagName [
	self 
		openTag: aTagName;
 		closeTag: aTagName 
]

{ #category : #'private - indenting' }
MarkupWriter >> indent [
	pretty ifFalse: [ ^self ].
	stack isEmpty ifTrue: [ ^self ].
	 
	stack size timesRepeat: [
		stream nextPut: indentCharacter 
	]
]

{ #category : #accessing }
MarkupWriter >> indentCharacter [ 
	^indentCharacter
]

{ #category : #accessing }
MarkupWriter >> indentCharacter: aCharacter [
	indentCharacter := aCharacter 
]

{ #category : #'private - initialization' }
MarkupWriter >> initWithStream: aStream [
	self stream: aStream
]

{ #category : #initialization }
MarkupWriter >> initialize [
	super initialize.
	self stack: Stack new.
	indentCharacter := self defaultIdentCharacter.
	pretty := true
]

{ #category : #'writing - basic operations' }
MarkupWriter >> newLine [

	pretty ifTrue: [ stream cr ]
]

{ #category : #'writing - tag handling' }
MarkupWriter >> openTag: aTagName [
	"Open a tag - without closing and without further possibility to add attributes."
	
	self indent.
	stack push: aTagName, self openTagIsCompletedMarker.
	stream 
		nextPut: $<;
		nextPutAll: aTagName;
		nextPut: $>
]

{ #category : #'private - accessing' }
MarkupWriter >> openTagIsCompletedMarker [

	^'>'
]

{ #category : #'writing - basic operations' }
MarkupWriter >> raw: string [

	stream nextPutAll: string
]

{ #category : #'writing - tag handling' }
MarkupWriter >> selfClosingTag: aTagName [

	self beginTag: aTagName.
	stack pop	.
	stream nextPutAll: '/>'.
	self newLine.
]

{ #category : #'private - accessing' }
MarkupWriter >> stack [

	^stack
]

{ #category : #'private - accessing' }
MarkupWriter >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
MarkupWriter >> stopPrettyPrinting [
	pretty := false
]

{ #category : #'private - accessing' }
MarkupWriter >> stream [

	^stream
]

{ #category : #'private - accessing' }
MarkupWriter >> stream: aStream [

	stream := aStream
]

{ #category : #accessing }
MarkupWriter >> usePrettyPrinting [
	pretty := true
]

{ #category : #'private - headers' }
MarkupWriter >> writeHTML5Header [
	self 
		raw: '<!DOCTYPE html>';
		newLine
]

{ #category : #'private - headers' }
MarkupWriter >> writeXMLHeader [
	self 
		raw: '<?xml version="1.0" encoding="UTF-8"?>';
		newLine
]

{ #category : #'private - headers' }
MarkupWriter >> writeXSLHeader [
	self 
		raw: '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">';
		newLine
]
