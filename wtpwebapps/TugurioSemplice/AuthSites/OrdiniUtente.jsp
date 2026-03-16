<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="/TugurioSemplice/css/footer.css">
        <link rel="stylesheet" type="text/css" href="/TugurioSemplice/css/scrollbar.css">
        <link rel="stylesheet" type="text/css" href="/TugurioSemplice/css/Utente.css">
        <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
        <title>Profilo Utente - I Tuoi Ordini</title>
    </head>
    <body>
        <%@ include file="../Home/header.jsp" %>
        
        <div class="main-content">
            <div class="main-container">
                <div class="page-header">
                    <h1>I Tuoi Ordini</h1>
                </div>
                
                <div class="content">
                    <% 
                    if(utente != null) {
                        ArrayList<OrdineBean> listaOrdini = (ArrayList<OrdineBean>) session.getAttribute("listaOrdini");
                        
                        if(listaOrdini != null && !listaOrdini.isEmpty()) { 
                            for(OrdineBean ordine : listaOrdini) {
                    %>
                                <div class="order-section">
                                    <h3>Ordine #<%= ordine.getIdOrdine() %></h3>
                                    
                                    <div class="data-item">
                                        <span class="data-label">Data:</span>
                                        <span class="data-value"><%= ordine.getDataOrdine() %></span>
                                    </div>
                                    
                                    <div class="data-item">
                                        <span class="data-label">Stato:</span>
                                        <span class="data-value"><%= ordine.getStatoOrdine() %></span>
                                    </div>
                                    
                                    <div class="data-item">
                                        <span class="data-label">Totale:</span>
                                        <span class="data-value"><%= ordine.getPrezzoOrdine() %> €</span>
                                    </div>
                                    
                                    <% if(ordine.getPagamento() != null) { %>
                                        <div class="order-subsection">
                                            <h4>Dettagli Pagamento</h4>
                                            <div class="data-item">
                                                <span class="data-label">Importo:</span>
                                                <span class="data-value"><%= ordine.getPagamento().getImporto() %> €</span>
                                            </div>
                                            <div class="data-item">
                                                <span class="data-label">Data Pagamento:</span>
                                                <span class="data-value"><%= ordine.getPagamento().getDataPagamento() %></span>
                                            </div>
                                            <div class="data-item">
                                                <span class="data-label">Metodo:</span>
                                                <span class="data-value"><%= ordine.getPagamento().getMetodo() %></span>
                                            </div>
                                        </div>
                                    <% } %>
                                    
                                    <% if(ordine.getSpedizione() != null) { %>
                                        <div class="order-subsection">
                                            <h4>Dettagli Spedizione</h4>
                                            <div class="data-item">
                                                <span class="data-label">Metodo:</span>
                                                <span class="data-value"><%= ordine.getSpedizione().getMetodo() %></span>
                                            </div>
                                            <div class="data-item">
                                                <span class="data-label">Spese:</span>
                                                <span class="data-value"><%= ordine.getSpedizione().getSpese() %> €</span>
                                            </div>
                                            <div class="data-item">
                                                <span class="data-label">Data Consegna Prevista:</span>
                                                <span class="data-value"><%= ordine.getSpedizione().getDataConsegna() %></span>
                                            </div>
                                        </div>
                                    <% } %>
                                    
                                    <div class="order-subsection">
                                        <h4>Prodotti Acquistati</h4>
                                        <% 
                                        if(ordine.getProdotti() != null) {
                                            for(ProdottoOrdineBean prodotto : ordine.getProdotti()) {
                                                double subtotale = prodotto.getPrezzoBase() * prodotto.getQuantita();
                                        %>
                                            <div class="data-item">
                                                <span class="data-label">Nome:</span>
                                                <span class="data-value"><%= prodotto.getNome() %></span>
                                            </div>
                                            <div class="data-item">
                                                <span class="data-label">Prezzo:</span>
                                                <span class="data-value"><%= prodotto.getPrezzoBase() %> €</span>
                                            </div>
                                            <div class="data-item">
                                                <span class="data-label">Quantità:</span>
                                                <span class="data-value"><%= prodotto.getQuantita() %></span>
                                            </div>
                                            <div class="data-item">
                                                <span class="data-label">Subtotale:</span>
                                                <span class="data-value"><%= subtotale %> €</span>
                                            </div>
                                        <% 
                                            }
                                        } 
                                        %>
                                    </div>
                                    
                                    <% if(ordine.getPagamento().getMetodo().equals("Carta")){ %>
                                        <div class="btn-container">
                                            <a href="FatturaController?idOrdine=<%= ordine.getIdOrdine() %>" class="btn" target="_blank">
                                                Visualizza Fattura
                                            </a>
                                        </div>
                                    <% } else { %>
                                        <div class="btn-container">
                                            <button onclick="FatturaController?idOrdine=<%= ordine.getIdOrdine() %>" class="btn" target="_blank" disabled title="Fattura non disponibile, effettuare il pagamento per visualizzare la fattura">
                                                Visualizza Fattura
                                            </button>
                                        </div>
                                    <% } %>
                                </div>
                    <% 
                            }
                        } else { 
                    %>
                            <div class="no-data-message">
                                <p>Non hai ancora effettuato ordini.</p>
                            </div>
                    <% 
                        } 
                    } else {
                    %>
                        <div class="no-data-message">
                            <p>Utente non autenticato. Effettua il <a href="${pageContext.request.contextPath}/Login.jsp">login</a> per visualizzare il tuo profilo.</p>
                        </div>
                    <%
                    }
                    %>
                </div>
            </div>
        </div>
        
        <%@ include file="../Home/footer.jsp" %>
    </body>
</html>