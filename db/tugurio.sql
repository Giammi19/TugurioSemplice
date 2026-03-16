DROP SCHEMA IF EXISTS Tugurio;
CREATE SCHEMA Tugurio;

USE Tugurio;

CREATE TABLE Cliente (
    ID_Cliente INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Passkey VARCHAR(128) NOT NULL,
    Amministratore BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT CK_EmailFormat CHECK (Email LIKE '%@%.%'),
    CONSTRAINT CK_UsernameFormat CHECK (Username NOT LIKE '%@%.%'),
    CONSTRAINT CK_UsernameLength CHECK (LENGTH(Username) >= 5)
);

CREATE TABLE Dati_Anagrafici (
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    CF VARCHAR(16) NOT NULL UNIQUE,
    Telefono VARCHAR(20) NOT NULL,
    IdCliente INT,
    FOREIGN KEY (IdCliente) REFERENCES Cliente(ID_Cliente) ON DELETE CASCADE
);

CREATE TABLE Carta_Credito (
	IdCliente INT NOT NULL UNIQUE,
    Nome VARCHAR(255) NOT NULL,
    Cognome VARCHAR(255) NOT NULL,
    NumeroCarta VARCHAR(19) NOT NULL,
    DataScadenza VARCHAR(5) NOT NULL,
    CVV VARCHAR(3) NOT NULL,
    FOREIGN KEY (IdCliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE Indirizzo_Spedizione (
    Via VARCHAR(100) NOT NULL,
    CAP VARCHAR(5) NOT NULL,
    Citta VARCHAR(50) NOT NULL,
    Provincia VARCHAR(2) NOT NULL,
    IdCliente INT,
    FOREIGN KEY (IdCliente) REFERENCES Cliente(ID_Cliente) ON DELETE CASCADE,
    CONSTRAINT CK_CAPFormat CHECK (LENGTH(CAP) = 5 AND CAP REGEXP '^[0-9]+$'),
    CONSTRAINT CK_ProvinciaFormat CHECK (LENGTH(Provincia) = 2 AND Provincia REGEXP '^[A-Z]+$')
);


CREATE TABLE Prodotto (
    ID_Prodotto INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(255) NOT NULL,
    Descrizione TEXT,
    Quantita INT UNSIGNED NOT NULL DEFAULT 0,
    Disponibilita BOOLEAN NOT NULL DEFAULT TRUE,
    Prezzo_Base DECIMAL(10, 2) NOT NULL,
    Iva DECIMAL(4, 2) NOT NULL DEFAULT 0.22,
    Immagine VARCHAR(255) DEFAULT "photo/GenericImage.jpg",
    CONSTRAINT CK_QuantitaNonNegativa CHECK (Quantita >= 0),
    CONSTRAINT CK_PrezzoBasePositivo CHECK (Prezzo_Base > 0),
    CONSTRAINT CK_IvaValida CHECK (Iva >= 0.00 AND Iva <= 22.00)
);

CREATE TABLE Acquista (
    IdProdotto INT,
    IdCliente INT,
    FOREIGN KEY (IdProdotto) REFERENCES Prodotto (ID_Prodotto),
    FOREIGN KEY (IdCliente) REFERENCES Cliente (ID_Cliente) ON DELETE CASCADE
);

CREATE TABLE Ordine (
    ID_Ordine INT PRIMARY KEY AUTO_INCREMENT,
    IdCliente INT,
    Data_Ordine DATETIME DEFAULT CURRENT_TIMESTAMP,
    Prezzo_Ordine DECIMAL(10, 2) NOT NULL,
    Stato_Ordine VARCHAR(30) NOT NULL,
    FOREIGN KEY (IdCliente) REFERENCES Cliente(ID_Cliente) ON DELETE CASCADE,
    CONSTRAINT CK_PrezzoOrdinePositivo CHECK (Prezzo_Ordine > 0),
    CONSTRAINT CK_StatoOrdineValido CHECK (Stato_Ordine IN ('in consegna', 'non consegnato', 'consegnato', 'annullato'))
);

CREATE TABLE Pagamento (
    ID_Ordine INT PRIMARY KEY,
    Importo DECIMAL NOT NULL,
    Data_Pagamento DATETIME,
    Metodo VARCHAR(255) NOT NULL,
    CONSTRAINT CK_importo CHECK (Importo >= 0),
    CONSTRAINT CK_metodo CHECK (Metodo IN ('Carta', 'Contanti')),
    FOREIGN KEY (ID_Ordine) REFERENCES Ordine(ID_Ordine) ON DELETE CASCADE
);

CREATE TABLE ProdottoOrdine (
    ID_ProdottoOrdine INT PRIMARY KEY AUTO_INCREMENT,
    IdOrdine INT,
    Nome VARCHAR(255) NOT NULL,
    Prezzo DECIMAL(10, 2) NOT NULL,
    Quantita INT UNSIGNED NOT NULL,
    Iva DECIMAL(4, 2) NOT NULL DEFAULT 0.22,
    FOREIGN KEY (IdOrdine) REFERENCES Ordine(ID_Ordine) ON DELETE CASCADE
);

CREATE TABLE Spedizione (
    ID_Ordine INT PRIMARY KEY,
    Spese DECIMAL NOT NULL,
    Data_Consegna DATETIME,
    Metodo VARCHAR(255) NOT NULL,
    CONSTRAINT CK_metodoSpedizione CHECK (Metodo IN ('Trasporto funebre', 'Consegna a domicilio', 'Ritiro in negozio')),
    CONSTRAINT CK_spese CHECK (Spese >= 0),
    FOREIGN KEY (ID_Ordine) REFERENCES Ordine(ID_Ordine) ON DELETE CASCADE
);




-- Inserimento di bare di diverso tipo nel database
INSERT INTO Prodotto (Nome, Descrizione, Quantita, Disponibilita, Prezzo_Base, Iva, Immagine) VALUES 
('Cassa intarsio Edera', 'Questa bara è un tributo che combina la bellezza dell\'artigianato con un profondo simbolismo naturale, 
caratterizzata da un delicato intarsio raffigurante l\Edera. Realizzata con legni pregiati come il noce, il rovere o il ciliegio, 
la superficie della cassa diventa la tela per questa immagine evocativa. L\'Edera è un simbolo antico e universale di fedeltà, attaccamento, a
more eterno, memoria e immortalità, grazie alla sua capacità di rimanere verde anche d\'inverno
 e di crescere avvolgendo e sostenendosi.', 8, TRUE, 1800.00, 0.22, 'photo/Bare/BaraEdera.jpg'),

('Cassa intarsio Madonna', 'Questa bara è un''espressione di profonda fede e reverenza, impreziosita da un maestoso intarsio raffigurante la Madonna. 
Realizzata con legni pregiati e nobili, come il noce, il ciliegio o il rovere, la superficie della cassa si trasforma in un\'opera d\'arte sacra. 
L\'intarsio è il frutto di una meticolosa e devota lavorazione artigianale, dove diverse essenze lignee, ognuna con le sue uniche sfumature e venature naturali, 
vengono tagliate e incastonate con estrema precisione per comporre l\immagine della Madonna, spesso raffigurata in preghiera, con il Bambino, o in una posa 
di grazia e consolazione.', 12, TRUE, 900.00, 0.22, 'photo/Bare/BaraMadonna.jpg'),

('Cassa Abete Eco. Rovere', 'Questa bara rappresenta una soluzione dignitosa ed ecologica, combinando la praticità dell\'abete con l\'estetica calda e robusta del rovere.
 La struttura principale è realizzata in legno di abete, una scelta economica e sostenibile per la sua abbondante disponibilità e la sua leggerezza.
La caratteristica distintiva di questa cassa è la sua finitura "Eco Rovere"', 4, TRUE, 850.00, 0.22, 'photo/Bare/BaraAbeteR.jpg'),

('Cassa Frakè', 'Questa bara è realizzata in legno di Frakè, un\'essenza che sta guadagnando popolarità nel settore funerario per le sue caratteristiche estetiche e funzionali. 
Il Frakè, noto anche come Frassino Tropicale (Terminalia Superba), si distingue per la sua colorazione chiara e luminosa, che varia dal bianco-giallastro al bruno chiaro,
spesso con sfumature dorate e venature ben definite ma non eccessivamente marcate.', 20, TRUE, 450.00, 0.22, 'photo/Bare/BaraFrake.jpg'),

('Cassa Abete Eco. Cedro', 'Questa bara offre una soluzione dignitosa ed evocativa, unendo la leggerezza e la praticità dell\'abete con l\'estetica distintiva del cedro.
 La struttura portante è realizzata in legno di abete, un materiale versatile e ampiamente disponibile, scelto per la sua leggerezza e la sua sostenibilità.
La sua caratteristica principale è la finitura "Eco Cedro".', 15, TRUE, 350.00, 0.22, 'photo/Bare/BaraAbeteC.jpg'),

('Cassa a spella stretta', 'Questa bara è caratterizzata da un design elegante e slanciato, definito dalla sua forma a "spalla stretta". A differenza delle bare
 rettangolari classiche, questo modello presenta una lieve riduzione della larghezza dalla zona delle spalle verso i piedi, creando una silhouette più affusolata
 e contemporanea. Questa configurazione non solo conferisce un''estetica più leggera e meno imponente, ma può anche ottimizzare lo spazio
 e facilitare la manipolazione.', 2, TRUE, 5500.00, 0.22, 'photo/Bare/BaraSpella.jpg'),

('Cassa Abete Ecologica', 'Questa bara rappresenta una scelta consapevole e rispettosa dell\'ambiente, interamente realizzata in legno di abete proveniente da foreste
gestite in modo sostenibile. L\'abete, già di per sé un legno comune e facilmente rinnovabile, in questa versione ecologica viene valorizzato
 per la sua impronta ambientale ridotta.', 0, FALSE, 300.00, 0.22, 'photo/Bare/BaraAbeteE.jpg'),

('Cassa Frassino', 'Questa bara è realizzata in legno di frassino, un\'essenza che conferisce un\'eleganza raffinata e una robustezza notevole. Il frassino è molto
 apprezzato per la sua splendida venatura ben marcata e il suo colore chiaro, che varia dal bianco crema al biondo paglierino, a volte con un cuore più scuro che
 crea contrasti affascinanti. È un legno con una grande flessibilità e resistenza agli urti,
 pur essendo relativamente leggero e facile da lavorare.', 25, TRUE, 120.00, 0.22, 'photo/Bare/BaraFrassino.jpg'),

('Cassa Olmo', 'Questa bara è realizzata in legno di Olmo, un''essenza che evoca robustezza, resilienza e una bellezza naturale sobria ma distintiva.
 L\'Olmo è apprezzato per le sue venature marcate e ondulate che creano disegni affascinanti e irregolari, e per la sua colorazione che spazia dal marrone chiaro
 al bruno dorato, spesso con sfumature verdastre o rossastre.Storicamente, l\'olmo è stato valorizzato per la sua resistenza all\'acqua e agli urti, e per la sua durabilità,
 pur essendo un legno con una buona lavorabilità. ', 35, TRUE, 80.00, 0.22, 'photo/Bare/BaraOlmo.jpg'),

('Cassa Abete', 'Una bara realizzata in legno di abete, una scelta comune e apprezzata per la sua leggerezza e luminosità. 
L\'abete è un legno tenero e chiaro, con una colorazione che varia dal bianco crema al giallo pallido, e venature generalmente 
diritte e discrete. Questo legno è largamente utilizzato grazie alla sua facilità  di lavorazione e alla sua disponibilità, 
che ne fanno un\'opzione economica e accessibile. Pur non avendo la densità o la resistenza di legni più duri come il rovere o 
il noce, l\'abete offre una struttura solida e dignitosa per un ultimo riposo.', 40, TRUE, 600.00, 0.22, 'photo/Bare/CassaAbete.jpg'),

('Cassa Becco di Civetta in Noce', 'Questa bara è un omaggio alla tradizione artigianale e all\'eleganza classica, realizzata 
in pregiato legno di noce. Il noce, con le sue venature ricche e i toni caldi e profondi, offre una base di solennità  e bellezza intrinseca, 
simbolo di dignità  e durata. Il design è nobilitato dalla presenza del profilo a "Becco di Civetta", una raffinata modanatura intagliata lungo i bordi o 
i pannelli della cassa.', 25, TRUE, 2500.00, 0.22, 'photo/Bare/beccoDicivetta.jpg'),

(  'Cassa Cristian',
  'Questa bara offre un omaggio distintivo e di profonda risonanza emotiva, caratterizzata da una raffinata laccatura color viola. 
  Il legno di base, solitamente abete o pioppo per la loro superficie liscia e la capacità di prendere bene la laccatura, viene trasformato da questo colore ricco e significativo. 
  Il viola è una tonalità che evoca spiritualità, nobiltà, lutto reverente e talvolta anche creatività e individualità. La finitura può variare: un viola intenso e lucido conferisce un aspetto sontuoso 
  e profondo, che cattura la luce, mentre una laccatura opaca o satinata offre una resa più sobria e vellutata, di grande eleganza.', 1, TRUE, 1069.00, 0.22,'photo/Bare/cristian.jpg'),

('Cassa Finitura Abete', 'Questa bara, realizzata in legno di abete, è un''opzione che unisce la praticità  e la luminosità  di questo materiale a una 
finitura personalizzata che ne esalta l''estetica. L''abete è un legno chiaro, con venature discrete e una texture uniforme, noto per la sua leggerezza e la facilità  
di lavorazione. E'' una scelta comune e versatile, che si presta bene a ricevere diverse tipologie di finitura.', 12, TRUE, 800.00, 0.22, 'photo/Bare/finituraAbete.jpg'),

('Cassa in noce - Cordoncino', 'La combinazione del noce, un legno solido e maestoso, con il dettaglio del cordoncino, crea un''armonia tra robustezza e delicatezza, 
offrendo un ultimo riposo di grande classe e rispetto. La finitura, che può essere lucida o satinata, esalta la ricchezza del colore e del disegno del legno, valorizzando 
ogni singolo dettaglio.', 34, TRUE, 200.00, 0.22, 'photo/Bare/cassaNoceCordoncino.jpg'),

('Cassa intarsio Cristo', 'Questa cassa funebre è un''opera di raffinata arte e fede, caratterizzata da un pregevole intarsio raffigurante il Cristo. Realizzata con legni nobili
e scelti, come il noce, il rovere o il ciliegio, la superficie della cassa diventa una tela per una rappresentazione sacra. L\'intarsio, frutto di una lavorazione artigianale meticolosa,
 prevede l\'assemblaggio di diverse essenze lignee, ognuna con le sue sfumature e venature naturali, per comporre l\'immagine del Cristo, spesso nella sua forma crocifissa o risorta, 
o con simboli cristiani come l\'Alfa e l\'Omega, o il Chi Rho.', 4, TRUE, 4000.00, 0.22, 'photo/Bare/cassaIntarsioCristo.jpg'),

('Cassa intarsio Mezzaluna', 'Questa cassa funebre è un\'opera d\'arte e un simbolo di particolare significato, impreziosita da un delicato intarsio raffigurante la Mezzaluna. 
Realizzata con legni pregiati come il noce, il ciliegio o il rovere, la superficie della cassa diventa una tela per questa immagine evocativa. L\'intarsio è il risultato di 
una meticolosa lavorazione artigianale, dove diverse essenze lignee vengono tagliate e assemblate con precisione per creare il disegno della Mezzaluna, spesso accompagnata da 
stelle o altri elementi celesti. Ogni frammento di legno, con le sue uniche venature e tonalità  naturali, è incastonato per dare vita a un\'immagine dettagliata e luminosa, 
che cattura lo sguardo e trasmette un senso di pace e mistero.', 11, TRUE, 3500.00, 0.22, 'photo/Bare/CassaIntarsioMezzaluna.jpg'),

('Cassa Larice', 'Una bara realizzata in robusto e caratteristico legno di larice, una scelta che offre una bellezza naturale e una grande resistenza. Il larice è 
un legno con un''identità  forte, conosciuto per la sua splendida colorazione che varia dal giallo rossastro al bruno chiaro, spesso con venature ben marcate che gli 
conferiscono un aspetto rustico ma elegante. Questo legno è particolarmente apprezzato per la sua naturale durabilità  e resistenza agli agenti atmosferici, qualità  
che lo rendono una scelta solida e affidabile.', 0, TRUE, 1000.00, 0.22, 'photo/Bare/CassaLarice.jpg'),

('Cassa Noce', 'Una bara realizzata in pregiato legno di noce, un''essenza che evoca calore, eleganza e una dignità  senza tempo. Il noce è rinomato per le sue splendide 
venature scure e complesse, che variano dalle tonalità più chiare del marrone dorato a quelle più profonde del cioccolato, spesso con sfumature violacee o rossastre. 
Questo legno, naturalmente resistente e durevole, si presta a lavorazioni artigianali di alta qualità , permettendo intagli raffinati e dettagli curati che esaltano la sua 
bellezza intrinseca.', 10, TRUE, 1800.00, 0.22, 'photo/Bare/cassaNoce.jpg'),

('Cassa Olivo', 'Questa cassa in legno d''ulivo di alta qualità è un esempio di eccellenza artigianale. La densità  e la durabilità  del legno d\'ulivo 
garantiscono una struttura solida e affidabile, mentre le sue particolari marezzature e la finitura liscia esaltano la naturale eleganza del materiale. Un\'opzione 
di pregio che combina resistenza e un''estetica senza tempo.', 30, TRUE, 2500.00, 0.22, 'photo/Bare/cassaOlivo.jpg'),

('Cassa Rovere', 'Una bara realizzata in robusto e nobile legno di rovere, una scelta che comunica solidità , 
dignità  e un legame profondo con la tradizione. Il rovere è apprezzato per la sua straordinaria resistenza e durabilità , 
caratteristiche che lo rendono un materiale ideale per un omaggio duraturo. Le sue venature sono ben definite, spesso diritte e con un disegno marcato, 
e il suo colore varia dal biondo chiaro al marrone medio, con sfumature che possono tendere al grigio o al dorato, a seconda della provenienza e del tipo di 
rovere.', 17, TRUE, 1200.00, 0.22, 'photo/Bare/cassaRovere.jpg'),

('Cassa Scorniciata Intagliata Frakè', 'Questa bara è un connubio di sobria eleganza e raffinata lavorazione artigianale, realizzata in legno di Frakè. 
Il Frakè è un\'essenza apprezzata per la sua colorazione chiara e uniforme, che varia dal crema al giallo pallido, con una venatura discreta ma distintiva. 
Questo legno, pur essendo più leggero rispetto a essenze come il noce o il mogano, è facilmente lavorabile, il che lo rende ideale per ricevere intagli 
complessi e finiture elaborate.', 6, TRUE, 1800.00, 0.22, 'photo/Bare/scorniciaturaIntagliataFrake.jpg'),

('Cassa Spalla Intagliata in Mogano', 'Questa bara rappresenta l''apice dell\'eleganza e dell''artigianato funerario, distinguendosi per la sua spalla intagliata 
in pregiato legno di mogano. Il mogano è un\'essenza riconosciuta a livello mondiale per la sua bellezza eccezionale, il colore rosso-brunastro intenso e le 
venature fini e regolari, che gli conferiscono una lucentezza naturale e una profondità  ineguagliabile. E\' un legno che emana un senso di lusso e 
solennità.', 7, TRUE, 5000.00, 0.22, 'photo/Bare/moganoSpallaIntagliata.jpg'),

('Cassa Zinco', 'Questa bara è concepita per rispondere a specifiche esigenze di traslazione e conservazione, unendo la sobrietà  del legno di abete a una robusta 
protezione esterna e un\'essenziale eleganza interna. La struttura principale è realizzata in legno di abete, un materiale scelto per la sua leggerezza e facilità  
di lavorazione. La finitura esterna in zinco (o una lega metallica equivalente, spesso alluminio trattato) è 
la sua caratteristica più distintiva.', 23, TRUE, 1500.00, 0.22, 'photo/Bare/cassaZinco.jpg');

INSERT INTO Cliente (Username, Email, Passkey, Amministratore) VALUES 
('ADMIN1', 'admin@tugurio.it', SHA2('TugurioAdmin10', 512), TRUE);

INSERT INTO Dati_Anagrafici (Nome, Cognome, CF, Telefono, IdCliente) VALUES 
('Mario', 'Rossi', 'RSSMRA80A01H501X', '+393001234567', 1);

INSERT INTO Indirizzo_Spedizione (Via, CAP, Citta, Provincia, IdCliente)
VALUES 
('Via Roma 123', '00100', 'Roma', 'RM', 1);