<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*, Control.Filtri.*"%>
<%
Cart cart = (Cart) session.getAttribute("cart");
if (cart == null) {
    cart = new Cart(); 
    session.setAttribute("cart", cart);
}

List<Cart.CartItem> cartItems = cart.getItems();
%>

<!DOCTYPE html>
<html lang="it">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>TugurioSemplice - Carrello</title>
		<link rel="stylesheet" href="css/cart.css">
    	<link rel="stylesheet" type="text/css" href="css/scrollbar.css">
		<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;700;900&display=swap" rel="stylesheet">
</head>
<body>
    <%@ include file="../Home/header.jsp" %>
    <div class="main-content">
        <div class="container">
            <h1 class="page-title">Il Tuo Carrello</h1>
            
            <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <div class="cart-items">
                    <div class="cart-header">
                        <div class="cart-column product-info-column">Prodotto</div>
                        <div class="cart-column">Prezzo</div>
                        <div class="cart-column">Quantità</div>
                        <div class="cart-column">Totale</div>
                        <div class="cart-column action-column">Azioni</div>
                    </div>
                    
                    <% 
                    for (Cart.CartItem item : cartItems) {
                        ProdottoBean product = item.getProduct();
                        int itemQuantity = item.getQuantity();
                        double itemTotal = item.getTotalPrice();
                    %>
                    <div class="cart-item">
                        <div class="cart-column product-info-column">
                            <div class="product-image">
                                <img src="${pageContext.request.contextPath}/<%= product.getImmagine() %>" alt="<%= product.getNome() %>">
                            </div>
                            <div class="product-name">
                                <a href="DisplayProductDetail?action=details&id=<%= product.getIdProdotto() %>"><%= product.getNome() %></a>
                            </div>
                        </div>
                        
                        <div class="cart-column">
                            <span class="price">€<%= String.format("%.2f", product.getPrezzoBase()) %></span>
                        </div>
                        
                        <div class="cart-column">
                            <form action="CartController" method="post" class="quantity-form">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="<%= product.getIdProdotto() %>">
                                <input type="number" class="quantity-input" name="quantity" 
                                       value="<%= itemQuantity %>" min="1" max="<%= product.getQuantita() %>" 
                                       onchange="this.form.submit()">
                            </form>
                        </div>
                        
                        <div class="cart-column">
                            <span class="item-total">€<%= String.format("%.2f", itemTotal) %></span>
                        </div>
                        
                        <div class="cart-column action-column">
                            <form action="CartController" method="post">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= product.getIdProdotto() %>">
                                <button type="submit" class="remove-button">Rimuovi</button>
                            </form>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <div class="cart-summary">
                    <div class="cart-total">
                        <span class="total-label">Totale:</span>
                        <span class="total-amount">€<%= String.format("%.2f", cart.getTotalPrice()) %></span>
                    </div>
                </div>
                
                <div class="cart-actions">
                    <form action="CartController" method="post">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" class="cart-button clear-cart">Svuota Carrello</button>
                    </form>
                    <form action="CheckoutController" method="get">
                        <button type="submit" class="cart-button checkout-button">Procedi all'acquisto</button>
                    </form>
                </div>
            <% } else { %>
                <div class="empty-cart">
                    <p>Il tuo carrello è vuoto</p>
                    <a href="product" class="cart-button">Continua lo shopping</a>
                </div>
            <% } %>
        </div>
    </div>
    
    <%@ include file="../Home/footer.jsp" %>
</body>
</html>