<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- <%@ taglib prefix="eca" uri="http://www.europcar.com/tags/functions"%> --%>

<jcr:nodeProperty node="${currentNode}" var="image" name="image" />
<c:if test="${empty image.node && renderContext.editMode}">
	Click here to add an image
</c:if>
<c:if test="${not empty image.node}">
	<img src="${image.node.url}" alt="alt" />
</c:if>