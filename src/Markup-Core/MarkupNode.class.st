"
A markup node
"
Class {
	#name : #MarkupNode,
	#superclass : #Object,
	#instVars : [
		'name',
		'attributes',
		'subnodes'
	],
	#category : #'Markup-Core-Model'
}

{ #category : #'instance creation' }
MarkupNode class >> named: aString [ 
	^(self new)
		name: aString;
		yourself
]

{ #category : #operating }
MarkupNode >> addSubnode: aSubnode [

	^self subnodes add: aSubnode 
]

{ #category : #accessing }
MarkupNode >> attributes [
	^ attributes ifNil: [ attributes := Dictionary new ]
]

{ #category : #testing }
MarkupNode >> hasSubnodes [

	^self subnodes notEmpty
]

{ #category : #accessing }
MarkupNode >> name [

	^name
]

{ #category : #accessing }
MarkupNode >> name: aString [

	name := aString
]

{ #category : #printing }
MarkupNode >> printOn: aStream [

	aStream nextPut: $<.
	aStream nextPutAll: self name.
	aStream nextPut: $>.
]

{ #category : #accessing }
MarkupNode >> subnodes [

	^ subnodes ifNil: [ subnodes := OrderedCollection new ]
]

{ #category : #visiting }
MarkupNode >> visit: aVisitor [ 
	aVisitor visitMarkupNode: self.
	
]
