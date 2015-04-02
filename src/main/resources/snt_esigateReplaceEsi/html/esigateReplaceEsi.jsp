<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jcr:nodeProperty node="${currentNode}" name="fragment" var="fragment"/>
<jcr:nodeProperty node="${currentNode}" name="expression" var="expression"/>

<c:if test="${renderContext.editMode}">
	<template:addResources type="css" resources="esigate-tags.css" />
	<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	<c:if test="${jcr:hasPermission(currentNode, 'editEsigate')}">
		<fieldset class="esigate esigateReplace">
		    <legend title="fragment : ${fragment.string} - expression : ${expression.string}">ESI : Replace</legend>
		    <div class="innerEsi">
				<esi:replace <c:if test="${not empty fragment}">fragment="${fragment.string}"</c:if><c:if test="${not empty expression}"> expression="${expression.string}"</c:if>>
					<template:area  path="${currentNode.name}" areaAsSubNode="true"/>
				</esi:replace>
		    </div>
		</fieldset>
	</c:if>
</c:if>



<c:if test="${!renderContext.editMode}">
	<c:if test="${renderContext.previewMode}">
		<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	</c:if>
	<esi:replace <c:if test="${not empty fragment}">fragment="${fragment.string}"</c:if><c:if test="${not empty expression}"> expression="${expression.string}"</c:if>>
		<template:area  path="${currentNode.name}" areaAsSubNode="true"/>
	</esi:replace>

</c:if>
