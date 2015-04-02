<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${renderContext.editMode}">
<template:addResources type="css" resources="esigate-tags.css"/>
<fieldset class="esigate esigateWhenList">
    <legend>ESI : When list</legend>
    <div class="innerEsi">
</c:if>

<c:forEach items="${currentNode.nodes}" var="whenNode">
    <c:if test="${jcr:isNodeType(whenNode,'snt:esigateWhenEsi')}">
        <template:module node="${whenNode}" view="default"/>
    </c:if>
</c:forEach>

<c:if test="${renderContext.editMode}">
    	<template:module path="*"/>
    </div>
</fieldset>
</c:if>
