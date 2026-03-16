<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/error.css">
	<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
    <title>Errore 404 - Pagina non trovata</title>
</head>
<body>
    <img src="${pageContext.request.contextPath}/photo/logo.png" alt="logo" class="logo">
    <div class="container">
        <img src="${pageContext.request.contextPath}/photo/403.png" alt="Immagine di errore 403" class="error-image">
        <br>
        <b>Errore 403</b>
        <br>
        Ci dispiace, non hai i permessi per accedere a questa pagina.
        <br><br>
         <a class="button" href="${pageContext.request.contextPath}/index.jsp" >Torna alla homepage</a>
    </div>
    <%@ include file="../Home/footer.jsp" %>   
</body>
</html>