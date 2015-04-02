package org.jahia.modules.esigate;

import org.apache.commons.lang.StringUtils;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.filter.AbstractFilter;
import org.jahia.services.render.filter.RenderChain;

public class TemplateFilter extends AbstractFilter {
    
	@Override
	public String execute(String previousOut, RenderContext renderContext, Resource resource, RenderChain chain)
			throws Exception {
		JCRNodeWrapper node = resource.getNode();
		if (node.isNodeType("smix:esigateTemplatePage") && node.getProperty("doExecute").getBoolean()) {
			String originalPageURL = renderContext.getRequest().getParameter("originalPagePath");
			String cachedRenderContent; 
			StringBuilder builder = new StringBuilder();
			builder.append("<esi:include src=\"");

			if (StringUtils.isNotBlank(originalPageURL)) {
				String provider = node.getPropertyAsString("provider");
				if (StringUtils.isNotBlank(provider)) {
					builder.append("$(PROVIDER{");
					builder.append(provider);
					builder.append("})");
					if (!StringUtils.startsWith(originalPageURL, "/")) {
						builder.append("/");
					}
				}
				String pageUrl = StringUtils.removeStart(originalPageURL, "/cms");
				pageUrl = StringUtils.removeStart(originalPageURL, "/EBE");
				if(StringUtils.startsWith(pageUrl, "/sites")){
				    pageUrl = StringUtils.removeStart(originalPageURL, "/sites");
				    pageUrl = StringUtils.substring(pageUrl, StringUtils.indexOf(pageUrl, '/', 1));
				}

                if(StringUtils.endsWith(pageUrl, "?null")){
                    pageUrl=StringUtils.removeEnd(originalPageURL, "?null");
                }
				builder.append(pageUrl);
			} else if (node.hasProperty("src")) {
				String src = node.getPropertyAsString("src");
				if (node.hasProperty("provider")) {
					String provider = node.getPropertyAsString("provider");
					if (StringUtils.isNotBlank(provider)) {
						builder.append("$(PROVIDER{");
						builder.append(provider);
						builder.append("})");
					}
					if (!StringUtils.startsWith(src, "/")) {
						builder.append("/");
					}
				}
				if(StringUtils.endsWith(src, "?null")){
				    src=StringUtils.removeEnd(src, "?null");
				}				
				builder.append(src);
			}
			builder.append("\">");
			builder.append(previousOut);
			builder.append("</esi:include>");
			cachedRenderContent = builder.toString();
			return cachedRenderContent;
		}
		return previousOut;
	}

}
