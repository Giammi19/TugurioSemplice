package Control.Filtri;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import Model.ClienteBean;

@WebFilter(value = {"/AdminAction/*"})
public class AdminFiltro extends UtenteLoggatoFiltro  {
    private static final long serialVersionUID = 1L;

	public AdminFiltro() {
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
		
        final ClienteBean user = (ClienteBean) session.getAttribute("user");
        final boolean isAdmin = (user != null && user.getIsAmministratore());
		
		if(isAdmin) {
			chain.doFilter(request, response);
		} else {
			httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
		}
	}
}