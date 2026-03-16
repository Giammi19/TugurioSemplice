<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Control.TugurioSemplice.*, Model.*, Control.TugurioSemplice.Admin.*"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
   	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href=" ../css/footerfile.css">
    <link rel="stylesheet" type="text/css" href="../css/scrollbar.css">
	<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;700;900&display=swap" rel="stylesheet">
    <title>Termini e Condizioni - TugurioSemplice</title>
</head>
<body>
<%@ include file="header.jsp" %>
    <div class="main-content">
        <div class="main-container">
            <div class="page-header">
                <h1>Termini e Condizioni</h1>
                <div class="company-name">TugurioSemplice</div>
                <p class="last-updated">Ultimo aggiornamento: 5 Giugno 2025</p>
            </div>
            
            <div class="content">
                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">1. Accettazione dei Termini</h2>
                    </div>
                    <div class="info-text">
                        <p>Utilizzando i servizi di <strong>TugurioSemplice</strong>, accetti integralmente i presenti termini e condizioni. Se non accetti questi termini, ti preghiamo di non utilizzare i nostri servizi.</p>
                        <p>TugurioSemplice si riserva il diritto di modificare questi termini in qualsiasi momento. Le modifiche entreranno in vigore immediatamente dopo la pubblicazione sul nostro sito web.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">2. Descrizione dei Servizi</h2>
                    </div>
                    <div class="info-text">
                        <p>TugurioSemplice fornisce servizi di onoranze funebri comprensivi di:</p>
                        <ul>
                            <li>Organizzazione di cerimonie funebri</li>
                            <li>Servizi di trasporto funebre</li>
                            <li>Preparazione e cura della salma</li>
                            <li>Fornitura di bare e accessori funebri</li>
                            <li>Servizi di cremazione e sepoltura</li>
                            <li>Assistenza burocratica e documentale</li>
                            <li>Servizi commemorativi personalizzati</li>
                        </ul>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">3. Responsabilità del Cliente</h2>
                    </div>
                    <div class="info-text">
                        <p>Il cliente si impegna a:</p>
                        <ul>
                            <li>Fornire informazioni accurate e complete</li>
                            <li>Rispettare i termini di pagamento stabiliti</li>
                            <li>Collaborare attivamente nell'organizzazione dei servizi</li>
                            <li>Rispondere tempestivamente alle richieste di documentazione</li>
                            <li>Comunicare eventuali modifiche o cancellazioni con adeguato preavviso</li>
                        </ul>
                        <p>Il cliente è responsabile dell'accuratezza delle informazioni fornite e delle conseguenze derivanti da informazioni errate o incomplete.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">4. Prezzi e Condizioni di Pagamento</h2>
                    </div>
                    <div class="info-text">
                        <p>I prezzi dei servizi sono indicati nei preventivi personalizzati e includono:</p>
                        <ul>
                            <li>Tutti i servizi base specificati nel contratto</li>
                            <li>IVA e tasse applicabili</li>
                            <li>Servizi di assistenza burocratica standard</li>
                        </ul>
                        <p><strong>Modalità di pagamento:</strong> Il pagamento può essere effettuato tramite contanti, bonifico bancario, carta di credito o accordi di pagamento rateale, previo accordo specifico.</p>
                        <p><strong>Termini di pagamento:</strong> Salvo diversi accordi, il pagamento è richiesto prima dell'erogazione dei servizi o secondo le modalità specificate nel contratto.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">5. Cancellazioni e Modifiche</h2>
                    </div>
                    <div class="info-text">
                        <p>Comprendiamo che le circostanze possono cambiare. Per cancellazioni o modifiche sostanziali:</p>
                        <ul>
                            <li>È richiesto un preavviso di almeno 24 ore quando possibile</li>
                            <li>Alcune spese già sostenute potrebbero non essere rimborsabili</li>
                            <li>Modifiche dell'ultimo minuto potrebbero comportare costi aggiuntivi</li>
                            <li>Ogni situazione sarà valutata individualmente con comprensione e flessibilità</li>
                        </ul>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">6. Limitazioni di Responsabilità</h2>
                    </div>
                    <div class="info-text">
                        <p>TugurioSemplice non sarà responsabile per:</p>
                        <ul>
                            <li>Ritardi causati da fattori esterni (traffico, condizioni meteorologiche, emergenze)</li>
                            <li>Danni indiretti o consequenziali</li>
                            <li>Situazioni di forza maggiore</li>
                            <li>Errori derivanti da informazioni errate fornite dal cliente</li>
                        </ul>
                        <p>La nostra responsabilità è limitata al rimborso degli importi pagati per i servizi non forniti correttamente.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">7. Privacy e Riservatezza</h2>
                    </div>
                    <div class="info-text">
                        <p>TugurioSemplice si impegna a:</p>
                        <ul>
                            <li>Mantenere la massima riservatezza su tutte le informazioni personali</li>
                            <li>Utilizzare i dati solo per l'erogazione dei servizi richiesti</li>
                            <li>Rispettare integralmente la normativa sulla privacy (GDPR)</li>
                            <li>Non condividere informazioni con terzi senza consenso esplicito</li>
                        </ul>
                        <p>Per maggiori dettagli, consulta la nostra <strong>Informativa sulla Privacy</strong>.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">8. Risoluzione delle Controversie</h2>
                    </div>
                    <div class="info-text">
                        <p>In caso di controversie, ci impegniamo a:</p>
                        <ul>
                            <li>Cercare sempre una soluzione amichevole attraverso il dialogo</li>
                            <li>Fornire un servizio di mediazione interno gratuito</li>
                            <li>Rispondere a reclami entro 48 ore lavorative</li>
                            <li>Adottare misure correttive quando necessario</li>
                        </ul>
                        <p>Per controversie non risolvibili amichevolmente, sarà competente il foro di <strong>Roma</strong>, secondo la legge italiana.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">9. Diritti del Consumatore</h2>
                    </div>
                    <div class="info-text">
                        <p>Riconosciamo e rispettiamo tutti i diritti previsti dal <strong>Codice del Consumo</strong> italiano, inclusi:</p>
                        <ul>
                            <li>Diritto di recesso secondo le modalità di legge</li>
                            <li>Diritto alla garanzia sui servizi forniti</li>
                            <li>Diritto di reclamo e ricorso</li>
                            <li>Diritto all'informazione trasparente sui prezzi</li>
                        </ul>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">10. Contatti e Comunicazioni</h2>
                    </div>
                    <div class="info-text">
                        <p>Per qualsiasi questione relativa a questi termini e condizioni, puoi contattarci:</p>
                        <ul>
                            <li><strong>Email:</strong> info@tuguriosemplice.it</li>
                            <li><strong>Telefono:</strong> Disponibile 24/7 per emergenze</li>
                            <li><strong>Sede:</strong> [Inserire indirizzo completo]</li>
                        </ul>
                        <p>Ci impegniamo a rispondere a tutte le comunicazioni nel minor tempo possibile, con la massima attenzione e rispetto.</p>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">11. Disposizioni Finali</h2>
                    </div>
                    <div class="info-text">
                        <p>Questi termini e condizioni sono disciplinati dalla <strong>legge italiana</strong>. In caso di invalidità di una o più clausole, le restanti disposizioni rimangono pienamente efficaci.</p>
                        <p>L'eventuale tolleranza da parte di TugurioSemplice riguardo a violazioni di questi termini non costituisce rinuncia ai diritti derivanti dagli stessi.</p>
                        <p><strong>Data di entrata in vigore:</strong> 5 Giugno 2025</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
       <%@ include file="footer.jsp" %>
</body>
</html>