Extension { #name : #MarkupDocument }

{ #category : #'*Markup-Tools' }
MarkupDocument >> addMarkupNode [
	|nodeName|
	nodeName := UIManager default request: 'Node name' initialAnswer: 'html'.
	nodeName ifNotNil: [ self addNode: (MarkupNode named: nodeName) ]
]

{ #category : #'*Markup-Tools' }
MarkupDocument >> addMarkupNodeFor: aNode [
	|nodeName|
	nodeName := UIManager default request: 'Node name' initialAnswer: 'html'.
	nodeName ifNotNil: [ aNode addSubnode: (MarkupNode named: nodeName) ]
]

{ #category : #'*Markup-Tools' }
MarkupDocument >> gtInspectorIn: composite [
	<gtInspectorPresentationOrder: 1> 
	
	composite text 
		title: 'Document' translated;
		display: [ :anObject | anObject text ]				   
]

{ #category : #'*Markup-Tools' }
MarkupDocument >> gtInspectorNodesIn: composite [
	<gtInspectorPresentationOrder: 0>  
	
	^(composite tree)	 
			shouldValidate: false;
			title: 'Nodes';
			display: [ self nodes ];
			children: [ :each | each subnodes ];
			format: #printString;
			act: [:p | self addMarkupNode. p update ] icon: self iconProvider importIcon entitled: 'Add root node...';
			selectionAct: [:p | p entity addMarkupNodeFor: p selection. p update ] icon: self iconProvider importIcon entitled: 'Add subnode' 
]

{ #category : #'*Markup-Tools' }
MarkupDocument >> iconProvider [

	^QACToolIcons
]
