package Control.TugurioSemplice.Admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Model.*;

@WebServlet("/ListaUtentiController")
public class ListaUtentiController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ClienteDAO model = new ClienteDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {   
        if ("true".equals(request.getServletContext().getInitParameter("debug"))) {
            doGet(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Verifica sessione e autenticazione
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/AccessoUtente/Login.jsp");
            return;
        }
        
        try {
            ClienteBean user = (ClienteBean) session.getAttribute("user");
            
            if (!user.getIsAmministratore()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accesso non autorizzato");
                return;
            }
            
            String searchQuery = request.getParameter("q");
            String[] searchTerms = new String[0];

            ArrayList<ClienteBean> listaClienti;
            
            if(searchQuery != null && !searchQuery.trim().isEmpty()) {
            	searchTerms = searchQuery.trim().split("\\s+");
                listaClienti = model.searchClients(searchTerms);
                if(listaClienti.isEmpty()) {
                    request.setAttribute("message", "Nessun utente trovato per: " + searchQuery);
                }
            } else {
                // Caricamento di tutti gli utenti
                listaClienti = model.doRetrieveAll(null);
            }
            
            
            // Imposta l'ArrayList come attributo della request
            request.setAttribute("Clienti", listaClienti);
            
            // Reindirizzamento a pagina di visualizzazione clienti
            RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminAction/ListaUtenti.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            request.setAttribute("error", "Errore durante il caricamento degli utenti: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminAction/ListaUtenti.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Si è verificato un errore imprevisto: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminAction/ListaUtenti.jsp");
            dispatcher.forward(request, response);
        }
    }
}