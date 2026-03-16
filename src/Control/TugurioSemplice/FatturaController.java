package Control.TugurioSemplice;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Model.ClienteBean;
import Model.OrdineBean;
import Model.OrdineDAO;

@WebServlet("/FatturaController")
public class FatturaController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        ClienteBean utente = (ClienteBean) session.getAttribute("user");
        
        // Verifica che l'utente sia loggato
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/AccessoUtente/Login.jsp");
            return;
        }
        
        // Recupera l'ID ordine dalla richiesta
        String idOrdineParam = request.getParameter("idOrdine");
        if (idOrdineParam == null || idOrdineParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/errore.jsp?msg=ID+ordine+non+valido");
            return;
        }
        
        try {
            int idOrdine = Integer.parseInt(idOrdineParam);
            OrdineDAO ordineDAO = new OrdineDAO();
            
            // Recupera l'ordine dal database
            OrdineBean ordine = ordineDAO.doRetrieveByKey(idOrdine);
            
            // Verifica che l'ordine esista e appartenga all'utente
            if (ordine == null || ordine.getIdCliente() != utente.getIdCliente()) {
                response.sendRedirect(request.getContextPath() + "/errore.jsp?msg=Ordine+non+trovato+o+non+autorizzato");
                return;
            }
            
            // Imposta gli attributi nella request per la JSP
            request.setAttribute("ordine", ordine);
            request.setAttribute("dettagliOrdine", ordineDAO.getDettagliOrdine(idOrdine));
            request.setAttribute("pagamento", ordineDAO.retrievePayment(idOrdine));
            request.setAttribute("spedizione", ordineDAO.retrieveShipping(idOrdine));
            
            // Reindirizza alla pagina Fattura.jsp
            request.getRequestDispatcher("/Fattura.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/errore.jsp?msg=ID+ordine+non+valido");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/errore.jsp?msg=Errore+database");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}