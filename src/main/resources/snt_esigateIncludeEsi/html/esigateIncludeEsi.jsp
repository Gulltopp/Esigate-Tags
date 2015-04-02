<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jcr:nodeProperty node="${currentNode}" var="provider" name="provider" />
<jcr:nodeProperty node="${currentNode}" var="src" name="src" />
<jcr:nodeProperty node="${currentNode}" var="fragment" name="fragment" />
<jcr:nodeProperty node="${currentNode}" var="xpath" name="xpath" />
<jcr:nodeProperty node="${currentNode}" var="continueOnError" name="continueOnError" />

<jcr:nodeProperty node="${currentNode}" var="alt" name="alt" />
<jcr:nodeProperty node="${currentNode}" var="rewriteAbsoluteUrl" name="rewriteAbsoluteUrl" />
<jcr:nodeProperty node="${currentNode}" var="styleSheet" name="styleSheet" />
<jcr:nodeProperty node="${currentNode}" var="includeDistantResources" name="includeDistantResources" />

<jcr:nodeProperty node="${currentNode}" var="includeLocale" name="includeLocale" />
<jcr:nodeProperty node="${currentNode}" var="includeParameters" name="includeParameters" />

<c:if test="${renderContext.editMode}">
	<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	<c:if test="${jcr:hasPermission(currentNode, 'editEsigate')}">
		<template:addResources type="css" resources="esigate-tags.css"/>
		<fieldset class="esigate esigateInclude">
			<legend title="provider : ${provider.string} - src : ${src.string} - fragment : ${fragment.string}">ESI : include</legend>
			<div class="innerEsi">
				<c:set var="providerValue" value="" scope="request" />
				<c:if test="${not empty provider}">
				    <c:set var="providerValue" value="$(PROVIDER{${provider.string}})/" scope="request" />
				</c:if>
				
				<c:set var="srcValue" value="${src.string}" scope="request" />
				<%-- 
				<c:if test="${not empty includeLocale}">
				    <c:set var="srcValue" value="${eca:appendLocaleParameters(src.string,renderContext)}" scope="request" />
				</c:if>
				--%>
				<esi:include src="${providerValue}${srcValue}"
				    <c:if test="${not empty fragment}"> fragment="${fragment.string}"</c:if> 
				    <c:if test="${not empty xpath}"> xpath="${xpath.string}"</c:if>
				    <c:if test="${not empty alt}"> alt="${alt.string}"</c:if>
				    <c:if test="${not empty styleSheet}"> alt="${styleSheet.string}"</c:if>
				    <c:if test="${not empty rewriteAbsoluteUrl && rewriteAbsoluteUrl.boolean}"> rewriteabsoluteurl="true"</c:if>
				    <c:if test="${not empty continueOnError && continueOnError.boolean}"> onerror="continue"</c:if>>
					<template:area  path="${currentNode.name}" areaAsSubNode="true"/>
				</esi:include>
				
				<c:if test="${not empty includeDistantResources && includeDistantResources.boolean && not empty fragment}"> 
					<template:addResources>
						<esi:include src="${providerValue}${srcValue}"
							fragment="${fragment.string}CssAndJs" 
							onerror="continue">
						</esi:include>
					</template:addResources>
				</c:if>
			</div>
		</fieldset>
	</c:if>
</c:if>



<c:if test="${!renderContext.editMode}">
	<c:if test="${renderContext.previewMode}">
		<template:module path="image" view="default" nodeTypes="snt:bgImage"/>
	</c:if>
	<c:set var="providerValue" value="" scope="request" />
	<c:if test="${not empty provider}">
	    <c:set var="providerValue" value="$(PROVIDER{${provider.string}})/" scope="request" />
	</c:if>
	<c:set var="srcValue" value="${src.string}" scope="request" />
	<%-- 
	<c:if test="${not empty includeLocale}">
	    <c:set var="srcValue" value="${eca:appendLocaleParameters(src.string,renderContext)}" scope="request" />
	</c:if>
	<c:if test="${not empty includeParameters}">
		<c:set var="srcValue" value="${eca:appendRequestParameters(srcValue,renderContext)}" scope="request" />
	</c:if>
	--%>
	<esi:include src="${providerValue}${srcValue}"
	    <c:if test="${not empty fragment}"> fragment="${fragment.string}"</c:if> 
	    <c:if test="${not empty xpath}"> xpath="${xpath.string}"</c:if>
	    <c:if test="${not empty alt}"> alt="${alt.string}"</c:if>
	    <c:if test="${not empty styleSheet}"> alt="${styleSheet.string}"</c:if>
	    <c:if test="${not empty rewriteAbsoluteUrl && rewriteAbsoluteUrl.boolean}"> rewriteabsoluteurl="true"</c:if>
	    <c:if test="${not empty continueOnError && continueOnError.boolean}"> onerror="continue"</c:if>>
		<template:area  path="${currentNode.name}" areaAsSubNode="true"/>
	</esi:include>
	
	<c:if test="${not empty includeDistantResources && includeDistantResources.boolean && not empty fragment}"> 
	<template:addResources>
		<esi:include src="${providerValue}${srcValue}"
			fragment="${fragment.string}CssAndJs" 
			onerror="continue">
		</esi:include>
	</template:addResources>
	</c:if>

</c:if>

