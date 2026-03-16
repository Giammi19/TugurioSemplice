<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>

<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/confermaOrdine.css">
        <link rel="stylesheet" type="text/css" href="css/scrollbar.css">
        <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700&display=swap" rel="stylesheet">
        <title>TugurioSemplice - Conferma Ordine</title>
    </head>
    <body>
        <%@ include file="../Home/header.jsp" %>
        <div class="main-content">
            <div class="container">
                <%
                    // Recupera eventuali messaggi di errore dalla request
                    String errorMessage = (String) request.getAttribute("error");
                    OrdineBean ordine = (OrdineBean) request.getAttribute("ordine");
                    
                    if (errorMessage != null) {
                %>
                        <div class="confirmation-message error">
                            <h2>Ordine non confermato</h2>
                            <p><%= errorMessage %></p>
                            <p>Si prega di riprovare più tardi o contattare l'assistenza.</p>
                        </div>
                        
                        <div class="actions">
                            <a href="checkout.jsp" class="action-button">Riprova il checkout</a>
                            <a href="../cart.jsp" class="action-button">Torna al carrello</a>
                            <a href="../index.jsp" class="action-button">Torna alla home</a>
                        </div>
                <%
                    } else if (ordine != null) {
                        session.removeAttribute("cart");
                %>
                        <div class="confirmation-message success">
                            <h2>Ordine Confermato!</h2>
                            <p>Grazie per il tuo acquisto. Ecco i dettagli del tuo ordine:</p>
                        </div>
                        
                        <div class="delivery-info">
                            <div class="info-box">
                                <div class="info-label">Data Consegna Prevista</div>
                                <div class="info-value"><%= ordine.getSpedizione().getDataConsegna() %></div>
                            </div>
                            
                            <div class="info-box">
                                <div class="info-label">Metodo Spedizione</div>
                                <div class="info-value"><%= ordine.getSpedizione().getMetodo() %></div>
                            </div>
                            
                            <div class="info-box">
                                <div class="info-label">Totale Ordine</div>
                                <div class="info-value">€ <%= String.format("%.2f", ordine.getPrezzoOrdine() + ordine.getSpedizione().getSpese()) %></div>
                            </div>
                        </div>
                        
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/index.jsp" class="action-button">Torna alla home</a>
                        </div>
                <%
                    } 
                %>
            </div>
        </div>
        <%@ include file="../Home/footer.jsp" %>                
    </body>
</html>