package Control.TugurioSemplice.Admin;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import Model.ProdottoBean;
import Model.ProdottoDAO;

@WebServlet("/UpdateProductController")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UpdateProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String SAVE_DIR = "photo";

    static ProdottoDAO model;
    
    static {
        model = new ProdottoDAO();
    }
    
    public UpdateProductController() {
        super();
    }

    private String extractFileName(Part part) {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ProdottoBean bean = model.doRetrieveByKey(id);
            request.setAttribute("prodotto", bean);
            request.getRequestDispatcher("/AdminAction/ModificaAdmin.jsp")
                .forward(request, response);
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid product ID or database error");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Parse basic product info
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            // Get the current image path from hidden field
            String currentImage = request.getParameter("currentImage");
            String imagePath = currentImage; // Default to current image
            
            // Handle image upload
            Part imagePart = request.getPart("image");
            
            // If new image was uploaded
            if (imagePart != null && imagePart.getSize() > 0) {
                String appPath = request.getServletContext().getRealPath("");
                String savePath = appPath + File.separator + SAVE_DIR;
                
                // Create save directory if it doesn't exist
                File fileSaveDir = new File(savePath);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdir();
                }
                
                String fileName = extractFileName(imagePart);
                if (fileName != null && !fileName.isEmpty()) {
                    // Save the new image
                    imagePart.write(savePath + File.separator + fileName);
                    // Update image path (relative path for web access)
                    imagePath = SAVE_DIR + "/" + fileName;
                }
            }
            
            // Create product bean
            ProdottoBean bean = new ProdottoBean();
            bean.setIdProdotto(id);
            bean.setNome(name);
            bean.setDescrizione(description);
            bean.setPrezzoBase(price);
            bean.setQuantita(quantity);
            bean.setDisponibilita(quantity > 0);
            bean.setIva(22);
            bean.setImmagine(imagePath); // Set either new image or keep current
            
            // Update product in database
            model.doUpdate(bean);
            
            // Redirect to product detail page
            response.sendRedirect(request.getContextPath() + "/product");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Input numerico non valido");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Errore database: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Errore: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}