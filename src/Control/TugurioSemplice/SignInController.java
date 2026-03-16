package Control.TugurioSemplice;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Model.*;

@WebServlet("/SignInController")
public class SignInController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    static ClienteDAO model = new ClienteDAO();
    
    public SignInController() {
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
            System.out.println(e);
            return null;
        }
    }
    
    // Metodi di validazione
    private boolean isNomeValid(String value) {
        return value != null && value.length() >= 2 && value.matches("^[a-zA-Zàèéìòù' ]+$");
    }
    
    private boolean isCognomeValid(String value) {
        return value != null && value.length() >= 2 && value.matches("^[a-zA-Zàèéìòù' ]+$");
    }
    
    private boolean isCfValid(String value) {
        return value == null || value.isEmpty() || value.matches("^[A-Z]{6}[0-9LMNPQRSTUV]{2}[A-Z][0-9LMNPQRSTUV]{2}[A-Z][0-9LMNPQRSTUV]{3}[A-Z]$");
    }
    
    private boolean isTelefonoValid(String value) {
        return value == null || value.isEmpty() || value.matches("^\\+?[0-9]{7,15}$");
    }
    
    private boolean isUsernameValid(String value) {
        return value != null && value.length() >= 4 && value.matches("^[a-zA-Z0-9_.]+$");
    }
    
    private boolean isEmailValid(String value) {
        return value != null && value.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    }
    
    private boolean isPasswordValid(String value) {
        return value != null && value.length() >= 8 && 
               value.matches(".*[A-Z].*") && // almeno 1 maiuscola
               value.matches(".*[a-z].*") && // almeno 1 minuscola
               value.matches(".*[0-9].*") && // almeno 1 numero
               value.matches(".*[^a-zA-Z0-9].*"); // almeno 1 simbolo
    }
    
    private boolean isCityValid(String value) {
        return value != null && value.length() >= 2 && value.matches("^[a-zA-Zàèéìòù' ]+$");
    }
    
    private boolean isProvinciaValid(String value) {
        return value != null && value.length() == 2 && value.matches("^[A-Z]{2}$");
    }
    
    private boolean isStreetValid(String value) {
        return value != null && value.length() >= 5;
    }
    
    private boolean isCapValid(String value) {
        return value != null && value.matches("^[0-9]{5}$");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupero parametri
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String passkey = request.getParameter("passkey");
        String passkey2 = request.getParameter("passkey2");
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String cf = request.getParameter("cf");
        String tel = request.getParameter("telefono");
        String city = request.getParameter("city");
        String CAP = request.getParameter("CAP");
        String street = request.getParameter("street");
        String provincia = request.getParameter("provincia");
        
        // Validazione dei campi
        boolean isValid = true;
        StringBuilder errorMessage = new StringBuilder();
        
        // Validazione Step 1 - Anagrafica
        if (!isNomeValid(nome)) {
            isValid = false;
            errorMessage.append("Nome non valido (almeno 2 lettere, solo lettere e spazi).<br>");
        }
        
        if (!isCognomeValid(cognome)) {
            isValid = false;
            errorMessage.append("Cognome non valido (almeno 2 lettere, solo lettere e spazi).<br>");
        }
        
        if (!isCfValid(cf)) {
            isValid = false;
            errorMessage.append("Codice Fiscale non valido (16 caratteri alfanumerici, solo lettere e numeri).<br>");
        }
        
        if (!isTelefonoValid(tel)) {
            isValid = false;
            errorMessage.append("Numero di telefono non valido (solo numeri, da 7 a 15 cifre, opzionale + iniziale).<br>");
        }
        
        // Validazione Step 2 - Account
        if (!isUsernameValid(username)) {
            isValid = false;
            errorMessage.append("Username non valido (almeno 4 caratteri, solo lettere, numeri, _ .).<br>");
        }
        
        if (!isEmailValid(email)) {
            isValid = false;
            errorMessage.append("Formato email non valido.<br>");
        }
        
        if (!isPasswordValid(passkey)) {
            isValid = false;
            errorMessage.append("Password non valida (min. 8 caratteri, almeno 1 maiuscola, 1 minuscola, 1 numero, 1 simbolo).<br>");
        }
        
        if (passkey == null || !passkey.equals(passkey2)) {
            isValid = false;
            errorMessage.append("Le password non corrispondono.<br>");
        }
        
        // Validazione Step 3 - Spedizione
        if (!isCityValid(city)) {
            isValid = false;
            errorMessage.append("Città non valida (almeno 2 lettere, solo lettere e spazi).<br>");
        }
        
        if (!isProvinciaValid(provincia)) {
            isValid = false;
            errorMessage.append("Provincia non valida (2 lettere maiuscole es. RM).<br>");
        }
        
        if (!isStreetValid(street)) {
            isValid = false;
            errorMessage.append("Via non valida (almeno 5 caratteri).<br>");
        }
        
        if (!isCapValid(CAP)) {
            isValid = false;
            errorMessage.append("CAP non valido (5 cifre numeriche).<br>");
        }
        
        if (!isValid) {
            request.setAttribute("error", errorMessage.toString());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/AccessoUtente/SignIn.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Se tutti i controlli sono passati, procedi con la registrazione
        try {
            DatiAnagraficiBean dati = new DatiAnagraficiBean();
            dati.setNome(nome);
            dati.setCognome(cognome);
            dati.setCf(cf);
            dati.setTelefono(tel);
            
            IndirizzoSpedizioneBean spedizione = new IndirizzoSpedizioneBean();
            spedizione.setCitta(city);
            spedizione.setCap(CAP);
            spedizione.setProvincia(provincia);
            spedizione.setVia(street);
            
            ClienteBean cliente = new ClienteBean();
            cliente.setUsername(username);
            cliente.setIsAmministratore(false);
            cliente.setEmail(email);
            cliente.setPasskey(toHash(passkey));
            cliente.setAnagrafia(dati);
            cliente.setIndirizzoSpedizione(spedizione);
            
            model.doSave(cliente);
            
            getServletContext().getRequestDispatcher("/AccessoUtente/SignInSuccess.jsp")
                .forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error:" + e.getMessage());
            request.setAttribute("error", "Si è verificato un errore nel database: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/AccessoUtente/SignIn.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}