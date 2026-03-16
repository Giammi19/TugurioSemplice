package Control.TugurioSemplice;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.*;

@WebServlet("/PagamentoController")
public class PagamentoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String Metodo = request.getParameter("pagamento");
        if(Metodo.equals("Carta")) {
        	RequestDispatcher dispatcher = request.getRequestDispatcher("CartaCreditoController");
            dispatcher.forward(request, response);
        } else if(Metodo.equals("Contanti")) {
        	RequestDispatcher dispatcher = request.getRequestDispatcher("OrdineController");
            dispatcher.forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported");
    }
}