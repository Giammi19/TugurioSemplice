<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="../css/AreaUtente.css">
        <link rel="stylesheet" type="text/css" href="../css/scrollbar.css">
        <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">     
        <title>Profilo Utente</title>
    </head>
    <body>
        <%@ include file="../Home/header.jsp" %>
        <div class="main-content">
            <div class="container">
                <h1>Area Utente</h1>
                
                <div class="user-info">
                    <h2>Benvenuto nel tuo profilo</h2>
                    <p>Qui puoi gestire il tuo account e accedere alle funzionalità a te riservate</p>
                </div>
                
                <div class="checkout-section">
                    <div class="checkout-form">
                        <div class="form-group">
                            <a href="${pageContext.request.contextPath}/AuthSites/DatiUtente.jsp">
                                <button type="button">Dati utente</button>
                            </a>
                        </div>
                        
                        <div class="form-group">
                            <form action="${pageContext.request.contextPath}/ListaOrdineController" method="post">
                                <input type="hidden" name="idCliente" value="<%= utente.getIdCliente() %>">
                                <button type="submit">I miei ordini</button>
                            </form>
                        </div>
                        
                        <% if(utente.getIsAmministratore()){ %>
                            <div class="form-group">
                                <form action="${pageContext.request.contextPath}/ListaUtentiController" method="get">
                                    <button type="submit">Dati degli utenti</button>
                                </form>
                            </div>
                        <% } %>
                        
                        <div class="form-group">
                            <form action="${pageContext.request.contextPath}/AccessoUtente/Login.jsp" method="get">
                                <button type="submit">Logout</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="../Home/footer.jsp" %>
    </body>
</html>