Extension { #name : #MarkupNode }

{ #category : #'*Markup-Tools' }
MarkupNode >> gtInspectorAttributesIn: composite [
	<gtInspectorPresentationOrder: 0>  
	
	^(composite table)	 
		title: 'Attributes';
		display: [ self attributes ];
		column: 'Key' evaluated: #key;
		column: 'Value' evaluated: #value.
]

{ #category : #'*Markup-Tools' }
MarkupNode >> gtInspectorSubnodesIn: composite [
	<gtInspectorPresentationOrder: 1>  
	
	^(composite list)	 
		title: 'Subnodes';
		display: [ self subnodes ]
]
