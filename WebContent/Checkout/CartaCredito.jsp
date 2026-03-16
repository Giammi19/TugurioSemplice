<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/screen.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/scrollbar.css">
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
    <title>Pagamento con Carta di Credito</title>
</head>
<body>
<img src="photo/logo.png" alt="logo" class="logo">
    <div class="container">
        <h2>Inserisci i dati della carta</h2>

        <%
            CartaCreditoBean carta = (CartaCreditoBean) request.getAttribute("cartaCredito");
            boolean hasExistingCard = carta != null;
            
            String nomeIntestatario = "";
            String cognomeIntestatario = "";
            String numeroCarta = "";
            String dataScadenza = "";
            String rawCardNumber = "";

            if (hasExistingCard) {
                nomeIntestatario = carta.getNome() != null ? carta.getNome() : "";
                cognomeIntestatario = carta.getCognome() != null ? carta.getCognome() : "";
                rawCardNumber = carta.getNumeroCarta() != null ? carta.getNumeroCarta() : "";
                
                if (carta.getNumeroCarta() != null && carta.getNumeroCarta().length() == 16) {
                    String rawNumber = carta.getNumeroCarta();
                    numeroCarta = rawNumber.substring(0, 4) + " " +
                                  rawNumber.substring(4, 8) + " " +
                                  rawNumber.substring(8, 12) + " " +
                                  rawNumber.substring(12, 16);
                }

                if (carta.getScadenza() != null && carta.getScadenza().length() >= 5) {
                    String scadenzaCompleta = carta.getScadenza();
                    dataScadenza = scadenzaCompleta.substring(0, 2) + "/" + scadenzaCompleta.substring(scadenzaCompleta.length() - 2);
                }
            }
        %>

        <form action="OrdineController" method="post">
            <% if (hasExistingCard) { %>
                <div class="form-group">
                    <p style="font-weight: bold;">Stai utilizzando la carta registrata:</p>
                    <p><%= nomeIntestatario %> <%= cognomeIntestatario %></p>
                    <p>•••• •••• •••• <%= rawCardNumber.substring(12) %></p>
                    <p>Scadenza: <%= dataScadenza %></p>
                    
                    <input type="hidden" name="nome" value="<%= nomeIntestatario %>">
                    <input type="hidden" name="cognome" value="<%= cognomeIntestatario %>">
                    <input type="hidden" name="numero" value="<%= rawCardNumber %>">
                    <input type="hidden" name="scadenza" value="<%= carta.getScadenza() %>">
                </div>
                
                <div class="form-group">
                    <label for="cvv">CVV *:</label>
                    <input type="text" id="cvv" name="cvv" required 
                           placeholder="3 cifre" 
                           maxlength="3"
                           autocomplete="cc-csc">
                    <small style="color: grey;">Codice di sicurezza a 3 cifre sul retro della carta</small>
                </div>
            <% } else { %>
                <div class="form-group">
                    <label for="nome">Nome intestatario *:</label>
                    <input type="text" id="nome" name="nome" required 
                           placeholder="Nome come appare sulla carta" 
                           value="<%= nomeIntestatario %>"
                           maxlength="50">
                </div>
                
                <div class="form-group">
                    <label for="cognome">Cognome intestatario *:</label>
                    <input type="text" id="cognome" name="cognome" required 
                           placeholder="Cognome come appare sulla carta" 
                           value="<%= cognomeIntestatario %>"
                           maxlength="50">
                </div>
                
                <div class="form-group">
                    <label for="numero">Numero carta *:</label>
                    <input type="text" id="numero" name="numero" required 
                           placeholder="XXXX XXXX XXXX XXXX"
                           value="<%= numeroCarta %>"
                           maxlength="19"
                           autocomplete="cc-number">
                </div>

                <div class="form-group">
                    <label for="scadenza">Data scadenza *:</label>
                    <input type="text" id="scadenza" name="scadenza" required 
                           placeholder="MM/AA" 
                           maxlength="5" 
                           value="<%= dataScadenza %>"
                           autocomplete="cc-exp">
                </div>

                <div class="form-group">
                    <label for="cvv">CVV *:</label>
                    <input type="text" id="cvv" name="cvv" required 
                           placeholder="3 cifre" 
                           maxlength="3"
                           autocomplete="cc-csc">
                    <small style="color: grey;">Codice di sicurezza a 3 cifre sul retro della carta</small>
                </div>
            <% } %>

            <input type="hidden" name="pagamento" value="Carta">
            <input id="spedizione" type="hidden" name="spedizione" value="${spedizione}">

            <div class="form-group">
                <small style="color: grey;">
                    <strong>Informazioni sulla sicurezza:</strong><br>
                    • I tuoi dati sono protetti con crittografia SSL<br>
                    • Tutti i campi contrassegnati con * sono obbligatori
                </small>
            </div>

            <button type="submit" class="submit-btn">Conferma pagamento</button>
        </form>
        
        <div style="margin-top: 20px;">
            <a href="./cart.jsp" style="text-decoration: none;">
            </a>
        </div>
    </div>
    
    <%@ include file="../Home/footer.jsp" %>

    <script src="/TugurioSemplice/JavaScript/CartaCredito.js"></script>
</body>
</html>