package Control.TugurioSemplice;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.ProdottoDAO;
import Model.ProdottoBean;

@WebServlet("/DisplayProductCatalogue")
public class DisplayProductCatalogue extends HttpServlet {
	private static final long serialVersionUID = 1L;

	static ProdottoDAO model;

	static {
		model = new ProdottoDAO();
	}

	public DisplayProductCatalogue() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String sort = request.getParameter("sort");
		if(sort == null || sort.isEmpty()) {
			sort = "Nome"; 
		}

		try {
			request.setAttribute("products", model.doRetrieveFiltered(sort));
			
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
			request.setAttribute("error", "Si è verificato un errore nel recupero dei prodotti: " + e.getMessage());
		}
		String searchQuery = request.getParameter("q");
		if(searchQuery != null && !searchQuery.trim().isEmpty()) {
		    // Filtra i prodotti in base alla ricerca
		    ProdottoDAO prodottoDAO = new ProdottoDAO();
		    Collection<ProdottoBean> filteredProducts;
			try {
				filteredProducts = prodottoDAO.searchProducts(searchQuery);
				request.setAttribute("products", filteredProducts);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		RequestDispatcher dispatcher = request.getRequestDispatcher("./VisioneProdotti/ProductView.jsp");
		dispatcher.forward(request, response);

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
	}
}
