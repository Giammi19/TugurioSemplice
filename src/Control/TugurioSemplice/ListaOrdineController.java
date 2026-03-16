package Control.TugurioSemplice;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Model.*;

@WebServlet("/ListaOrdineController")
public class ListaOrdineController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrdineDAO model = new OrdineDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/AccessoUtente/Login.jsp");
            return;
        }
        
        try {
            ClienteBean user = (ClienteBean) session.getAttribute("user");
            int idClienteParam = Integer.parseInt(request.getParameter("idCliente"));
            
            if (user.getIdCliente() != idClienteParam && !user.getIsAmministratore()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accesso non autorizzato");
                return;
            }
            
            String dataInizio = request.getParameter("dataInizio");
            String dataFine = request.getParameter("dataFine");
            
            // Validazione date
            if (dataInizio != null && dataInizio.isEmpty()) {
                dataInizio = null;
            }
            if (dataFine != null && dataFine.isEmpty()) {
                dataFine = null;
            }
            
            ArrayList<OrdineBean> listaOrdini;
            
            if (dataInizio == null && dataFine == null) {
                listaOrdini = model.doRetrieveByCliente(idClienteParam);
            } else {
                // Altrimenti usa il filtro per date
                listaOrdini = model.doRetrieveByDate(idClienteParam, dataInizio, dataFine);
            }
            
            ArrayList<OrdineBean> ordiniCompleti = new ArrayList<>();
            for (OrdineBean ordine : listaOrdini) {
                OrdineBean ordineCompleto = model.doRetrieveByKey(ordine.getIdOrdine());
                ordiniCompleti.add(ordineCompleto);
            }
            
            session.setAttribute("listaOrdini", ordiniCompleti);

            if (dataInizio != null) {
                session.setAttribute("dataInizioFiltro", dataInizio);
            }
            if (dataFine != null) {
                session.setAttribute("dataFineFiltro", dataFine);
            }
            
            // Reindirizzamento a pagina di visualizzazione ordini
            if (request.getParameter("ADMIN") == null) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/AuthSites/OrdiniUtente.jsp");
                dispatcher.forward(request, response);
            } else {
                ClienteDAO utente = new ClienteDAO();
                ClienteBean cliente = utente.doRetrieveByKey(idClienteParam);
                session.setAttribute("Cliente", cliente);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminAction/DettagliUtente.jsp");
                dispatcher.forward(request, response);           	
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID cliente non valido");
            request.getRequestDispatcher("/ErrorPage/500.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Errore durante il caricamento degli ordini: " + e.getMessage());
            request.getRequestDispatcher("/ErrorPage/500.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Si è verificato un errore imprevisto: " + e.getMessage());
            request.getRequestDispatcher("/ErrorPage/500.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported");
    }
}