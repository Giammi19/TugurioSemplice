<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<%
    ProdottoBean product = (ProdottoBean) request.getAttribute("product");
    if(product == null) {
        response.sendRedirect("./product");
        return;
    }
    
    String error = (String)request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="./css/productDetail.css">
        <link rel="stylesheet" type="text/css" href="css/scrollbar.css">
        <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700&display=swap" rel="stylesheet">
        <title>TugurioSemplice - <%= product.getNome() %></title>
    </head>
    <body>
        <%@ include file="../Home/header.jsp" %>
        
        <div class="main-content">
            <% if(error != null) { %>
                <div class="error-message"><%= error %></div>
            <% } %>
            
            <div class="product-container">    
                <div class="product-image">
                    <img src="<%= product.getImmagine() %>" alt="<%= product.getNome() %>" 
                         onerror="this.src='photo/placeholder.jpg'; this.onerror=null;">
                </div>
                 
                <div class="product-info">
                    <h1 class="product-title"><%= product.getNome() %></h1>
                    
                    <div class="product-price">
                        €<%= String.format("%.2f", product.getPrezzoBase()) %>
                    </div>
                    
                    <div class="product-availability">
                        <% boolean isAvailable = (product.getQuantita() > 0 && product.getDisponibilita()); %>
                        <span class="<%= isAvailable ? "available" : "not-available" %>">
                            <%= isAvailable ? "Disponibile" : "Non disponibile" %>
                        </span>
                        <% if(isAvailable) { %>
                            <span> - <%= product.getQuantita() %> in magazzino</span>
                        <% } %>
                    </div>
                    
                    <div class="product-description">
                        <%= product.getDescrizione() %>
                    </div>
                          
                    <form action="CartController" method="post">
                        <input type="hidden" name="action" value="addC">
                        <input type="hidden" name="id" value="<%= product.getIdProdotto() %>">
                        
                        <div class="quantity-selector">
                            <label for="quantity">Quantità:</label>
                            <input type="number" id="quantity" name="quantity" value="1" 
                                   min="1" max="<%= product.getQuantita() %>" 
                                   <%= isAvailable ? "" : "disabled" %>>
                        </div>
                        
                        <button class="add-to-cart" type="submit" <%= isAvailable ? "" : "disabled" %>>
                            Aggiungi al Carrello
                        </button>
                    </form>
                            
                    <div class="product-details">
                        <h3>Dettagli prodotto</h3>
                        <p>IVA: <%= product.getIva() %>%</p>
                        <p>Codice prodotto: <%= product.getIdProdotto() %></p>
                    </div>
                </div>
            </div>
        </div>
        
        <%@ include file="../Home/footer.jsp" %>
    </body>
</html>