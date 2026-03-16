<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/ChiSiamo.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/scrollbar.css">
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
    <title>Chi Siamo - Tugurio Semplice</title>
</head>
<body>
	<%@ include file="header.jsp" %>
	<div class="main-content">
        <h1>Chi Siamo - La Nostra Storia, la Nostra Missione</h1>
        <p class="p-with-divider">
            Benvenuti a TugurioSemplice, il punto di riferimento per gli amanti del buon gusto e dell'autenticità.
            Siamo nati dalla passione per l'eccellenza culinaria e l'amore per i prodotti di qualità, con l'obiettivo
            di portare la migliore selezione di bar nel comfort della vostra casa. Crediamo che ogni pasto debba essere
            un'esperienza, e per questo ci impegniamo a selezionare solo i migliori ingredienti e a collaborare con i
            produttori più affidabili e attenti al dettaglio. La nostra missione è rendere la vendita di bar semplice,
            accessibile e deliziosa per tutti, garantendo freschezza, qualità e un servizio clienti impeccabile.
            Unisciti a noi in questo viaggio di sapori e scopri il vero piacere del cibo di qualità, senza complicazioni.
        </p>
        
        <h2>I Nostri Fondatori e Partner Speciali</h2>
        
        <div class="founders-container">
            <div class="founder-section">
                <img src="${pageContext.request.contextPath}/photo/tugulander.png" alt="Carmine de Fieto">
                <div class="founder-content">
                    <h3>JOHN</h3>
                    <p>
                        Da oltre trent’anni, John dedica la sua vita a offrire sostegno e rispetto a chi affronta un momento difficile. 
                        Ha fondato la nostra impresa con un principio semplice: accompagnare ogni famiglia con discrezione, 
                        professionalità e umanità. È il punto di riferimento per clienti e colleghi, grazie alla sua esperienza e 
                        alla sua profonda sensibilità.
                    </p>
                </div>
            </div>
            
            <div class="founder-section">
                <img src="${pageContext.request.contextPath}/photo/abisso.png" alt="Aldo Glass">
                <div class="founder-content">
                    <h3>GIORGIO</h3>
                    <p>
                        Preciso, empatico e sempre presente, Giorgio si occupa dell’organizzazione delle cerimonie funebri in ogni dettaglio. 
                        Dalla scelta del rito alle esigenze della famiglia, è lui a garantire che tutto si svolga con ordine e rispetto. 
                        Con un approccio umano e discreto, è il volto sereno su cui contare nei momenti più delicati.
                    </p>
                </div>
            </div>
            
            <div class="founder-section">
                <img src="${pageContext.request.contextPath}/photo/a-tugurio.png" alt="Movieplex Mercogliano">
                <div class="founder-content">
                    <h3>JAMAL</h3>
                    <p>
                        Jaml è il cuore logistico della nostra impresa. Con competenza e riservatezza, si occupa dei trasporti, 
                        della preparazione e della gestione tecnica dei servizi funebri. Il suo ruolo, spesso dietro le quinte, 
                        è essenziale per assicurare che ogni cerimonia si svolga con dignità e precisione.
                    </p>
                </div>
            </div>
            
            <div class="founder-section">
                <img src="${pageContext.request.contextPath}/photo/butcher.png" alt="Dolci Tentazioni">
                <div class="founder-content">
                    <h3>BUTCHER</h3>
                    <p>
                        Accogliere, ascoltare, accompagnare: queste sono le parole che guidano il lavoro di Butcher. 
                        È lui a offrire il primo contatto, a comprendere le necessità di chi ha appena perso una persona cara 
                        e a trovare insieme la soluzione più adatta, sempre nel rispetto della volontà e dei valori della famiglia.
                    </p>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp" %> 
</body>
</html>