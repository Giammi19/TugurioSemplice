<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html>
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <link rel="stylesheet" type="text/css" href="/TugurioSemplice/css/login.css">
	    <link rel="stylesheet" type="text/css" href="/TugurioSemplice/css/footer.css">
	    <link rel="stylesheet" type="text/css" href="/TugurioSemplice/css/scrollbar.css">
	    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
	    <title>Registrazione</title>
	</head>
	<body>
	    <img src="/TugurioSemplice/photo/logo.png" alt="logo" class="logo">
	    <div class="container">
	        <h2>Crea il tuo account</h2>
	        <div class="steps">
	            <div class="step-line"></div>
	            <div class="step active" id="step-indicator-1">1
	                <span class="step-title">Anagrafica</span>
	            </div>
	            <div class="step" id="step-indicator-2">2
	                <span class="step-title">Account</span>
	            </div>
	            <div class="step" id="step-indicator-3">3
	                <span class="step-title">Spedizione</span>
	            </div>
	        </div>
	        
	        <form action="${pageContext.request.contextPath}/SignInController" method="post" id="registrationForm">   
	            <div class="form-step active" id="step1">
	                <h3>Informazioni Anagrafiche</h3>
	                <div class="form-group">
	                    <label for="nome">Nome:</label>
	                    <input type="text" id="nome" name="nome" required>
	                </div>
	                <div class="form-group">
	                    <label for="cognome">Cognome:</label>
	                    <input type="text" id="cognome" name="cognome" required>
	                </div>
	                <div class="form-group">
	                    <label for="cf">Codice Fiscale:</label>
	                    <input type="text" id="cf" name="cf">
	                </div>
	                <div class="form-group">
	                    <label for="telefono">Telefono:</label>
	                    <input type="tel" id="telefono" name="telefono">
	                </div>
	                <div class="form-buttons">
	                    <div></div>
	                    <button type="button" class="nav-btn next-btn" onclick="nextStep(1, 2)">Avanti</button>
	                </div>
	                <div class="form-group">
	                    <p class="signup-link">Hai già un account? <a href="Login.jsp">Accedi</a></p>
	                </div>
	            </div>
	            
	            <div class="form-step" id="step2">
	                <h3>Dati Account</h3>
	                <div class="form-group">
	                    <label for="username">Username:</label>
	                    <input type="text" id="username" name="username" required>
	                </div>
	                <div class="form-group">
	                    <label for="email">Email:</label>
	                    <input type="email" id="email" name="email" required>
	                </div>
	                <div class="form-group">
	                    <label for="passkey">Password:</label>
	                    <input type="password" id="passkey" name="passkey" required>
	                </div>
	                <div class="form-group">
	                    <label for="passkey2">Conferma Password:</label>
	                    <input type="password" id="passkey2" name="passkey2" required>
	                </div>
	                <div class="form-buttons">
	                    <button type="button" class="nav-btn prev-btn" onclick="prevStep(2, 1)">Indietro</button>
	                    <button type="button" class="nav-btn next-btn" onclick="nextStep(2, 3)">Avanti</button>
	                </div>
	                <div class="form-group">
	                    <p class="signup-link">Hai già un account? <a href="Login.jsp">Accedi</a></p>
	                </div>
	            </div>
	 
	            <div class="form-step" id="step3">
	                <h3>Dati Spedizioni</h3>
	                <div class="form-group">
	                    <label for="city">Città:</label>
	                    <input type="text" id="city" name="city" required>
	                </div>
	                <div class="form-group">
	                    <label for="provincia">Provincia:</label>
	                    <input type="text" id="provincia" name="provincia" required>
	                </div>
	                <div class="form-group">
	                    <label for="street">Via:</label>
	                    <input type="text" id="street" name="street" required>
	                </div>
	                <div class="form-group">
	                    <label for="CAP">CAP:</label>
	                    <input type="text" id="CAP" name="CAP" required>
	                </div>
	                <div class="form-buttons">
	                    <button type="button" class="nav-btn prev-btn" onclick="prevStep(3, 2)">Indietro</button>
	                    <div></div>
	                </div>
	                <button type="submit" class="submit-btn">Registrati</button>
	                <div class="form-group">
	                    <p class="signup-link">Hai già un account? <a href="${pageContext.request.contextPath}/Login.jsp">Accedi</a></p>
	                </div>
	            </div>
	        </form>
	        
	        <form method="get" action="../index.jsp">
	            <button type="submit" class="home-btn">Torna alla home</button>
	        </form>
	    </div>
	    
	    <%@ include file="../Home/footer.jsp" %>
	    <script src="/TugurioSemplice/JavaScript/Sigin.js"></script>
	    <% if(request.getAttribute("error") != null) { %>
	        <script>alert("<%= request.getAttribute("error") %>");</script>
	    <% } %>
	</body>
</html>