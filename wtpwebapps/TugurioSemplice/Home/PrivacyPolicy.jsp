<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*" session = "true"%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
   	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href=" ../css/footerfile.css">
    <link rel="stylesheet" type="text/css" href="../css/scrollbar.css">
	<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
    <title>Privacy Policy - tugurioSemplice</title>
</head>
<body>
	<%@ include file="header.jsp" %>
    <div class="main-content">
        <div class="main-container">
            <div class="page-header">
                <h1>Privacy Policy</h1>
                <p class="company-name">tugurioSemplice - Onoranze Funebri</p>
                <p class="last-updated">Ultimo aggiornamento: Maggio 2025</p>
            </div>
            
            <div class="content">
                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title"> Titolare del Trattamento</h2>
                    </div>
                    <div class="info-text">
                        <p>Il Titolare del trattamento dei dati personali è tugurioSemplice, con sede legale in [inserire indirizzo completo], nella persona del suo legale rappresentante pro tempore.</p>
                        <p><strong>Contatti:</strong></p>
                        <ul>
                            <li>Email: info@tugurio-semplice.it</li>
                            <li>Telefono: +39 081 123 4567</li>
                            <li>PEC: info@pec.tuguriosemplice.it</li>
                        </ul>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Tipologie di Dati Raccolti</h2>
                    </div>
                    <div class="info-text">
                        <p>Raccogliamo e trattiamo le seguenti categorie di dati personali:</p>
                        <ul>
                            <li><strong>Dati di registrazione:</strong> username, indirizzo email, password crittografata</li>
                            <li><strong>Dati anagrafici:</strong> nome, cognome, codice fiscale, numero di telefono</li>
                            <li><strong>Dati di indirizzo:</strong> via, CAP, città, provincia per la spedizione dei prodotti</li>
                            <li><strong>Dati di pagamento:</strong> informazioni della carta di credito (nome, cognome, numero carta, data scadenza, CVV)</li>
                            <li><strong>Dati degli ordini:</strong> dettagli sui prodotti acquistati, prezzi, quantità, date degli ordini</li>
                            <li><strong>Dati di spedizione:</strong> metodo di consegna, spese di spedizione, date di consegna</li>
                            <li><strong>Dati di pagamento:</strong> importi, metodi di pagamento, date delle transazioni</li>
                            <li><strong>Dati di sessione:</strong> informazioni temporanee per la gestione del carrello e della sessione di navigazione</li>
                        </ul>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Finalità del Trattamento</h2>
                    </div>
                    <div class="info-text">
                        <p>I dati personali vengono trattati per le seguenti finalità:</p>
                        <ul>
                            <li><strong>Gestione dell'account:</strong> creazione e gestione del profilo utente</li>
                            <li><strong>Elaborazione ordini:</strong> gestione degli acquisti di prodotti funebri (bare e accessori)</li>
                            <li><strong>Gestione pagamenti:</strong> elaborazione delle transazioni e gestione dei metodi di pagamento</li>
                            <li><strong>Spedizione prodotti:</strong> organizzazione della consegna tramite trasporto funebre, consegna a domicilio o ritiro in negozio</li>
                            <li><strong>Adempimenti contrattuali:</strong> esecuzione dei contratti di vendita</li>
                            <li><strong>Obblighi di legge:</strong> adempimento di obblighi fiscali e contabili</li>
                            <li><strong>Comunicazioni:</strong> invio di aggiornamenti sullo stato degli ordini</li>
                            <li><strong>Amministrazione:</strong> gestione del database clienti e amministrazione del sistema</li>
                        </ul>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Base Giuridica del Trattamento</h2>
                    </div>
                    <div class="info-text">
                        <p>Il trattamento dei dati personali è basato su:</p>
                        <ul>
                            <li><strong>Esecuzione del contratto:</strong> per l'erogazione dei servizi richiesti</li>
                            <li><strong>Obbligo di legge:</strong> per gli adempimenti previsti dalla normativa</li>
                            <li><strong>Consenso:</strong> per le comunicazioni commerciali (dove richiesto)</li>
                            <li><strong>Interesse legittimo:</strong> per la gestione amministrativa e la sicurezza</li>
                        </ul>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Modalità di Trattamento</h2>
                    </div>
                    <div class="info-text">
                        <p>I dati personali sono trattati con strumenti informatici e/o telematici, con modalità organizzative e con logiche strettamente correlate alle finalità indicate. Oltre al Titolare, potrebbero avere accesso ai dati categorie di incaricati coinvolti nell'organizzazione (amministrazione, commerciale, marketing, legali, amministratori di sistema) oppure soggetti esterni nominati Responsabili del trattamento.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Conservazione dei Dati</h2>
                    </div>
                    <div class="info-text">
                        <p>I dati personali vengono conservati per il tempo strettamente necessario al raggiungimento delle finalità per cui sono stati raccolti:</p>
                        <ul>
                            <li><strong>Dati dell'account:</strong> fino alla cancellazione dell'account da parte dell'utente</li>
                            <li><strong>Dati degli ordini:</strong> per tutta la durata necessaria alla gestione dell'ordine e per i tempi previsti dalla legge</li>
                            <li><strong>Dati di pagamento:</strong> le informazioni sensibili della carta di credito sono conservate solo per il tempo necessario alla transazione</li>
                            <li><strong>Dati per obblighi fiscali:</strong> 10 anni dalla cessazione del rapporto commerciale</li>
                            <li><strong>Dati di spedizione:</strong> conservati per il tempo necessario alla consegna e garanzia</li>
                        </ul>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Comunicazione e Diffusione</h2>
                    </div>
                    <div class="info-text">
                        <p>I dati personali potranno essere comunicati a:</p>
                        <ul>
                            <li>Autorità competenti per adempimenti di legge (Agenzia delle Entrate, forze dell'ordine)</li>
                            <li>Fornitori di servizi di pagamento per l'elaborazione delle transazioni</li>
                            <li>Corrieri e trasportatori per la consegna dei prodotti</li>
                            <li>Consulenti fiscali e commercialisti per gli adempimenti di legge</li>
                            <li>Fornitori di servizi tecnici e informatici per la manutenzione del sistema</li>
                        </ul>
                        <p>I dati non saranno mai diffusi senza il vostro esplicito consenso.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Diritti dell'Interessato</h2>
                    </div>
                    <div class="info-text">
                        <p>In base al GDPR, avete il diritto di:</p>
                        <ul>
                            <li><strong>Accesso:</strong> ottenere informazioni sui dati trattati</li>
                            <li><strong>Rettifica:</strong> correggere dati inesatti o incompleti</li>
                            <li><strong>Cancellazione:</strong> richiedere la cancellazione dei dati</li>
                            <li><strong>Limitazione:</strong> limitare il trattamento in determinate circostanze</li>
                            <li><strong>Portabilità:</strong> ricevere i dati in formato strutturato</li>
                            <li><strong>Opposizione:</strong> opporsi al trattamento per motivi legittimi</li>
                            <li><strong>Reclamo:</strong> presentare reclamo al Garante Privacy</li>
                        </ul>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Sicurezza dei Dati</h2>
                    </div>
                    <div class="info-text">
                        <p>Adottiamo misure di sicurezza tecniche e organizzative adeguate per proteggere i dati personali:</p>
                        <ul>
                            <li><strong>Crittografia:</strong> le password sono crittografate utilizzando algoritmo SHA-512</li>
                            <li><strong>Controlli di accesso:</strong> sistema di autenticazione con diversi livelli (utente/amministratore)</li>
                            <li><strong>Validazione dati:</strong> controlli automatici sui formati dei dati inseriti (email, telefono, codice fiscale, etc.)</li>
                            <li><strong>Backup regolari:</strong> copie di sicurezza del database per prevenire perdite di dati</li>
                            <li><strong>Vincoli di integrità:</strong> controlli automatici per garantire la coerenza dei dati</li>
                        </ul>
                        <p>Tutti i dati sono protetti da sistemi di sicurezza informatica e procedure interne rigorose per prevenire accessi non autorizzati, alterazioni o divulgazioni.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Cookie e Gestione Sessioni</h2>
                    </div>
                    <div class="info-text">
                        <p>Il nostro sito utilizza cookie tecnici necessari per il corretto funzionamento dell'e-commerce:</p>
                        <ul>
                            <li><strong>Cookie di sessione:</strong> per mantenere attiva la sessione utente durante la navigazione</li>
                            <li><strong>Cookie del carrello:</strong> per memorizzare i prodotti aggiunti al carrello durante la sessione di acquisto</li>
                            <li><strong>Cookie di autenticazione:</strong> per riconoscere l'utente loggato e mantenere l'accesso all'area riservata</li>
                        </ul>
                        <p>Questi cookie sono strettamente necessari per il funzionamento del sito e per consentire di completare gli acquisti. Non vengono utilizzati cookie di profilazione o per finalità pubblicitarie.</p>
                        <p>È possibile gestire le preferenze sui cookie attraverso le impostazioni del browser, tuttavia la disabilitazione potrebbe compromettere alcune funzionalità del sito, come il carrello degli acquisti.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">Modifiche alla Privacy Policy</h2>
                    </div>
                    <div class="info-text">
                        <p>Questa Privacy Policy può essere aggiornata periodicamente. Le modifiche saranno pubblicate su questa pagina con l'indicazione della data di ultimo aggiornamento. Vi invitiamo a consultare regolarmente questa pagina per rimanere informati su come proteggiamo i vostri dati.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp" %>       
</body>
</html>