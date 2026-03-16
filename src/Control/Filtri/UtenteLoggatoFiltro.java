package Control.Filtri;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
	    "/Checkout/*", 
	    "/AuthSites/*"
	})
public class UtenteLoggatoFiltro extends HttpFilter implements Filter {
       
    private static final long serialVersionUID = 1L;

    public UtenteLoggatoFiltro() {
        super();
    }

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		
		final HttpServletRequest httpRequest = (HttpServletRequest) request;
		final HttpServletResponse httpResponse = (HttpServletResponse) response;
		
		final HttpSession session = httpRequest.getSession(false);
		
		if(session == null) {
			httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED);
			return;
		}
		
		final boolean isLoggedIn = session.getAttribute("user") != null;
		
		if(isLoggedIn) {
			chain.doFilter(request, response);
		} else {
			final String requestedRoute = getServletContext().getContextPath() + httpRequest.getServletPath();
			
			session.setAttribute("requestedRoute", requestedRoute);
			httpResponse.sendRedirect(getServletContext().getContextPath() + "/login");
		}
	}

}

