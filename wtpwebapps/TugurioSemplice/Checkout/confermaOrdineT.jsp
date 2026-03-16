<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<%@ page import="net.glxn.qrgen.QRCode, net.glxn.qrgen.image.ImageType, java.io.ByteArrayOutputStream, java.util.Base64" %>

<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/confermaOrdine.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/scrollbar.css">
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
                        session.removeAttribute("ordineCorrente");
                        
                        // Dati per il pagamento
                        String beneficiario = "TugurioSemplice SPA";
                        String iban = "IT60X0542811101000000123456";
                        String causale = "Pagamento ordine";
                        double importoTotale = ordine.getPrezzoOrdine() + ordine.getSpedizione().getSpese();
                        
                        // Genera QR Code
                        String qrText = String.format("BCD\n001\n1\nSCT\n\n%s\n%s\nEUR%.2f\n\n\n%s",
                                beneficiario, iban, importoTotale, causale);
                        
                        ByteArrayOutputStream qrStream = QRCode.from(qrText)
                                                    .withSize(200, 200)
                                                    .to(ImageType.PNG)
                                                    .stream();
                        String qrCodeBase64 = Base64.getEncoder().encodeToString(qrStream.toByteArray());
                %>
                        <div class="confirmation-message success">
                            <h2>Ordine Confermato!</h2>
                            <p>Grazie per il tuo acquisto. Completa il pagamento per finalizzare l'ordine:</p>
                        </div>
                        
                        <div class="payment-section">
                            <div class="qr-code-container">
                                <p>Scansiona il QR Code con la tua app bancaria:</p>
                                <img src="data:image/png;base64,<%= qrCodeBase64 %>" alt="QR Code Pagamento" class="qr-code">
                            </div>
                            
                            <div class="payment-details">
                                <div class="info-box">
                                    <div class="info-label">Importo da pagare</div>
                                    <div class="info-value">€ <%= String.format("%.2f", importoTotale) %></div>
                                </div>
                                <div class="info-box">
                                    <div class="info-label">Beneficiario</div>
                                    <div class="info-value"><%= beneficiario %></div>
                                </div>
                                <div class="info-box">
                                    <div class="info-label">IBAN</div>
                                    <div class="info-value"><%= iban %></div>
                                </div>
                                <div class="info-box">
                                    <div class="info-label">Causale</div>
                                    <div class="info-value"><%= causale %></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="delivery-info">
                            <h3>Dettagli di spedizione</h3>
                            <div class="info-box">
                                <div class="info-label">Data Consegna Prevista</div>
                                <div class="info-value">
                                    <% if(ordine.getSpedizione().getDataConsegna() == null){ %>
                                        data da definire 
                                    <% } else { %>
                                        <%= ordine.getSpedizione().getDataConsegna()%> 
                                    <% } %>
                                </div>
                            </div>
                            <div class="info-box">
                                <div class="info-label">Metodo Spedizione</div>
                                <div class="info-value"><%= ordine.getSpedizione().getMetodo() %></div>
                            </div>
                        </div>
                        
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/index.jsp" class="action-button secondary">Torna alla home</a>
                        </div>
                <%
                    } else {
                        response.sendRedirect(request.getContextPath() + "/errore.jsp?msg=Nessun ordine trovato");
                    }
                %>
            </div>
        </div>
        <%@ include file="../Home/footer.jsp" %>                
    </body>
</html>