# Tugurio-Semplice
# TugurioSemplice

## Descrizione del progetto

**TugurioSemplice** è un'applicazione web sviluppata in **Java EE** per la gestione di un e-commerce.

Il progetto permette:

* registrazione e login utente
* visualizzazione catalogo prodotti
* ricerca prodotti
* gestione carrello
* checkout ordini
* gestione pagamento
* generazione fattura
* gestione ordini utente
* area amministratore

L'architettura segue il pattern **MVC (Model - View - Controller)**:

* **Model** → gestione dati e accesso database
* **View** → JSP e interfaccia utente
* **Controller** → Servlet Java

---

## Tecnologie utilizzate

* Java
* Servlet
* JSP
* HTML / CSS
* MySQL
* Apache Tomcat
* JDBC

---

## Librerie utilizzate

Nella cartella `WEB-INF/lib` sono presenti:

* gson
* mysql-connector-java
* qrgen
* zxing core
* zxing javase

---

## Struttura del progetto

```text
src/
 ├── Model/
 │    ├── Bean
 │    ├── DAO
 │
 ├── Control/
 │    ├── Filtri
 │    ├── Servlet principali

WebContent/
 ├── Home/
 ├── AccessoUtente/
 ├── Checkout/
 ├── VisioneProdotti/
 ├── css/

db/
 ├── tugurio.sql
```

---

## Principali componenti

### Model

Contiene:

* Bean Java
* DAO per accesso database

Esempi:

* `ProdottoDAO`
* `ClienteDAO`
* `OrdineDAO`

---

### Controller

Gestisce le richieste HTTP.

Esempi:

* `LoginController`
* `SignInController`
* `CartController`
* `CheckoutController`
* `OrdineController`

---

### Filtri

Gestione sicurezza accessi:

* `UtenteLoggatoFiltro`
* `AdminFiltro`

---

## Database

Il file SQL è presente in:

```text
db/tugurio.sql
```

### Importazione database

1. Aprire MySQL
2. Creare un database
3. Importare il file SQL

```sql
source tugurio.sql
```

---

## Configurazione

Verificare i parametri di connessione nel DAO principale.

Configurare:

* nome database
* username
* password

---

## Avvio del progetto

1. Importare il progetto in Eclipse / IntelliJ
2. Configurare Apache Tomcat
3. Deploy del progetto
4. Avviare il server

---

## URL principale

```text
http://localhost:8080/TugurioSemplice
```

---

## Funzionalità principali

### Utente

* Registrazione
* Login
* Ricerca prodotti
* Carrello
* Checkout
* Storico ordini

### Admin

* Gestione catalogo prodotti
* Controllo ordini

---

## Note

Il progetto utilizza:

* sessioni utente
* filtri servlet
* accesso JDBC diretto

---

## Possibili miglioramenti futuri

* password cifrate
* responsive design
* pagamenti avanzati
* API REST

---

## Autore

Progetto universitario sviluppato per finalità didattiche.
