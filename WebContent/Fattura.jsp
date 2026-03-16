<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*, Control.Filtri.*"%>
<%
OrdineBean ordine = (OrdineBean) request.getAttribute("ordine");
ArrayList<Map<String, Object>> dettagliOrdine = (ArrayList<Map<String, Object>>) request.getAttribute("dettagliOrdine");
PagamentoBean pagamento = (PagamentoBean) request.getAttribute("pagamento");
SpedizioneBean spedizione = (SpedizioneBean) request.getAttribute("spedizione");
ClienteBean utente = (ClienteBean) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<link rel="stylesheet" type="text/css" href="css/Utente.css">
    	<link rel="stylesheet" type="text/css" href="css/scrollbar.css">
		<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;700;900&display=swap" rel="stylesheet">
    <title>Fattura - FAT-<%= ordine.getIdOrdine() %></title>
</head>
<body>
        <div class="main-container">
            <!-- Header -->
            <div class="page-header">
            <br>
                <h1>Fattura</h1>
            </div>
            
            <div class="content">
                <!-- Invoice Info -->
                <div class="data-section">
                    <h3>Informazioni Fattura</h3>
                    <div class="data-item">
                        <span class="data-label">Numero Fattura:</span>
                        <span class="data-value">FAT-<%= ordine.getIdOrdine() %></span>
                    </div>
                    <div class="data-item">
                        <span class="data-label">Data:</span>
                        <span class="data-value"><%= ordine.getDataOrdine() %></span>
                    </div>
                </div>

                <!-- Seller Info -->
                <div class="data-section">
                    <h3>Venditore</h3>
                    <div class="data-item">
                        <span class="data-label">Ragione Sociale:</span>
                        <span class="data-value">Tugurio Semplice S.r.l.</span>
                    </div>
                    <div class="data-item">
                        <span class="data-label">Indirizzo:</span>
                        <span class="data-value">Via Esempio, 123</span>
                    </div>
                    <div class="data-item">
                        <span class="data-label">Città:</span>
                        <span class="data-value">00123 Roma (RM)</span>
                    </div>
                    <div class="data-item">
                        <span class="data-label">P.IVA:</span>
                        <span class="data-value">12345678901</span>
                    </div>
                </div>

                <!-- Customer Info -->
                <div class="data-section">
                    <h3>Cliente</h3>
                    <div class="data-item">
                        <span class="data-label">Nome:</span>
                        <span class="data-value">
                            <%= utente.getAnagrafia() != null ? utente.getAnagrafia().getNome() + " " + utente.getAnagrafia().getCognome() : "N/D" %>
                        </span>
                    </div>
                    <div class="data-item">
                        <span class="data-label">Codice Fiscale:</span>
                        <span class="data-value">
                            <%= utente.getAnagrafia() != null ? utente.getAnagrafia().getCf() : "N/D" %>
                        </span>
                    </div>
                    <% if(utente.getIndirizzoSpedizione() != null) { %>
                        <div class="data-item">
                            <span class="data-label">Indirizzo:</span>
                            <span class="data-value"><%= utente.getIndirizzoSpedizione().getVia() %></span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Città:</span>
                            <span class="data-value">
                                <%= utente.getIndirizzoSpedizione().getCitta() %> (<%= utente.getIndirizzoSpedizione().getProvincia() %>)
                            </span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">CAP:</span>
                            <span class="data-value"><%= utente.getIndirizzoSpedizione().getCap() %></span>
                        </div>
                    <% } else { %>
                        <div class="data-item">
                            <span class="data-label">Indirizzo:</span>
                            <span class="data-value">N/D</span>
                        </div>
                    <% } %>
                </div>

                <!-- Order Details -->
                <div class="order-section">
                    <h3>Dettagli Ordine</h3>
                    <%
                    double subtotale = 0;
                    if(dettagliOrdine != null && !dettagliOrdine.isEmpty()) {
                        for(Map<String, Object> dettaglio : dettagliOrdine) {
                            String nomeProdotto = (String) dettaglio.get("nomeProdotto");
                            int quantita = (Integer) dettaglio.get("quantita");
                            double prezzo = (Double) dettaglio.get("prezzo");
                            double totaleRiga = quantita * prezzo;
                            subtotale += totaleRiga;
                    %>
                        <div class="order-subsection">
                            <div class="product-item">
                                <div class="data-item">
                                    <span class="data-label">Articolo:</span>
                                    <span class="data-value"><%= nomeProdotto %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Quantità:</span>
                                    <span class="data-value"><%= quantita %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Prezzo Unitario:</span>
                                    <span class="data-value"><%= String.format("%.2f", prezzo) %> €</span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Totale:</span>
                                    <span class="data-value"><%= String.format("%.2f", totaleRiga) %> €</span>
                                </div>
                            </div>
                        </div>
                    <% 
                        }
                    } else {
                    %>
                        <div class="no-data-message">
                            Nessun dettaglio ordine disponibile
                        </div>
                    <% } %>
                    
                    <div class="order-subsection">
                        <div class="data-item">
                            <span class="data-label">SUBTOTALE:</span>
                            <span class="data-value"><%= String.format("%.2f", subtotale) %> €</span>
                        </div>
                    </div>
                </div>

                <!-- Payment Info -->
                <% if(pagamento != null) { %>
                    <div class="data-section">
                        <h3>Metodo di Pagamento</h3>
                        <div class="data-item">
                            <span class="data-label">Metodo:</span>
                            <span class="data-value"><%= pagamento.getMetodo() %></span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Importo:</span>
                            <span class="data-value"><%= String.format("%.2f", pagamento.getImporto()) %> €</span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Data Pagamento:</span>
                            <span class="data-value"><%= pagamento.getDataPagamento() %></span>
                        </div>
                    </div>
                <% } %>

                <!-- Shipping Info -->
                <% if(spedizione != null) { %>
                    <div class="data-section">
                        <h3>Spedizione</h3>
                        <div class="data-item">
                            <span class="data-label">Metodo:</span>
                            <span class="data-value"><%= spedizione.getMetodo() %></span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Spese:</span>
                            <span class="data-value"><%= String.format("%.2f", spedizione.getSpese()) %> €</span>
                        </div>
                        <div class="data-item">
                            <span class="data-label">Data Consegna Prevista:</span>
                            <span class="data-value"><%= spedizione.getDataConsegna() %></span>
                        </div>
                    </div>
                <% } %>

                <!-- Footer Notes -->
                <div class="data-section">
                    <div class="no-data-message">
                        <p>Fattura emessa elettronicamente</p>
                        <p>Documento non valido ai fini fiscali</p>
                    </div>
                </div>

                <!-- Print Button -->
                <div class="btn-container">
                    <button class="btn" onclick="window.print()">Stampa Fattura</button>
                </div>
            </div>
        </div>
</body>
</html>