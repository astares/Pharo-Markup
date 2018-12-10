"
The tag opening was not completed which means we have the state

	<tag
	
	instead of 
	
   <tag>

This can happen if you used beginTag: instead of openTag:
"
Class {
	#name : #TagOpeningNotCompleted,
	#superclass : #Error,
	#category : #'Markup-Core-Exceptions'
}
