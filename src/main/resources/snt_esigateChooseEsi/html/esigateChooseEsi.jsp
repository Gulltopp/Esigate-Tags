<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jcr:node var="otherwiseNode" path="${currentNode.path}/otherwise"/>
<jcr:node var="whenListNode" path="${currentNode.path}/whenList"/>


<c:if test="${renderContext.editMode}">
	<template:addResources type="css" resources="esigate-tags.css"/>
	<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	<c:if test="${jcr:hasPermission(currentNode, 'editEsigate')}">
		<fieldset class="esigate esigateChoose">
		    <legend>ESI : choose</legend>
		    <div class="innerEsi">
				<esi:choose>
					<template:module node="${whenListNode}" view="default" editable="true"/>
					<template:module node="${otherwiseNode}" view="default" editable="true"/>
				</esi:choose>
		    </div>
		</fieldset>
	</c:if>
</c:if>

<c:if test="${!renderContext.editMode}">
	<c:if test="${renderContext.previewMode}">
		<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	</c:if>
	<esi:choose>
		<template:module node="${whenListNode}" view="default" editable="true"/>
		<template:module node="${otherwiseNode}" view="default" editable="true"/>
	</esi:choose>
</c:if>
