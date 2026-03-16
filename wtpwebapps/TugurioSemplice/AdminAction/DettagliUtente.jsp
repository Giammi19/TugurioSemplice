<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Profilo Utente - Dettagli Cliente e Ordini</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="/TugurioSemplice/css/footer.css">
        <link rel="stylesheet" type="text/css" href="/TugurioSemplice/css/scrollbar.css">
        <link rel="stylesheet" type="text/css" href="/TugurioSemplice/css/Utente.css">
        <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
    </head>
    <body>
        <%@ include file="../Home/header.jsp" %>
        <div class="main-content">
            <div class="main-container">
                <% 
                // Recupero il cliente dalla sessione
                ClienteBean cliente = (ClienteBean) session.getAttribute("Cliente");
                ArrayList<OrdineBean> listaOrdini = (ArrayList<OrdineBean>) session.getAttribute("listaOrdini");
                String dataInizioFiltro = (String) session.getAttribute("dataInizioFiltro");
                String dataFineFiltro = (String) session.getAttribute("dataFineFiltro");
                %>
                
                <% if(cliente != null) { %>
                    <div class="page-header">
                        <h1>Profilo Utente</h1>
                    </div>
                    
                    <div class="content">
                        <div class="data-section">
                            <h3>Informazioni Personali</h3>
                            <div class="data-item">
                                <span class="data-label">ID Cliente:</span>
                                <span class="data-value"><%= cliente.getIdCliente() %></span>
                            </div>
                            <% if(cliente.getAnagrafia() != null) { %>
                                <div class="data-item">
                                    <span class="data-label">Nome:</span>
                                    <span class="data-value"><%= cliente.getAnagrafia().getNome() %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Cognome:</span>
                                    <span class="data-value"><%= cliente.getAnagrafia().getCognome() %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Telefono:</span>
                                    <span class="data-value"><%= cliente.getAnagrafia().getTelefono() != null ? cliente.getAnagrafia().getTelefono() : "N/D" %></span>
                                </div>
                            <% } %>
                            <div class="data-item">
                                <span class="data-label">Email:</span>
                                <span class="data-value"><%= cliente.getEmail() %></span>
                            </div>
                            <div class="data-item">
                                <span class="data-label">Admin:</span>
                                <span class="data-value"><%= cliente.getIsAmministratore() ? "Sì" : "No" %></span>
                            </div>
                        </div>

                        <div class="data-section">
                            <h3>Indirizzo di Spedizione</h3>
                            <% if(cliente.getIndirizzoSpedizione() != null) { %>
                                <div class="data-item">
                                    <span class="data-label">Via:</span>
                                    <span class="data-value"><%= cliente.getIndirizzoSpedizione().getVia() != null ? cliente.getIndirizzoSpedizione().getVia() : "N/D" %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Città:</span>
                                    <span class="data-value"><%= cliente.getIndirizzoSpedizione().getCitta() != null ? cliente.getIndirizzoSpedizione().getCitta() : "N/D" %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">CAP:</span>
                                    <span class="data-value"><%= cliente.getIndirizzoSpedizione().getCap() != null ? cliente.getIndirizzoSpedizione().getCap() : "N/D" %></span>
                                </div>
                            <% } else { %>
                                <div class="no-data-message">
                                    Nessun indirizzo di spedizione disponibile
                                </div>
                            <% } %>
                        </div>

                        <div class="order-section">
                            <h3>Ordini del Cliente</h3>
                            
                            <!-- Form per il filtro date -->
                            <form action="${pageContext.request.contextPath}/ListaOrdineController" method="post" class="filters" onsubmit="return validateDates()">
                                <input type="hidden" name="idCliente" value="<%= cliente.getIdCliente() %>">
                                <input type="hidden" value="AdminAction" name="ADMIN">
                                
                                <div>
                                    <label for="dataInizio">Da:</label>
                                    <input type="date" id="dataInizio" name="dataInizio" value="<%= dataInizioFiltro != null ? dataInizioFiltro : "" %>">
                                    
                                    <label for="dataFine">A:</label>
                                    <input type="date" id="dataFine" name="dataFine" value="<%= dataFineFiltro != null ? dataFineFiltro : "" %>">
                                    
                                    <button type="submit">Filtra</button>
                                    <button type="button" onclick="resetFilter()">Svuota</button>
                                </div>
                                <div id="dateError" class="error-message" style="display:none; color:red;"></div>
                            </form>
                            
                            <% 
                            if(listaOrdini != null && !listaOrdini.isEmpty()) { 
                                for(OrdineBean ordine : listaOrdini) {
                            %>
                                <div class="order-subsection">
                                    <h4>Ordine #<%= ordine.getIdOrdine() %></h4>
                                    <div class="data-item">
                                        <span class="data-label">Stato:</span>
                                        <span class="data-value"><%= ordine.getStatoOrdine() %></span>
                                    </div>
                                    <div class="data-item">
                                        <span class="data-label">Data Ordine:</span>
                                        <span class="data-value"><%= ordine.getDataOrdine() %></span>
                                    </div>
                                    <div class="data-item">
                                        <span class="data-label">Totale:</span>
                                        <span class="data-value"><%= ordine.getPrezzoOrdine() %> €</span>
                                    </div>
                                    
                                    <% if(ordine.getPagamento() != null) { %>
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
                                    <% } %>
                                    
                                    <% if(ordine.getSpedizione() != null) { %>
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
                                    <% } %>
                                    
                                    <% if(ordine.getProdotti() != null && !ordine.getProdotti().isEmpty()) { %>
                                        <h4>Prodotti Acquistati</h4>
                                        <% 
                                        for(ProdottoOrdineBean prodotto : ordine.getProdotti()) {
                                            double subtotale = prodotto.getPrezzoBase() * prodotto.getQuantita();
                                        %>
                                            <div class="product-item">
                                                <strong><%= prodotto.getNome() %></strong> - <%= prodotto.getPrezzoBase() %> € - Qtà: <%= prodotto.getQuantita() %> - Subtotale: <%= subtotale %> €
                                            </div>
                                        <% } %>
                                    <% } %>
                                </div>
                            <% 
                                }
                            } else { 
                            %>
                                <div class="no-data-message">
                                    <% if(dataInizioFiltro != null || dataFineFiltro != null) { %>
                                        Nessun ordine trovato nel periodo selezionato.
                                    <% } else { %>
                                        Il cliente non ha ancora effettuato ordini.
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } else { %>
                    <div class="page-header">
                        <h1>Errore</h1>
                    </div>
                    <div class="content">
                        <div class="no-data-message">
                            Nessun cliente trovato nella sessione.
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
        <%@ include file="../Home/footer.jsp" %>
    </body>
    <script>
        function resetFilter() {
            document.getElementById('dataInizio').value = '';
            document.getElementById('dataFine').value = '';
            document.forms[0].submit();
        }
        
        function validateDates() {
            const dataInizio = document.getElementById('dataInizio').value;
            const dataFine = document.getElementById('dataFine').value;
            const errorElement = document.getElementById('dateError');
            
            if (dataInizio && dataFine && dataInizio > dataFine) {
                errorElement.textContent = "La data di inizio deve essere precedente alla data di fine";
                errorElement.style.display = 'block';
                return false;
            }
            
            errorElement.style.display = 'none';
            return true;
        }
        
        // Mostra messaggio se ci sono filtri attivi
        window.onload = function() {
            const dataInizio = "<%= dataInizioFiltro != null ? dataInizioFiltro : "" %>";
            const dataFine = "<%= dataFineFiltro != null ? dataFineFiltro : "" %>";
            
            if(dataInizio || dataFine) {
                const filterInfo = document.createElement('div');
                filterInfo.className = 'filter-info';
                filterInfo.innerHTML = 'Filtro attivo: ' + 
                    (dataInizio ? 'Dal ' + dataInizio : '') + 
                    (dataFine ? (dataInizio ? ' al ' : 'Fino al ') + dataFine : '');
                document.querySelector('.order-section').insertBefore(filterInfo, document.querySelector('.order-section h3').nextSibling);
            }
        };
    </script>
</html>