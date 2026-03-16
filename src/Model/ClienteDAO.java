package Model;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class ClienteDAO extends DAO<ClienteBean> {

    public ClienteDAO() {
        super();
    }

    @Override
    public void doSave(ClienteBean cliente) throws SQLException {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Inizia transazione
            
            try {
                // Inserimento cliente principale
                String sql1 = "INSERT INTO cliente (Username, Email, Passkey, Amministratore) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmt1 = conn.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS)) {
                    stmt1.setString(1, cliente.getUsername());
                    stmt1.setString(2, cliente.getEmail());
                    stmt1.setString(3, cliente.getPasskey());
                    stmt1.setBoolean(4, cliente.getIsAmministratore());
                    stmt1.executeUpdate();

                    // Recupera ID generato
                    try (ResultSet generatedKeys = stmt1.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            cliente.setIdCliente(generatedKeys.getInt(1));
                        }
                    }
                }

                // Inserimento dati anagrafici
                String sql2 = "INSERT INTO dati_anagrafici (IdCliente, Nome, Cognome, CF, Telefono) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                    stmt2.setInt(1, cliente.getIdCliente());
                    stmt2.setString(2, cliente.getAnagrafia().getNome());
                    stmt2.setString(3, cliente.getAnagrafia().getCognome());
                    stmt2.setString(4, cliente.getAnagrafia().getCf());
                    stmt2.setString(5, cliente.getAnagrafia().getTelefono());
                    stmt2.executeUpdate();
                }

                // Inserimento indirizzo spedizione
                String sql3 = "INSERT INTO indirizzo_spedizione (Via, CAP, Citta, Provincia, IdCliente) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement stmt3 = conn.prepareStatement(sql3)) {
                    stmt3.setString(1, cliente.getIndirizzoSpedizione().getVia());
                    stmt3.setString(2, cliente.getIndirizzoSpedizione().getCap());
                    stmt3.setString(3, cliente.getIndirizzoSpedizione().getCitta());
                    stmt3.setString(4, cliente.getIndirizzoSpedizione().getProvincia());
                    stmt3.setInt(5, cliente.getIdCliente());
                    stmt3.executeUpdate();
                }

                conn.commit(); // Commit transazione
            } catch (SQLException e) {
                conn.rollback(); // Rollback in caso di errore
                throw e;
            } finally {
                conn.setAutoCommit(true); // Ripristina auto-commit
            }
        }
    }

    @Override
    public void doUpdate(ClienteBean item) throws SQLException {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Inizia transazione
            
            try {
                // Aggiorna cliente principale
                String sql1 = "UPDATE cliente SET Username = ?, Email = ?, Passkey = ?, Amministratore = ? WHERE ID_Cliente = ?";
                try (PreparedStatement stmt1 = conn.prepareStatement(sql1)) {
                    stmt1.setString(1, item.getUsername());
                    stmt1.setString(2, item.getEmail());
                    stmt1.setString(3, item.getPasskey());
                    stmt1.setBoolean(4, item.getIsAmministratore());
                    stmt1.setInt(5, item.getIdCliente());
                    stmt1.executeUpdate();
                }

                // Aggiorna dati anagrafici
                String sql2 = "UPDATE dati_anagrafici SET Nome = ?, Cognome = ?, CF = ?, Telefono = ? WHERE IDCliente = ?";
                try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                    stmt2.setString(1, item.getAnagrafia().getNome());
                    stmt2.setString(2, item.getAnagrafia().getCognome());
                    stmt2.setString(3, item.getAnagrafia().getCf());
                    stmt2.setString(4, item.getAnagrafia().getTelefono());
                    stmt2.setInt(5, item.getIdCliente());
                    stmt2.executeUpdate();
                }

                // Aggiorna indirizzo spedizione
                String sql3 = "UPDATE indirizzo_spedizione SET Via = ?, CAP = ?, Citta = ?, Provincia = ? WHERE IDCliente = ?";
                try (PreparedStatement stmt3 = conn.prepareStatement(sql3)) {
                    stmt3.setString(1, item.getIndirizzoSpedizione().getVia());
                    stmt3.setString(2, item.getIndirizzoSpedizione().getCap());
                    stmt3.setString(3, item.getIndirizzoSpedizione().getCitta());
                    stmt3.setString(4, item.getIndirizzoSpedizione().getProvincia());
                    stmt3.setInt(5, item.getIdCliente());
                    stmt3.executeUpdate();
                }

                conn.commit(); // Commit transazione
            } catch (SQLException e) {
                conn.rollback(); // Rollback in caso di errore
                throw e;
            } finally {
                conn.setAutoCommit(true); // Ripristina auto-commit
            }
        }
    }

    @Override
    public boolean doDelete(int id) throws SQLException {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Inizia transazione
            
            try {
                // Elimina indirizzo spedizione
                deleteFromTable(conn, "DELETE FROM indirizzo_spedizione WHERE IDCliente = ?", id);
                
                // Elimina dati anagrafici
                deleteFromTable(conn, "DELETE FROM dati_anagrafici WHERE IDCliente = ?", id);
                
                // Elimina cliente
                int result = deleteFromTable(conn, "DELETE FROM cliente WHERE ID_Cliente = ?", id);
                
                conn.commit(); // Commit transazione
                return result > 0;
            } catch (SQLException e) {
                conn.rollback(); // Rollback in caso di errore
                throw e;
            } finally {
                conn.setAutoCommit(true); // Ripristina auto-commit
            }
        }
    }

    private int deleteFromTable(Connection conn, String sql, int id) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate();
        }
    }

    @Override
    public ClienteBean doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM cliente " +
                     "JOIN dati_anagrafici ON cliente.ID_Cliente = dati_anagrafici.IdCliente " +
                     "JOIN indirizzo_spedizione ON cliente.ID_Cliente = indirizzo_spedizione.IdCliente " +
                     "WHERE ID_Cliente = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapClienteFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    public ClienteBean doRetrieveByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM cliente " +
                     "JOIN dati_anagrafici ON cliente.ID_Cliente = dati_anagrafici.IdCliente " +
                     "JOIN indirizzo_spedizione ON cliente.ID_Cliente = indirizzo_spedizione.IdCliente " +
                     "WHERE Username = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapClienteFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public ClienteBean doRetrieveByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM cliente " +
                     "JOIN dati_anagrafici ON cliente.ID_Cliente = dati_anagrafici.IdCliente " +
                     "JOIN indirizzo_spedizione ON cliente.ID_Cliente = indirizzo_spedizione.IdCliente " +
                     "WHERE Email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapClienteFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public ArrayList<ClienteBean> doRetrieveAll(String ordine) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM cliente " +
                "JOIN dati_anagrafici ON cliente.ID_Cliente = dati_anagrafici.IdCliente " +
                "JOIN indirizzo_spedizione ON cliente.ID_Cliente = indirizzo_spedizione.IdCliente");
        
        if (ordine != null && !ordine.isEmpty()) {
            sql.append(" ORDER BY ").append(ordine);
        }
        
        ArrayList<ClienteBean> listaClienti = new ArrayList<>();
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString());
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                listaClienti.add(mapClienteFromResultSet(rs));
            }
        }
        return listaClienti;
    }

    private ClienteBean mapClienteFromResultSet(ResultSet rs) throws SQLException {
        ClienteBean cliente = new ClienteBean();
        cliente.setIdCliente(rs.getInt("ID_Cliente"));
        cliente.setUsername(rs.getString("Username"));
        cliente.setEmail(rs.getString("Email"));
        cliente.setPasskey(rs.getString("Passkey"));
        cliente.setIsAmministratore(rs.getBoolean("Amministratore"));

        // Dati anagrafici
        DatiAnagraficiBean anagrafia = new DatiAnagraficiBean();
        anagrafia.setNome(rs.getString("Nome"));
        anagrafia.setCognome(rs.getString("Cognome"));
        anagrafia.setCf(rs.getString("CF"));
        anagrafia.setTelefono(rs.getString("Telefono"));
        cliente.setAnagrafia(anagrafia);

        // Indirizzo spedizione
        IndirizzoSpedizioneBean indirizzo = new IndirizzoSpedizioneBean();
        indirizzo.setVia(rs.getString("Via"));
        indirizzo.setCap(rs.getString("CAP"));
        indirizzo.setCitta(rs.getString("Citta"));
        indirizzo.setProvincia(rs.getString("Provincia"));
        cliente.setIndirizzoSpedizione(indirizzo);

        return cliente;
    }
    
    public List<String> getUsersSuggestions(String query) throws SQLException {
        List<String> suggestions = new ArrayList<>();
        
        if (query == null || query.trim().isEmpty() || query.trim().length() < 2) {
            return suggestions;
        }

        String sql = "SELECT c.ID_Cliente, d.Nome, d.Cognome, c.Username " +
                   "FROM Cliente c " +
                   "JOIN Dati_Anagrafici d ON c.ID_Cliente = d.IdCliente " +
                   "WHERE LOWER(d.Nome) LIKE LOWER(?) OR " +
                   "LOWER(d.Cognome) LIKE LOWER(?) OR " +
                   "LOWER(c.Username) LIKE LOWER(?) " +
                   "LIMIT 5";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + query.toLowerCase() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StringBuilder suggestion = new StringBuilder();
                    
                    String nome = rs.getString("Nome");
                    if (nome != null) {
                        suggestion.append(nome).append(" ");
                    }
                    
                    String cognome = rs.getString("Cognome");
                    if (cognome != null) {
                        suggestion.append(cognome).append(" ");
                    }
                    
                    String username = rs.getString("Username");
                    if (username != null) {
                        suggestion.append(username);
                    }          
                    suggestions.add(suggestion.toString().trim());
                }
            }
        } catch (SQLException e) {
            System.err.println("Errore durante la ricerca suggerimenti: " + e.getMessage());
            throw e;
        }
        
        return suggestions;
    }

    public ArrayList<ClienteBean> searchClients(String[] searchTerms) throws SQLException {
        ArrayList<ClienteBean> clients = new ArrayList<>();
        
        // Verifica che ci siano termini di ricerca validi
        if (searchTerms == null || searchTerms.length == 0) {
            return clients;
        }

        // Costruzione dinamica della query SQL
        String sql = "SELECT c.ID_Cliente, c.Username, c.Email, c.Amministratore, "
                   + "d.Nome, d.Cognome, d.CF, d.Telefono "
                   + "FROM Cliente c "
                   + "JOIN Dati_Anagrafici d ON c.ID_Cliente = d.IdCliente "
                   + "WHERE ";
        
        // Preparazione delle condizioni di ricerca
        List<String> conditions = new ArrayList<>();
        List<String> parameters = new ArrayList<>();
        
        for (String term : searchTerms) {
            if (term != null && !term.trim().isEmpty()) {
                String likeTerm = "%" + term.trim() + "%";
                conditions.add("(d.Nome LIKE ? OR d.Cognome LIKE ? OR c.Username LIKE ? OR c.Email LIKE ? OR d.CF LIKE ? OR d.Telefono LIKE ?)");
                
                // Aggiungi il termine per ogni campo di ricerca (6 volte)
                for (int i = 0; i < 6; i++) {
                    parameters.add(likeTerm);
                }
            }
        }
        
        // Se non ci sono termini validi, restituisci lista vuota
        if (conditions.isEmpty()) {
            return clients;
        }
        
        // Combina tutte le condizioni con OR
        sql += String.join(" OR ", conditions);
        sql += " LIMIT 10"; // Limita i risultati
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Imposta tutti i parametri
            for (int i = 0; i < parameters.size(); i++) {
                ps.setString(i + 1, parameters.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ClienteBean bean = new ClienteBean();
                    bean.setIdCliente(rs.getInt("ID_Cliente"));
                    bean.setUsername(rs.getString("Username"));
                    bean.setEmail(rs.getString("Email"));
                    bean.setIsAmministratore(rs.getBoolean("Amministratore"));
                    
                    // Popola i dati anagrafici
                    DatiAnagraficiBean anagrafica = new DatiAnagraficiBean();
                    anagrafica.setNome(rs.getString("Nome"));
                    anagrafica.setCognome(rs.getString("Cognome"));
                    anagrafica.setCf(rs.getString("CF"));
                    anagrafica.setTelefono(rs.getString("Telefono"));
                    bean.setAnagrafia(anagrafica);
                    
                    clients.add(bean);
                }
            }
        }
        return clients;
    }
}