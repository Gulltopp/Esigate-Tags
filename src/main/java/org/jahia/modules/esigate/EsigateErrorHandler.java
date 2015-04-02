package org.jahia.modules.esigate;

import java.io.IOException;

import javax.jcr.PathNotFoundException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jahia.bin.errors.ErrorHandler;
import org.jahia.services.render.URLResolver;
import org.jahia.services.render.URLResolverFactory;

public class EsigateErrorHandler implements ErrorHandler {
	private URLResolverFactory urlResolverFactory;

	public void setUrlResolverFactory(URLResolverFactory urlResolverFactory) {
		this.urlResolverFactory = urlResolverFactory;
	}

	@Override
	public boolean handle(Throwable e, HttpServletRequest request, HttpServletResponse response) throws IOException,
			ServletException {
		if (!(e instanceof PathNotFoundException)) {
			return false;
		}
		String originalPagePath;
		String path = request.getPathInfo();
		int i = path.indexOf("/EBE/");
		if( i != -1 ) {
			originalPagePath = path.substring(i);
		} else {
			URLResolver urlResolver = urlResolverFactory.createURLResolver(request.getPathInfo(), request.getServerName(),
				request);
			originalPagePath = urlResolver.getPath();
		}
		// request.getSession().setAttribute("originalPagePath", originalPagePath);
		request.setAttribute("originalPagePath", originalPagePath);
		return false;
	}

}
