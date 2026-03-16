package Control.TugurioSemplice;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.*;

@WebServlet("/OrdineController")
public class OrdineController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    static OrdineDAO model = new OrdineDAO();
    static CartaCreditoDAO model2 = new CartaCreditoDAO();
    
    private boolean isNomeValid(String value) {
        if (value == null) return false;
        String trimmed = value.trim();
        return trimmed.length() >= 2 && 
               trimmed.length() <= 50 && 
               trimmed.matches("^[a-zA-ZàèéìòùÀÈÉÌÒÙ'\\s]+$");
    }

    private boolean isCognomeValid(String value) {
        return isNomeValid(value);
    }

    private boolean isNumeroCartaValid(String value) {
        if (value == null) return false;
        String cleaned = value.replace(" ", "");
        return cleaned.length() == 16 && cleaned.matches("\\d+");
    }

    private boolean isCvvValid(String value) {
        return value != null && value.matches("^\\d{3}$");
    }

    private boolean isScadenzaValid(String value) {
        if (value == null || !value.matches("^\\d{2}/\\d{2}$")) {
            return false;
        }
        
        String[] parts = value.split("/");
        int month = Integer.parseInt(parts[0]);
        int year = 2000 + Integer.parseInt(parts[1]);
        
        // Controlla validità mese
        if (month < 1 || month > 12) {
            return false;
        }
        
        // Controlla che non sia scaduta
        Calendar now = Calendar.getInstance();
        int currentYear = now.get(Calendar.YEAR);
        int currentMonth = now.get(Calendar.MONTH) + 1;
        
        return year > currentYear || (year == currentYear && month >= currentMonth);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Verifica sessione e autenticazione
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/AccessoUtente/Login.jsp");
            return;
        }
        
        // Verifica presenza carrello
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getProducts().isEmpty()) {
            request.setAttribute("error", "Il carrello e' vuoto");
            request.getRequestDispatcher("./cart.jsp").forward(request, response);
            return;
        }
        
        try {
            ClienteBean user = (ClienteBean) session.getAttribute("user");
            String metodo = request.getParameter("spedizione");
            String metodoP = request.getParameter("pagamento");
            boolean isValid = true;
            StringBuilder errorMessage = new StringBuilder();
            
            CartaCreditoBean carta = new CartaCreditoBean();
            if(!metodoP.equals("Contanti")) {
                String nome = request.getParameter("nome");
                String cognome = request.getParameter("cognome");
                String numero = request.getParameter("numero");
                String scadenza = request.getParameter("scadenza");
                String cvv = request.getParameter("cvv");
                if (!isNomeValid(nome)) {
                    isValid = false;
                    errorMessage.append("Nome non valido (almeno 2 lettere, solo lettere e spazi).<br>");
                }
                if (!isCognomeValid(cognome)) {
                    isValid = false;
                    errorMessage.append("Cognome non valido (almeno 2 lettere, solo lettere e spazi).<br>");
                }
                if (!isNumeroCartaValid(numero)) {
                    isValid = false;
                    errorMessage.append("Numero carta non valido (16 caratteri numerici).<br>");
                }
                
                if (!isCvvValid(cvv)) {
                    isValid = false;
                    errorMessage.append("Cvv non valido (3 caratteri numerici).<br>");
                }
                if (!isScadenzaValid(scadenza)) {
                    isValid = false;
                    errorMessage.append("Scadenza non valida non valido.<br>");
                }
                
                if (!isValid) {
                    request.setAttribute("error", errorMessage.toString());
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/cart.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
                
                carta.setNome(nome);
                carta.setCognome(cognome);
                carta.setNumeroCarta(numero);
                carta.setScadenza(scadenza);
                carta.setCvv(cvv);
                carta.setIdCliente(user.getIdCliente());   
            }
            
            // Creazione spedizione bean
            SpedizioneBean spedizione = new SpedizioneBean();
            spedizione.setMetodo(metodo);
            spedizione.setSpese(50.00);
            
            // Creazione pagamento bean
            PagamentoBean pagamento = new PagamentoBean();
            double totalPrice = cart.getTotalPrice() + 50.00;
            pagamento.setImporto(totalPrice);
            pagamento.setMetodo(metodoP);
            
            
            // Creazione e configurazione dell'ordine
            OrdineBean ordine = new OrdineBean();
            ordine.setIdCliente(user.getIdCliente());
            ordine.setSpedizione(spedizione);
            ordine.setPagamento(pagamento);
            ordine.setStatoOrdine("non consegnato");
            ordine.setPrezzoOrdine(cart.getTotalPrice());
            
            
            // Preparazione prodotti per l'ordine
            ArrayList<ProdottoOrdineBean> orderProducts = new ArrayList<>();
            for (ProdottoBean prodotto : cart.getProducts()) {
                ProdottoOrdineBean orderProduct = new ProdottoOrdineBean();
                orderProduct.setIdProdottoOrdine(prodotto.getIdProdotto());
                orderProduct.setNome(prodotto.getNome());
                orderProduct.setPrezzoBase(prodotto.getPrezzoBase());
                orderProduct.setIva(prodotto.getIva());
                
                int cartQuantity = cart.getQuantity(prodotto.getIdProdotto());
                orderProduct.setQuantita(cartQuantity);
                System.out.println(orderProduct);
                orderProducts.add(orderProduct);
            }
            
            ordine.setProdotti(orderProducts);
            
            // Impostazione data consegna e data pagamento in base al metodo di pagamento
            if(metodoP.equals("Contanti")) {
                ordine.getSpedizione().setDataConsegna(null);
                ordine.getPagamento().setDataPagamento(null);
            } else {
                Date oggi = new Date();
                Date dataConsegna = new Date(oggi.getTime() + (7L * 24 * 60 * 60 * 1000));
                ordine.getSpedizione().setDataConsegna(dataConsegna);
                // Per i pagamenti non in contanti, la data di pagamento � la data corrente
                ordine.getPagamento().setDataPagamento(oggi);
            }
            
            if(!metodoP.equals("Contanti")) {
                if(model2.doRetrieveByKey(user.getIdCliente()) == null)
                    model2.doSave(carta);
                else if(!model2.doRetrieveByKey(user.getIdCliente()).equals(carta))
                {
                    request.setAttribute("error", "Errore carta errata");
                    response.sendRedirect("./cart.jsp");
                    return;
                }
            }
            
            // Salvataggio ordine nel database prima di aggiornare le scorte
            model.doSave(ordine);
            
            // Aggiornamento scorte prodotti nel database
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            for (ProdottoBean prodotto : cart.getProducts()) {
                ProdottoBean dbProduct = prodottoDAO.doRetrieveByKey(prodotto.getIdProdotto());
                int newQuantity = dbProduct.getQuantita() - cart.getQuantity(prodotto.getIdProdotto());
                dbProduct.setQuantita(newQuantity);
                
                if (newQuantity <= 0) {
                    dbProduct.setDisponibilita(false);
                }
                
                prodottoDAO.doUpdate(dbProduct);
            }
            
            // Pulizia del carrello dopo l'ordine completato
            session.removeAttribute("cart");
            
            // Reindirizzamento in base al metodo di pagamento
            if(metodoP.equals("Contanti")) {
                request.setAttribute("ordine", ordine);
                System.out.println(ordine.getIdOrdine());
                request.getRequestDispatcher("/Checkout/confermaOrdineT.jsp").forward(request, response);
            } else {
                request.setAttribute("ordine", ordine);
                request.getRequestDispatcher("/Checkout/confermaOrdine.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Errore durante il salvataggio dell'ordine: " + e.getMessage());
            request.getRequestDispatcher("./cart.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Errore generico: " + e.getMessage());
            request.getRequestDispatcher("./cart.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported");
    }
}