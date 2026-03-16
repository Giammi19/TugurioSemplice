package Control.TugurioSemplice;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Model.*;

@WebServlet("/RecuperoController")
public class RecuperoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public RecuperoController() {
        super();
    }
    
    private String toHash(String password) {
        try {
            java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-512");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (java.security.NoSuchAlgorithmException e) {
            System.err.println("Errore durante l'hashing della password: " + e.getMessage());
            return null;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String usemail = request.getParameter("usemail");
        String newPassword = request.getParameter("NewPassword");
        String newPassword2 = request.getParameter("NewPassword2");
        
        // Validazione input
        if (usemail == null || usemail.isEmpty() || newPassword == null || newPassword.isEmpty() || 
            !newPassword.equals(newPassword2)) {
            handleError(request, response, "Dati non validi o password non corrispondenti");
            return;
        }
        
        String hashedPassword = toHash(newPassword);
        if (hashedPassword == null) {
            handleError(request, response, "Errore durante la generazione della password");
            return;
        }
        
        try {
            ClienteBean user = retrieveUser(usemail);
            
            if (user == null) {
                handleError(request, response, "Utente non trovato");
                return;
            }
            
            // Aggiorna la password
            user.setPasskey(hashedPassword);
            new ClienteDAO().doUpdate(user);
            
            // Reindirizza al login con messaggio di successo
            request.setAttribute("success", "Password aggiornata con successo");
            RequestDispatcher dispatcher = request.getRequestDispatcher("./AccessoUtente/Login.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("Errore SQL durante il recupero password: " + e.getMessage());
            handleError(request, response, "Errore durante il recupero. Riprova più tardi.");
        }
    }
    
    private ClienteBean retrieveUser(String usemail) throws SQLException {
        if (usemail.contains("@")) {
            return new ClienteDAO().doRetrieveByEmail(usemail);
        } else {
            return new ClienteDAO().doRetrieveByUsername(usemail);
        }
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        RequestDispatcher dispatcher = request.getRequestDispatcher("./AccessoUtente/Recupero.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("./AccessoUtente/RecuperoPassword.jsp");
    }
}