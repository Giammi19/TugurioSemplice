# TugurioSemplice

E-commerce per la vendita di bare artigianali, sviluppato come progetto universitario in **Java EE** con architettura **MVC**.

---

## Cosa fa

TugurioSemplice è un'applicazione web che gestisce l'intero ciclo di vendita online:

- **Catalogo prodotti** — visualizzazione e ricerca dei prodotti disponibili con scheda dettaglio
- **Carrello** — aggiunta, modifica e rimozione prodotti
- **Checkout** — inserimento dati di spedizione e pagamento con carta di credito
- **Conferma ordine** — riepilogo e generazione QR code di conferma
- **Fattura** — generazione e download della fattura in PDF
- **Area utente** — storico ordini, modifica dati anagrafici e di spedizione
- **Registrazione / Login / Recupero password**
- **Area amministratore** — gestione catalogo prodotti e lista utenti

---

## Stack tecnologico

| Layer | Tecnologie |
|---|---|
| Backend | Java EE, Servlet, JDBC |
| Frontend | JSP, HTML, CSS, JavaScript |
| Database | MySQL 8 |
| Server | Apache Tomcat |
| Build / IDE | Eclipse (progetto WTP) |

**Librerie incluse** (in `WEB-INF/lib/`):

- `gson` — serializzazione JSON
- `mysql-connector-java 8.0.12` — driver JDBC per MySQL
- `qrgen 1.4` + `zxing core/javase 3.5.1` — generazione QR code

---

## Struttura del progetto

```
TugurioSemplice/
├── src/
│   ├── Model/
│   │   ├── DAO.java                  # Classe base con gestione connessione
│   │   ├── ClienteBean/DAO           # Gestione utenti
│   │   ├── ProdottoBean/DAO          # Catalogo prodotti
│   │   ├── OrdineBean/DAO            # Ordini
│   │   ├── ProdottoOrdineBean/DAO    # Righe ordine
│   │   ├── CartaCreditoBean/DAO      # Pagamenti
│   │   ├── SpedizioneBean            # Dati spedizione
│   │   └── Cart.java                 # Logica carrello in sessione
│   └── Control/
│       ├── TugurioSemplice/          # Servlet principali
│       │   ├── LoginController
│       │   ├── SignInController
│       │   ├── CartController
│       │   ├── CheckoutController
│       │   ├── OrdineController
│       │   ├── PagamentoController
│       │   ├── FatturaController
│       │   ├── DisplayProductCatalogue
│       │   ├── RicercaProdotto
│       │   └── ...
│       └── Filtri/
│           ├── UtenteLoggatoFiltro   # Protegge le pagine autenticate
│           └── AdminFiltro           # Protegge le pagine amministratore
│
├── WebContent/
│   ├── index.jsp
│   ├── AccessoUtente/    # Login, SignIn, Recupero password
│   ├── AuthSites/        # Area utente (ordini, dati, modifica)
│   ├── AdminAction/      # Gestione utenti e prodotti (solo admin)
│   ├── VisioneProdotti/  # Catalogo e dettaglio prodotto
│   ├── Checkout/         # Flusso checkout e conferma
│   ├── Home/             # Chi siamo, Contatti, Privacy, T&C
│   ├── ErrorPage/        # Pagine 403, 404, 500
│   ├── css/
│   ├── JavaScript/
│   ├── photo/            # Immagini prodotti e UI
│   └── WEB-INF/
│       ├── web.xml
│       ├── lib/
│       └── context.xml   # Configurazione DataSource Tomcat
│
└── db/
    └── tugurio.sql       # Schema e dati iniziali
```

---

## Schema database

Il database si chiama `Tugurio` e contiene le seguenti tabelle principali:

- `Cliente` — credenziali e ruolo (utente / amministratore)
- `Dati_Anagrafici` — nome, cognome, codice fiscale, telefono
- `Indirizzo_Spedizione` — via, CAP, città, provincia
- `Carta_Credito` — dati carta (non cifrati — vedi note sicurezza)
- `Prodotto` — nome, descrizione, quantità, prezzo, IVA, immagine
- `Ordine` — ordini effettuati con stato e data
- `ProdottoOrdine` — righe ordine (prodotto × quantità × prezzo)
- `Pagamento` / `Spedizione` — dati relativi a ogni ordine

---

## Installazione e configurazione

### Prerequisiti

- **JDK 8+**
- **Apache Tomcat 9.x**
- **MySQL 8.x**
- **Eclipse IDE for Enterprise Java Developers 2026-03 (Eclipse 26)** (consigliato) oppure IntelliJ IDEA Ultimate

---

### 1. Database

Aprire MySQL e importare lo schema:

```sql
source /percorso/al/file/db/tugurio.sql;
```

Questo crea il database `Tugurio` con tutte le tabelle.

---

### 2. Configurazione connessione

Il progetto usa un **JNDI DataSource** configurato in Tomcat.

Aprire il file `WebContent/META-INF/context.xml` e modificare le credenziali:

```xml
<Resource name="jdbc/Tugurio"
          url="jdbc:mysql://localhost:3306/Tugurio?useSSL=false&amp;serverTimezone=UTC"
          username="TUO_USERNAME"
          password="TUA_PASSWORD"
          ... />
```

> ⚠️ **Il file contiene credenziali in chiaro** — non committare `context.xml` su repository pubblici.

---

### 3. Import del progetto in Eclipse

1. **File → Import → Existing Projects into Workspace**
2. Selezionare la cartella `TugurioSemplice-main`
3. Eclipse rileverà automaticamente il progetto WTP (Web Tools Platform)

---

### 4. Configurare Apache Tomcat in Eclipse

1. **Window → Preferences → Server → Runtime Environments → Add**
2. Selezionare **Apache Tomcat 9.x** e indicare la directory di installazione
3. Nella vista **Servers**, creare un nuovo server Tomcat 9
4. Aggiungere il progetto `TugurioSemplice` al server

---

### 5. Avvio

1. Click destro sul server → **Start**
2. Aprire il browser su:

```
http://localhost:8080/TugurioSemplice
```

---

## Accesso amministratore

Per creare un account admin, impostare manualmente il campo `Amministratore = TRUE` nella tabella `Cliente` oppure usare la servlet `/AdminAction/InsertAdmin` (accessibile solo da admin già autenticato).

---

## Note sulla sicurezza

Il progetto è a scopo **didattico** e presenta alcune limitazioni intenzionalmente non risolte:

- Le password sono salvate in chiaro (nessun hashing)
- I dati della carta di credito sono salvati in chiaro
- Nessun HTTPS configurato
- Credenziali DB in `context.xml`

**Non adatto per uso in produzione.**

---

## Possibili miglioramenti

- Hashing password (bcrypt)
- Cifratura dati sensibili
- Responsive design / mobile first
- Integrazione con gateway di pagamento reali
- Refactoring verso API REST + frontend separato

---

## Autore

Progetto universitario sviluppato per finalità didattiche.
