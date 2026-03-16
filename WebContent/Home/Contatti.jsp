<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/Contatti.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/scrollbar.css">
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
    <title>Contatti - Tugurio Semplice</title>
</head>
<body>
	<%@ include file="header.jsp" %>
	<div class="main-content">
        <h1>Contatti - Siamo Sempre al Vostro Fianco</h1>
        <p class="p-with-divider">
            Nel momento del dolore, sappiamo quanto sia importante avere un punto di riferimento sicuro e disponibile.
            Il nostro team è sempre pronto ad accogliervi con rispetto, discrezione e professionalità. Contattateci
            in qualsiasi momento: siamo qui per accompagnarvi con sensibilità e competenza in ogni fase del servizio funebre,
            offrendo supporto personalizzato per onorare la memoria dei vostri cari nel modo più dignitoso possibile.
        </p>
        
        <h2>Come Raggiungerci</h2>
        
        <div class="contact-container">
            <div class="contact-section">
                <div class="contact-icon">
                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#74292c" stroke-width="2">
                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                    </svg>
                </div>
                <div class="contact-content">
                    <h3>TELEFONO</h3>
                    <p class="contact-main">+39 081 123 4567</p>
                    <p class="contact-sub">Reperibili 24 ore su 24, 7 giorni su 7</p>
                    <p class="contact-desc">
                        Il nostro servizio telefonico è sempre attivo per garantirvi assistenza immediata.
                        Non esitate a chiamarci in qualsiasi momento del giorno o della notte.
                    </p>
                </div>
            </div>
            
            <div class="contact-section">
                <div class="contact-icon">
                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#74292c" stroke-width="2">
                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                        <circle cx="12" cy="10" r="3"/>
                    </svg>
                </div>
                <div class="contact-content">
                    <h3>SEDE PRINCIPALE</h3>
                    <p class="contact-main">Via Roma, 123</p>
                    <p class="contact-sub">80100 Napoli (NA)</p>
                    <p class="contact-desc">
                        La nostra sede principale vi accoglie in un ambiente riservato e confortevole,
                        dove potrete parlare con i nostri esperti e pianificare ogni dettaglio del servizio.
                    </p>
                </div>
            </div>
            
            <div class="contact-section">
                <div class="contact-icon">
                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#74292c" stroke-width="2">
                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                        <polyline points="22,6 12,13 2,6"/>
                    </svg>
                </div>
                <div class="contact-content">
                    <h3>EMAIL</h3>
                    <p class="contact-main">info@tugurio-semplice.it</p>
                    <p class="contact-sub">Risposta entro 2 ore</p>
                    <p class="contact-desc">
                        Per informazioni, preventivi o richieste particolari, scriveteci via email.
                        Il nostro team risponderà tempestivamente ad ogni vostra richiesta.
                    </p>
                </div>
            </div>
            
            <div class="contact-section">
                <div class="contact-icon">
                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#74292c" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <polyline points="12,6 12,12 16,14"/>
                    </svg>
                </div>
                <div class="contact-content">
                    <h3>ORARI UFFICIO</h3>
                    <p class="contact-main">Lunedì - Venerdì: 8:00 - 18:00</p>
                    <p class="contact-sub">Sabato: 8:00 - 13:00</p>
                    <p class="contact-desc">
                        I nostri uffici sono aperti per consulenze e appuntamenti. Il servizio di reperibilità
                        telefonica rimane attivo anche al di fuori di questi orari.
                    </p>
                </div>
            </div>
        </div>
        
        <div class="emergency-section">
            <h2>Servizio di Emergenza</h2>
            <div class="emergency-content">
                <div class="emergency-icon">
                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                    </svg>
                </div>
                <div class="emergency-text">
                <br><br>
                    <h3>NUMERO DI EMERGENZA</h3>
                    <p class="emergency-number">+39 333 999 8877</p>
                    <p>
                        In caso di necessità urgenti al di fuori degli orari di ufficio, questo numero vi metterà
                        immediatamente in contatto con il nostro responsabile di turno. Garantiamo intervento rapido
                        e assistenza completa in qualsiasi momento della giornata.
                    </p>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp" %> 
</body>
</html>