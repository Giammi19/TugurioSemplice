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
import Model.ClienteDAO;
import Model.DatiAnagraficiBean;
import Model.IndirizzoSpedizioneBean;

@WebServlet("/ModificaUtenteController")
public class ModificaUtenteController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public ModificaUtenteController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        ClienteBean currentUser = (ClienteBean) session.getAttribute("user");
        
        // Verifica che l'utente sia loggato
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/AccessoUtente/Login.jsp");
            return;
        }
        
        try {
            // Recupera e valida i parametri
            int idCliente = Integer.parseInt(request.getParameter("idCliente"));
            
            // Controlla che l'utente stia modificando i propri dati
            if (currentUser.getIdCliente() != idCliente) {
                response.sendRedirect(request.getContextPath() + "/403.jsp?message=Non hai i permessi per modificare questi dati");
                return;
            }
            
            // Crea l'oggetto utente aggiornato
            ClienteBean updatedUser = createUpdatedUser(request, currentUser);
            
            // Aggiorna i dati nel database
            new ClienteDAO().doUpdate(updatedUser);
            
            // Aggiorna la sessione con i nuovi dati
            session.setAttribute("user", updatedUser);
            
            // Reindirizza con messaggio di successo
            response.sendRedirect(request.getContextPath() + "/AuthSites/AreaUtente.jsp?message=Dati aggiornati con successo");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/403.jsp?message=ID cliente non valido");
        } catch (SQLException e) {
        	response.sendRedirect(request.getContextPath() + "/ErrorPage/500.jsp?message=Errore durante l'aggiornamento dei dati");
        }
    }

    private ClienteBean createUpdatedUser(HttpServletRequest request, ClienteBean currentUser) {
        ClienteBean updatedUser = new ClienteBean();
        updatedUser.setIdCliente(currentUser.getIdCliente());
        updatedUser.setUsername(request.getParameter("username"));
        updatedUser.setEmail(request.getParameter("email"));
        
        // Gestione password (mantieni quella esistente se non viene fornita una nuova)
        String password = request.getParameter("password");
        updatedUser.setPasskey((password != null && !password.trim().isEmpty()) ? 
                             password : currentUser.getPasskey());
        
        updatedUser.setIsAmministratore(currentUser.getIsAmministratore());
        
        // Dati anagrafici
        DatiAnagraficiBean datiAnagrafici = new DatiAnagraficiBean();
        datiAnagrafici.setNome(request.getParameter("nome"));
        datiAnagrafici.setCognome(request.getParameter("cognome"));
        datiAnagrafici.setCf(request.getParameter("codiceFiscale"));
        datiAnagrafici.setTelefono(request.getParameter("telefono"));
        updatedUser.setAnagrafia(datiAnagrafici);
        
        // Indirizzo spedizione
        IndirizzoSpedizioneBean indirizzo = new IndirizzoSpedizioneBean();
        indirizzo.setVia(request.getParameter("via"));
        indirizzo.setCitta(request.getParameter("citta"));
        indirizzo.setCap(request.getParameter("cap"));
        indirizzo.setProvincia(request.getParameter("provincia"));
        updatedUser.setIndirizzoSpedizione(indirizzo);
        
        return updatedUser;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/AuthSites/AreaUtente.jsp");
    }
}
