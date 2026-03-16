package Control.TugurioSemplice;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.ProdottoDAO;

@WebServlet("/DisplayProductController")
public class DisplayProductController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	static ProdottoDAO model;
	
	static {
		model = new ProdottoDAO();
	}
	
	public DisplayProductController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		try {
			request.setAttribute("product", model.doRetrieveByKey(id));
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("Error:" + e.getMessage());
			request.setAttribute("error", "Si � verificato un errore nel database: " + e.getMessage());
		}
		
		getServletContext().getRequestDispatcher("/VisioneProdotti/ProductDetail.jsp")
			.forward(request, response);
		return;
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
	}

}
