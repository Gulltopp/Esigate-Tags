<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jcr:nodeProperty node="${currentNode}" name="test" var="test"/>

<c:if test="${renderContext.editMode}">
	<template:addResources type="css" resources="esigate-tags.css"/>
	<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	<c:if test="${jcr:hasPermission(currentNode, 'editEsigate')}">
		<fieldset class="esigate esigateWhen">
		    <legend title="test : ${test.string}">ESI : when</legend>
		    <div class="innerEsi">
		
				<esi:when test="${test.string}">
					<template:area  path="${currentNode.name}" areaAsSubNode="true"/>
				</esi:when>
		
		    </div>
		</fieldset>
	</c:if>
</c:if>


<c:if test="${!renderContext.editMode}">
	<c:if test="${renderContext.previewMode}">
		<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	</c:if>
	<esi:when test="${test.string}">
		<template:area  path="${currentNode.name}" areaAsSubNode="true"/>
	</esi:when>
</c:if>
