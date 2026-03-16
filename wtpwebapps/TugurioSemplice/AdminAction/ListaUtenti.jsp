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
        <title>Lista degli utenti</title>
    </head>
    <body>
        <%@ include file="../Home/header.jsp"%>
        
        <div class="main-content">
            <div class="main-container">
                <div class="page-header">
                    <h1>Lista Utenti</h1>
                    <div class="filters">
                        <form action="ListaUtentiController" method="get" class="search-form">
                            <div class="search-container">
                                <input type="text" list="search-suggestions" placeholder="Cerca utenti..." name="q" id="search-input" autocomplete="off"/>
                                <datalist id="search-suggestions"></datalist>
                                <button type="submit" class="search-btn">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8"/>
                                        <path d="m21 21-4.35-4.35"/>
                                    </svg>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="content">
                    <% 
                        ArrayList<ClienteBean> lista = (ArrayList<ClienteBean>) request.getAttribute("Clienti");
                        if(lista != null && !lista.isEmpty()) {
                    %>
                        <% for(ClienteBean cliente : lista) { %>
                            <div class="user-card">
                                <h3>Cliente #<%= cliente.getIdCliente() %></h3>
                                <div class="user-info">
                                    <div class="data-item">
                                        <span class="data-label">Nome:</span>
                                        <span class="data-value"><%= cliente.getAnagrafia().getNome() %></span>
                                    </div>
                                    <div class="data-item">
                                        <span class="data-label">Cognome:</span>
                                        <span class="data-value"><%= cliente.getAnagrafia().getCognome() %></span>
                                    </div>
                                    <div class="data-item">
                                        <span class="data-label">Email:</span>
                                        <span class="data-value"><%= cliente.getEmail() %></span>
                                    </div>
                                </div>
                                <div class="user-actions">
                                    <form action="ListaOrdineController" method="post" style="display: inline;">
                                        <input type="hidden" value="<%= cliente.getIdCliente()%>" name="idCliente">
                                        <input type="hidden" value="AdminAction" name="ADMIN">
                                        <button type="submit" class="btn">Dettagli Cliente</button>
                                    </form>
                                    <form action="DeleteUtenteController" method="post" style="display: inline;" onsubmit="return confirmDelete()">
                                        <input type="hidden" value="<%= cliente.getIdCliente()%>" name="id">
                                        <% if(utente.getIdCliente() != cliente.getIdCliente()) { %>
                                            <button type="submit" class="btn">Elimina Cliente</button>
                                        <% } else { %>
                                            <button type="button" class="btn" disabled title="Non puoi eliminare te stesso">Elimina Cliente</button>
                                        <% } %>
                                    </form>
                                </div>
                            </div>
                        <% } %>
                    <%
                        } else {
                    %>
                        <div class="no-data-message">
                            <p>Nessun utente registrato</p>
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
        
        <%@ include file="../Home/footer.jsp"%>
        <script>
            function confirmDelete() {
                return confirm('Sei sicuro di voler eliminare questo utente? Questa azione non può essere annullata.');
            }
        </script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const searchInput = document.getElementById('search-input');
                const datalist = document.getElementById('search-suggestions');
                let lastQuery = '';
                let debounceTimer;
            
                searchInput.addEventListener('input', function() {
                    const query = this.value.trim();
                    
                    clearTimeout(debounceTimer);
                    
                    if(query.length >= 2 && query !== lastQuery) {
                        searchInput.setAttribute('data-loading', 'true');
                        
                        debounceTimer = setTimeout(() => {
                            fetch('RicercaUtente?q=' + encodeURIComponent(query))
                                .then(response => {
                                    if(!response.ok) throw new Error('Network response was not ok');
                                    return response.json();
                                })
                                .then(data => {
                                    datalist.innerHTML = '';
                                    
                                    if(data && data.length > 0) {
                                        data.forEach(item => {
                                            const option = document.createElement('option');
                                            option.value = item;
                                            datalist.appendChild(option);
                                        });
                                    }
                                    
                                    lastQuery = query;
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    datalist.innerHTML = '';
                                })
                                .finally(() => {
                                    searchInput.removeAttribute('data-loading');
                                });
                        }, 200);
                    } else if(query.length < 2) {
                        datalist.innerHTML = '';
                        lastQuery = '';
                    }
                });
            
                searchInput.addEventListener('blur', function() {
                    setTimeout(() => {
                        datalist.innerHTML = '';
                    }, 200);
                });
            });
        </script>
    </body>
</html>