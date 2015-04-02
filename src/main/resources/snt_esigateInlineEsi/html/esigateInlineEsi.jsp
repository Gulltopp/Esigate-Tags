<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jcr:nodeProperty node="${currentNode}" name="fragmentName" var="fragmentName"/>
<jcr:nodeProperty node="${currentNode}" name="fetchable" var="fetchable"/>

<c:if test="${renderContext.editMode}">
	<template:addResources type="css" resources="esigate-tags.css"/>
	<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	<c:if test="${jcr:hasPermission(currentNode, 'editEsigate')}">
		<fieldset class="esigate esigateInline">
		    <legend title="fragmentName : ${fragmentName.string} - fetchable : ${fetchable.boolean}">ESI : inline</legend>
		    <div class="innerEsi">
		
				<esi:inline name="${fragmentName.string}" fetchable="${fetchable.boolean}">
					<template:area  path="${currentNode.name}"  areaAsSubNode="true"/>
				</esi:inline> 
		
		    </div>
		</fieldset>
	</c:if>
</c:if>


<c:if test="${!renderContext.editMode}">
	<c:if test="${renderContext.previewMode}">
		<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	</c:if>
	<esi:inline name="${fragmentName.string}" fetchable="${fetchable.boolean}">
		<template:area  path="${currentNode.name}"  areaAsSubNode="true"/>
	</esi:inline> 
</c:if>
