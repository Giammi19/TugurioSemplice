package Control.TugurioSemplice;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.*; 

public class CartaCreditoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartaCreditoDAO cartaCreditoDAO;

    public void init() throws ServletException {
        super.init();
        cartaCreditoDAO = new CartaCreditoDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/AccessoUtente/Login.jsp");
            return;
        }

        ClienteBean user = (ClienteBean) session.getAttribute("user");
        int idCliente = user.getIdCliente();
        String spedizione = request.getParameter("spedizione");

        CartaCreditoBean carta = null;
        try {
            carta = cartaCreditoDAO.doRetrieveByKey(idCliente);
            request.setAttribute("spedizione", spedizione);

            if (carta != null) {
                request.setAttribute("cartaCredito", carta);
                request.getRequestDispatcher("/Checkout/CartaCredito.jsp").forward(request, response);
            } else {
                request.setAttribute("message", "Nessuna carta di credito trovata per questo utente.");
                request.getRequestDispatcher("/Checkout/CartaCredito.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Errore durante il recupero dei dati della carta di credito: " + e.getMessage());
            request.getRequestDispatcher("/ErrorPage/500.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported for this URL.");
    }
}