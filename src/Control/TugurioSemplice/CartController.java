package Control.TugurioSemplice;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.*;

@WebServlet("/CartController")
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProdottoDAO model;
    private static final String CART_COOKIE_NAME = "cartId";
    private static final int COOKIE_MAX_AGE = 30 * 24 * 60 * 60; // 30 giorni in secondi
    
    @Override
    public void init() throws ServletException {
        super.init();
        model = new ProdottoDAO();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        //Recupera o crea il carrello dalla sessione
        Cart cart = (Cart) request.getSession().getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            request.getSession().setAttribute("cart", cart);
        }

        String action = request.getParameter("action");

        

        try {
            if (action != null) {
                switch (action.toLowerCase()) {
                    case "addc":
                    	int quantity = Integer.parseInt(request.getParameter("quantity"));
                        addProductToCart(request, cart, quantity);
                        break;
                    case "delete":
                        deleteProductFromCart(request, cart);
                        break;
                    case "update":
                        updateProductQuantity(request, cart);
                        break;
                    case "clear":
                        cart.clear();
                        break;
                    case "read":
                        readProduct(request);
                        break;
                    default:
                        break;
                }
            }            
        } catch (SQLException e) {
            handleError("Database error: " + e.getMessage(), e, request, response);
            return;
        } catch (NumberFormatException e) {
            handleError("Invalid number format: " + e.getMessage(), e, request, response);
            return;
        }

        //Salva il carrello aggiornato in sessione
        request.getSession().setAttribute("cart", cart);

        response.sendRedirect("cart.jsp");
        return;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }


    // ======= METODI AUSILIARI PRIVATI =======

    private void addProductToCart(HttpServletRequest request, Cart cart, int quantity) throws SQLException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            ProdottoBean product = model.doRetrieveByKey(id);
            if (product != null) {
                cart.addProduct(product, quantity);
            }
        }
    }

    private void deleteProductFromCart(HttpServletRequest request, Cart cart) throws SQLException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            ProdottoBean product = model.doRetrieveByKey(id);
            if (product != null) {
                cart.deleteProduct(product);
            }
        }
    }

    private void updateProductQuantity(HttpServletRequest request, Cart cart) throws SQLException {
        String idParam = request.getParameter("id");
        String quantityParam = request.getParameter("quantity");
        if (idParam != null && quantityParam != null) {
            int id = Integer.parseInt(idParam);
            int quantity = Integer.parseInt(quantityParam);
            cart.updateQuantity(id, quantity);
        }
    }

    private void readProduct(HttpServletRequest request) throws SQLException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            request.setAttribute("product", model.doRetrieveByKey(id));
        }
    }

    private void handleError(String message, Exception e, HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.err.println(message);
        request.setAttribute("errorMessage", message);
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("ErrorPage/500.jsp");
        dispatcher.forward(request, response);
    }
}