<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/checkout.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/scrollbar.css">
        <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">     
        <title>TugurioSemplice - Checkout</title>
    </head>
    <body>
        <img src="photo/logo.png" alt="logo" class="logo">
        <div class="container">
            <h1>Completa il tuo ordine</h1>
            
            <div class="checkout-section">
                <div class="checkout-form">
                    <div class="user-info">
                        <h2>Informazioni personali</h2>
                        <% 
                            ClienteBean user = (ClienteBean) request.getAttribute("user");
                        %>
                        <p><%= user.getAnagrafia().getNome() %> <%= user.getAnagrafia().getCognome() %></p>
                        <p><%= user.getEmail() %></p>
                        <p><%= user.getIndirizzoSpedizione()%></p>
                    </div>    
                    
                    <form action="${pageContext.request.contextPath}/PagamentoController" method="post" class="payment-section">
                        <h2>Metodo di pagamento</h2>
                        
                        <div class="form-group">
                            <label for="pagamento">Scegli il pagamento</label>
                            <select id="pagamento" name="pagamento" required>
                                <option value="">-- Seleziona --</option>
                                <option value="Carta">Carta di credito</option>
                                <option value="Contanti">Contanti al tabacchino</option>
                            </select>
                        </div>      
                        
                        <div class="form-group">
                            <label for="spedizione">Scegli il metodo di spedizione *:</label>
                            <select id="spedizione" name="spedizione" required>
                                <option value="">-- Seleziona metodo di spedizione --</option>
                                <option value="Trasporto funebre">Trasporto funebre</option>
                                <option value="Consegna a domicilio">Consegna a domicilio</option>
                                <option value="Ritiro in negozio">Ritiro in negozio</option>
                            </select>
                        </div>                                     
                        
                        <button type="submit">Conferma ordine</button>
                    </form>
                </div>
                
                <div class="order-summary">
                    <h2>Riepilogo ordine</h2>
                    <% 
                        List<ProdottoBean> cartItems = (List<ProdottoBean>) request.getAttribute("cartItems");
                        Map<Integer, Integer> quantities = (Map<Integer, Integer>) request.getAttribute("quantities");
                        Double totalAmount = (Double) request.getAttribute("totalAmount");
                        
                        if (cartItems != null && !cartItems.isEmpty()) {
                            for (ProdottoBean product : cartItems) {
                                int quantity = quantities.get(product.getIdProdotto());
                    %>
                    <div class="order-item">
                        <div>
                            <%= product.getNome() %> x <%= quantity %>
                        </div>
                        <div>
                            € <%= String.format("%.2f", product.getPrezzoBase() * quantity) %>
                        </div>
                    </div>
                    <% 
                            }
                    %>
                    <div class="total">
                        <div>Totale:</div>
                        <div>€ <%= String.format("%.2f", totalAmount) %></div>
                    </div>
                    <% } else { %>
                        <p>Il carrello è vuoto.</p>
                    <% } %>
                </div>
            </div>
        </div>
        
        <%@ include file="../Home/footer.jsp" %>
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const paymentSection = document.querySelector('.payment-section');
                const checkoutSection = document.querySelector('.checkout-section');
                const checkoutForm = document.querySelector('.checkout-form');
                
                function movePaymentSection() {
                    if (window.innerWidth <= 768) {
                        // In modalità mobile, sposta al fondo del checkout section
                        checkoutSection.appendChild(paymentSection);
                    } else {
                        // In modalità desktop, rimetti nella checkout form
                        checkoutForm.appendChild(paymentSection);
                    }
                }
                
                // Esegui all'inizio e al ridimensionamento
                movePaymentSection();
                window.addEventListener('resize', movePaymentSection);
            });
        </script>               
    </body>
</html>