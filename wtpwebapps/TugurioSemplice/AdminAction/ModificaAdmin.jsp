<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<%
    ProdottoBean bean = (ProdottoBean) request.getAttribute("prodotto");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/screen.css">
        <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
        <title>Modifica Prodotto</title>	
        <style>	
            textarea, input[type="number"], input[type="file"] {
                width: 100%;
                padding: clamp(0.5rem, 2vw, 0.75rem);
                border: 1px solid #ddd;
                border-radius: 0.25rem;
                box-sizing: border-box;
                font-family: 'Josefin Sans', sans-serif;
            }
            
            textarea {
                resize: vertical;
                min-height: 80px;
            }
            
            /*Chrome/Safari*/
            input[type="file"]::-webkit-file-upload-button {
                background-color: #74292c;
                color: white;
                border: none;
                border-radius: 0.25rem;
                padding: 0.5rem 1rem;
                font-family: 'Josefin Sans', sans-serif;
                cursor: pointer;
                margin-right: 0.5rem;
                transition: opacity 0.3s ease;
            }
            
            input[type="file"]::-webkit-file-upload-button:hover {
                opacity: 0.7;
            }
            
            /* Per Firefox */
            input[type="file"]::file-selector-button {
                background-color: #74292c;
                color: white;
                border: none;
                border-radius: 0.25rem;
                padding: 0.5rem 1rem;
                font-family: 'Josefin Sans', sans-serif;
                cursor: pointer;
                margin-right: 0.5rem;
                transition: opacity 0.3s ease;
            }
            
            input[type="file"]::file-selector-button:hover {
                opacity: 0.7;
            }
        </style>
    </head>
    <body>
        <img src="/TugurioSemplice/photo/logo.png" alt="logo" class="logo">
        <div class="container">
            <h2>Modifica il prodotto</h2>
            <form action="${pageContext.request.contextPath}/UpdateProductController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" value="<%= bean.getIdProdotto()%>">
                
                <div class="form-group">
                    <label for="name">Nome:</label>
                    <input type="text" name="name" id="name" value="<%= bean.getNome()%>">
                </div>
                
                <div class="form-group">
                    <label for="description">Descrizione:</label>
                    <textarea name="description" id="description" rows="3"><%= bean.getDescrizione()%></textarea>
                </div>
                
                <div class="form-group">
                    <label for="price">Prezzo Base:</label>
                    <input type="number" name="price" id="price" min="0" step="0.01" value="<%= bean.getPrezzoBase()%>">
                </div>
                
                <div class="form-group">
                    <label for="quantity">Quantità:</label>
                    <input type="number" name="quantity" id="quantity" min="0" value="<%= bean.getQuantita()%>">
                </div>
                
                <div class="form-group">
                    <label for="image">Nuova Immagine (lascia vuoto per mantenere l'attuale):</label>
                    <input type="file" name="image" id="image">
                    <input type="hidden" name="currentImage" value="<%= bean.getImmagine() %>">
                </div>
                
                <button type="submit" class="submit-btn">Modifica Prodotto</button>
            </form>
        </div>
    </body>
</html>