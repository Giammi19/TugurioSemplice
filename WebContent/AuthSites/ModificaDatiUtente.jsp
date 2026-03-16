<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="../css/footer.css">
        <link rel="stylesheet" type="text/css" href="../css/scrollbar.css">
        <link rel="stylesheet" type="text/css" href="../css/Utente.css">
        <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
        <title>Modifica Dati Utente</title>
    </head>
    <body>
        <%@ include file="../Home/header.jsp" %>
        
        <div class="main-content">
            <div class="main-container">
                <% if(utente != null) { 
                    DatiAnagraficiBean anagrafica = utente.getAnagrafia();
                    IndirizzoSpedizioneBean indirizzo = utente.getIndirizzoSpedizione();
                %>
                    <div class="page-header">
                        <h2>Modifica i tuoi dati</h2>
                    </div>
                    
                    <div class="content">
                        <form action="${pageContext.request.contextPath}/ModificaUtenteController" method="post">
                            
                            <!-- Dati di accesso -->
                            <div class="form-section">
                                <div class="section-header">
                                    <span class="section-title">Dati di accesso</span>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Username:</span>
                                    <input type="text" id="username" name="username" value="<%= utente.getUsername() %>" required>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Email:</span>
                                    <input type="email" id="email" name="email" value="<%= utente.getEmail() %>" required>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Nuova Password:</span>
                                    <input type="password" id="password" name="password" placeholder="Lascia vuoto per non modificare">
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Conferma Password:</span>
                                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Conferma la nuova password">
                                </div>
                            </div>
                            
                            <!-- Dati anagrafici -->
                            <div class="form-section">
                                <div class="section-header">
                                    <span class="section-title">Dati anagrafici</span>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Nome:</span>
                                    <input type="text" id="nome" name="nome" value="<%= anagrafica != null ? anagrafica.getNome() : "" %>" required>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Cognome:</span>
                                    <input type="text" id="cognome" name="cognome" value="<%= anagrafica != null ? anagrafica.getCognome() : "" %>" required>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Telefono:</span>
                                    <input type="text" id="telefono" name="telefono" value="<%= anagrafica != null ? anagrafica.getTelefono() : "" %>" required>
                                </div>
                            </div>
                            
                            <!-- Indirizzo di spedizione -->
                            <div class="form-section">
                                <div class="section-header">
                                    <span class="section-title">Indirizzo di spedizione</span>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Via:</span>
                                    <input type="text" id="via" name="via" value="<%= indirizzo != null ? indirizzo.getVia() : "" %>" required>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Città:</span>
                                    <input type="text" id="citta" name="citta" value="<%= indirizzo != null ? indirizzo.getCitta() : "" %>" required>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">CAP:</span>
                                    <input type="text" id="cap" name="cap" value="<%= indirizzo != null ? indirizzo.getCap() : "" %>" required>
                                </div>
                                
                                <div class="form-group">
                                    <span class="form-label">Provincia:</span>
                                    <input type="text" id="provincia" name="provincia" value="<%= indirizzo != null ? indirizzo.getProvincia() : "" %>" required>
                                </div>
                            </div>
                            
                            <input type="hidden" name="idCliente" value="<%= utente.getIdCliente() %>">
                            <input type="hidden" name="codiceFiscale" value="<%= anagrafica.getCf() %>">
                            
                            <div class="btn-container">
                                <button type="submit" class="btn">Salva Modifiche</button>
                            </div>
                        </form>
                    </div>
                <% } %>
            </div>
        </div>
        
        <%@ include file="../Home/footer.jsp" %>
    </body>
</html>