package Control.TugurioSemplice;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Model.*;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public LoginController() {
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
        String password = toHash(request.getParameter("password"));
        
        try {
            ClienteBean user = null;
            if (usemail != null && usemail.contains("@")) {
                user = new ClienteDAO().doRetrieveByEmail(usemail);
            } else if (usemail != null && !usemail.isEmpty()) {
                user = new ClienteDAO().doRetrieveByUsername(usemail);
            }
            
            if (user != null && user.getPasskey() != null && user.getPasskey().equals(password)) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60);
                manageCartCookie(request, response);
                
                response.sendRedirect("product");
            } else {
                request.setAttribute("error", "Accesso fallito. Controlla le credenziali");
                RequestDispatcher dispatcher = request.getRequestDispatcher("./AccessoUtente/Login.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            System.err.println("Errore SQL durante il login: " + e.getMessage());
            request.setAttribute("error", "Errore durante il login. Riprova più tardi.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("./AccessoUtente/Login.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void manageCartCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("carrello")) {
                    cookie.setMaxAge(7 * 24 * 60 * 60);
                    response.addCookie(cookie);
                    break;
                }
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        response.sendRedirect("./AccessoUtente/Login.jsp");
    }
}