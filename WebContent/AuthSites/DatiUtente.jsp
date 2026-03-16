<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Dati Utente</title>
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
                <% if(utente != null) { %>
                    <div class="page-header">
                        <h1>I Tuoi Dati</h1>
                    </div>
                    <div class="content">
                        <div class="data-section">
                            <h3>Informazioni Account</h3>
                            <div class="data-item">
                                <span class="data-label">ID Cliente:</span>
                                <span class="data-value"><%= utente.getIdCliente() %></span>
                            </div>
                            <div class="data-item">
                                <span class="data-label">Username:</span>
                                <span class="data-value"><%= utente.getUsername() %></span>
                            </div>
                            <div class="data-item">
                                <span class="data-label">Email:</span>
                                <span class="data-value"><%= utente.getEmail() %></span>
                            </div>
                        </div>
                        
                        <div class="data-section">
                            <h3>Dati Anagrafici</h3>
                            <% if(utente.getAnagrafia() != null) { %>
                                <div class="data-item">
                                    <span class="data-label">Nome:</span>
                                    <span class="data-value"><%= utente.getAnagrafia().getNome() %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Cognome:</span>
                                    <span class="data-value"><%= utente.getAnagrafia().getCognome() %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Codice Fiscale:</span>
                                    <span class="data-value"><%= utente.getAnagrafia().getCf() %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Telefono:</span>
                                    <span class="data-value"><%= utente.getAnagrafia().getTelefono() %></span>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="data-section">
                            <h3>Indirizzo di Spedizione</h3>
                            <% if(utente.getIndirizzoSpedizione() != null) { %>
                                <div class="data-item">
                                    <span class="data-label">Via:</span>
                                    <span class="data-value"><%= utente.getIndirizzoSpedizione().getVia() %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Città:</span>
                                    <span class="data-value"><%= utente.getIndirizzoSpedizione().getCitta() %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">CAP:</span>
                                    <span class="data-value"><%= utente.getIndirizzoSpedizione().getCap() %></span>
                                </div>
                                <div class="data-item">
                                    <span class="data-label">Provincia:</span>
                                    <span class="data-value"><%= utente.getIndirizzoSpedizione().getProvincia() %></span>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="btn-container">
                            <form action="ModificaDatiUtente.jsp" method="post">
                                <button type="submit" class="btn">Modifica i tuoi dati</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
        <%@ include file="../Home/footer.jsp" %>
    </body>
</html>