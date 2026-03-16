package Model;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class OrdineDAO extends DAO<OrdineBean> {

    public OrdineDAO() {
        super();
    }

    @Override
    public void doSave(OrdineBean ordine) throws SQLException {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);  // Inizia transazione
            
            try {
                // Inserimento ordine principale
                String sql = "INSERT INTO Ordine (IdCliente, Prezzo_Ordine, Stato_Ordine) VALUES (?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    stmt.setInt(1, ordine.getIdCliente());
                    stmt.setDouble(2, ordine.getPrezzoOrdine());
                    stmt.setString(3, ordine.getStatoOrdine());
                    stmt.executeUpdate();

                    try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            int orderId = generatedKeys.getInt(1);
                            
                            // Inserisci prodotti associati
                            insertProducts(conn, orderId, ordine.getProdotti());
                            
                            // Inserisci pagamento se presente
                            if (ordine.getPagamento() != null) {
                                insertPayment(conn, orderId, ordine.getPagamento());
                            }
                            
                            // Inserisci spedizione se presente
                            if (ordine.getSpedizione() != null) {
                                insertShipping(conn, orderId, ordine.getSpedizione());
                            }
                        }
                    }
                }
                conn.commit();  // Commit della transazione
            } catch (SQLException e) {
                conn.rollback();  // Rollback in caso di errore
                throw e;
            } finally {
                conn.setAutoCommit(true);  // Ripristina auto-commit
            }
        }
    }

    private void insertProducts(Connection conn, int orderId, ArrayList<ProdottoOrdineBean> products) 
            throws SQLException {
        // SQL per inserire in ProdottoOrdine
        String sqlPo = "INSERT INTO ProdottoOrdine(Nome, Prezzo, Quantita, Iva, idOrdine) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmtPo = conn.prepareStatement(sqlPo, Statement.RETURN_GENERATED_KEYS);) {
            
            for (ProdottoOrdineBean product : products) {                
            	// 1. Inserisci in ProdottoOrdine
            	stmtPo.setString(1, product.getNome());
                stmtPo.setDouble(2, product.getPrezzoBase());
                stmtPo.setInt(3, product.getQuantita());
                stmtPo.setDouble(4, product.getIva());
                stmtPo.setInt(5, orderId);
                stmtPo.executeUpdate();
            }
        }
    }
    
    private void insertPayment(Connection conn, int orderId, PagamentoBean payment) 
            throws SQLException {
        String sql = "INSERT INTO Pagamento (ID_Ordine, Data_Pagamento, Importo, Metodo) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.setObject(2, payment.getDataPagamento());
            stmt.setDouble(3, payment.getImporto());
            stmt.setString(4, payment.getMetodo());
            stmt.executeUpdate();
        }
    }
    
    private void insertShipping(Connection conn, int orderId, SpedizioneBean shipping) 
            throws SQLException {
        String sql = "INSERT INTO Spedizione (ID_Ordine, Spese, Data_Consegna, Metodo) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.setDouble(2, shipping.getSpese());
            stmt.setObject(3, shipping.getDataConsegna());
            stmt.setString(4, shipping.getMetodo());
            stmt.executeUpdate();
        }
    }

    @Override
    public void doUpdate(OrdineBean item) throws SQLException {
        String sql = "UPDATE ordine SET Data_Ordine = ?, Prezzo_Ordine = ?, Stato_Ordine = ? WHERE ID_Ordine = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, item.getDataOrdine());
            stmt.setDouble(2, item.getPrezzoOrdine());
            stmt.setString(3, item.getStatoOrdine());
            stmt.setInt(4, item.getIdOrdine());
            stmt.executeUpdate();
        }
    }

    @Override
    public boolean doDelete(int id) throws SQLException {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);  // Inizia transazione
            
            try {
                // Elimina record correlati
                deleteFromTable(conn, "DELETE FROM inserito WHERE IdOrdine = ?", id);
                deleteFromTable(conn, "DELETE FROM pagamento WHERE ID_Ordine = ?", id);
                deleteFromTable(conn, "DELETE FROM spedizione WHERE ID_Ordine = ?", id);
                
                // Elimina ordine principale
                int result = deleteFromTable(conn, "DELETE FROM ordine WHERE ID_Ordine = ?", id);
                
                conn.commit();  // Commit della transazione
                return result > 0;
            } catch (SQLException e) {
                conn.rollback();  // Rollback in caso di errore
                throw e;
            } finally {
                conn.setAutoCommit(true);  // Ripristina auto-commit
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
    public OrdineBean doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM ordine WHERE ID_Ordine = ?";
        OrdineBean ordine = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ordine = new OrdineBean();
                    ordine.setIdOrdine(rs.getInt("ID_Ordine"));
                    ordine.setIdCliente(rs.getInt("IdCliente"));
                    ordine.setDataOrdine(rs.getString("Data_Ordine"));
                    ordine.setPrezzoOrdine(rs.getDouble("Prezzo_Ordine"));
                    ordine.setStatoOrdine(rs.getString("Stato_Ordine"));
                    
                    // Recupera entità collegate
                    ordine.setProdotti(retrieveOrderProducts(conn, id));
                    ordine.setPagamento(retrievePayment(id));
                    ordine.setSpedizione(retrieveShipping(id));
                }
            }
        }
        return ordine;
    }
    
    private ArrayList<ProdottoOrdineBean> retrieveOrderProducts(Connection conn, int orderId) 
            throws SQLException {
        String sql = "SELECT po.* FROM ProdottoOrdine po " +
                    "WHERE po.IdOrdine = ?";
        
        ArrayList<ProdottoOrdineBean> products = new ArrayList<>();
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProdottoOrdineBean prodotto = new ProdottoOrdineBean();
                    prodotto.setIdProdottoOrdine(rs.getInt("ID_ProdottoOrdine"));
                    prodotto.setPrezzoBase(rs.getDouble("Prezzo"));
                    prodotto.setQuantita(rs.getInt("Quantita"));
                    prodotto.setIva(rs.getDouble("Iva"));
                    prodotto.setIdOrdine(rs.getInt("IdOrdine"));
                    prodotto.setNome(rs.getString("Nome"));
                    
                    products.add(prodotto);
                }
            }
        }
        return products;
    }
    
    public PagamentoBean retrievePayment(int orderId) throws SQLException {
        String sql = "SELECT * FROM pagamento WHERE ID_Ordine = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    PagamentoBean pagamento = new PagamentoBean();
                    pagamento.setIdOrdine(rs.getInt("ID_Ordine"));
                    pagamento.setImporto(rs.getDouble("Importo"));
                    pagamento.setDataPagamento(rs.getDate("Data_Pagamento"));
                    pagamento.setMetodo(rs.getString("Metodo"));
                    
                    return pagamento;
                }
            }
        }
        return null;
    }

    public SpedizioneBean retrieveShipping(int orderId) throws SQLException {
        String sql = "SELECT * FROM spedizione WHERE ID_Ordine = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    SpedizioneBean spedizione = new SpedizioneBean();
                    spedizione.setIdOrdine(rs.getInt("ID_Ordine"));
                    spedizione.setSpese(rs.getDouble("Spese"));
                    spedizione.setDataConsegna(rs.getDate("Data_Consegna"));
                    spedizione.setMetodo(rs.getString("Metodo"));
                    
                    return spedizione;
                }
            }
        }
        return null;
    }

    @Override
    public ArrayList<OrdineBean> doRetrieveAll(String ordine) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM ordine");
        
        if (ordine != null && !ordine.trim().isEmpty()) {
            switch (ordine) {
                case "Data_Ordine": sql.append(" ORDER BY Data_Ordine"); break;
                case "Prezzo_Ordine ASC": sql.append(" ORDER BY Prezzo_Ordine ASC"); break;
                case "Prezzo_Ordine DESC": sql.append(" ORDER BY Prezzo_Ordine DESC"); break;
                default: sql.append(" ORDER BY ID_Ordine DESC");
            }
        } else {
            sql.append(" ORDER BY ID_Ordine DESC");
        }

        ArrayList<OrdineBean> listaOrdini = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString());
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                OrdineBean ordineb = new OrdineBean();
                ordineb.setIdOrdine(rs.getInt("ID_Ordine"));
                ordineb.setIdCliente(rs.getInt("IdCliente"));
                ordineb.setDataOrdine(rs.getString("Data_Ordine"));
                ordineb.setPrezzoOrdine(rs.getDouble("Prezzo_Ordine"));
                ordineb.setStatoOrdine(rs.getString("Stato_Ordine"));
                
                listaOrdini.add(ordineb);
            }
        }
        return listaOrdini;
    }

    public ArrayList<OrdineBean> doRetrieveByCliente(int idCliente) throws SQLException {
        String sql = "SELECT * FROM ordine WHERE IdCliente = ? ORDER BY Data_Ordine DESC";
        ArrayList<OrdineBean> listaOrdini = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idCliente);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrdineBean ordine = new OrdineBean();
                    ordine.setIdOrdine(rs.getInt("ID_Ordine"));
                    ordine.setIdCliente(idCliente);
                    ordine.setDataOrdine(rs.getString("Data_Ordine"));
                    ordine.setPrezzoOrdine(rs.getDouble("Prezzo_Ordine"));
                    ordine.setStatoOrdine(rs.getString("Stato_Ordine"));
                    
                    listaOrdini.add(ordine);
                }
            }
        }
        return listaOrdini;
    }
    public ArrayList<OrdineBean> doRetrieveByDate(int idCliente, String dataInizio, String dataFine) throws SQLException {
        // Query base
        String sql = "SELECT * FROM ordine WHERE IdCliente = ?";
        
        // Aggiunta condizioni per le date se specificate
        if (dataInizio != null && !dataInizio.isEmpty()) {
            sql += " AND Data_Ordine >= ?";
        }
        if (dataFine != null && !dataFine.isEmpty()) {
            sql += " AND Data_Ordine <= ?";
        }
        
        sql += " ORDER BY Data_Ordine DESC";
        
        ArrayList<OrdineBean> listaOrdini = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            stmt.setInt(paramIndex++, idCliente);
            
            // Imposta i parametri per le date se specificate
            if (dataInizio != null && !dataInizio.isEmpty()) {
                stmt.setString(paramIndex++, dataInizio);
            }
            if (dataFine != null && !dataFine.isEmpty()) {
                stmt.setString(paramIndex++, dataFine + " 23:59:59"); // Per includere tutto il giorno finale
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrdineBean ordine = new OrdineBean();
                    ordine.setIdOrdine(rs.getInt("ID_Ordine"));
                    ordine.setIdCliente(idCliente);
                    ordine.setDataOrdine(rs.getString("Data_Ordine"));
                    ordine.setPrezzoOrdine(rs.getDouble("Prezzo_Ordine"));
                    ordine.setStatoOrdine(rs.getString("Stato_Ordine"));
                    
                    listaOrdini.add(ordine);
                }
            }
        }
        return listaOrdini;
    }
    
    public ArrayList<OrdineBean> doRetrieveFiltered(String statoFiltro, String dataInizioFiltro, 
                                                   String dataFineFiltro, Double prezzoMin, 
                                                   Double prezzoMax, Integer idClienteFiltro, 
                                                   String ordine) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM ordine WHERE 1=1");
        ArrayList<Object> parameters = new ArrayList<>();

        // Costruzione query dinamica
        if (statoFiltro != null && !statoFiltro.trim().isEmpty()) {
            sql.append(" AND Stato_Ordine = ?");
            parameters.add(statoFiltro);
        }

        if (dataInizioFiltro != null && !dataInizioFiltro.trim().isEmpty()) {
            sql.append(" AND Data_Ordine >= ?");
            parameters.add(dataInizioFiltro);
        }

        if (dataFineFiltro != null && !dataFineFiltro.trim().isEmpty()) {
            sql.append(" AND Data_Ordine <= ?");
            parameters.add(dataFineFiltro);
        }

        if (prezzoMin != null) {
            sql.append(" AND Prezzo_Ordine >= ?");
            parameters.add(prezzoMin);
        }

        if (prezzoMax != null) {
            sql.append(" AND Prezzo_Ordine <= ?");
            parameters.add(prezzoMax);
        }
        
        if (idClienteFiltro != null) {
            sql.append(" AND IdCliente = ?");
            parameters.add(idClienteFiltro);
        }

        // Ordinamento
        if (ordine != null && !ordine.trim().isEmpty()) {
            switch (ordine) {
                case "Data_Ordine ASC": sql.append(" ORDER BY Data_Ordine ASC"); break;
                case "Data_Ordine DESC": sql.append(" ORDER BY Data_Ordine DESC"); break;
                case "Prezzo_Ordine ASC": sql.append(" ORDER BY Prezzo_Ordine ASC"); break;
                case "Prezzo_Ordine DESC": sql.append(" ORDER BY Prezzo_Ordine DESC"); break;
                default: sql.append(" ORDER BY ID_Ordine DESC");
            }
        } else {
            sql.append(" ORDER BY ID_Ordine DESC");
        }

        ArrayList<OrdineBean> listaOrdini = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Imposta parametri
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrdineBean ordineb = new OrdineBean();
                    ordineb.setIdOrdine(rs.getInt("ID_Ordine"));
                    ordineb.setIdCliente(rs.getInt("IdCliente"));
                    ordineb.setDataOrdine(rs.getString("Data_Ordine"));
                    ordineb.setPrezzoOrdine(rs.getDouble("Prezzo_Ordine"));
                    ordineb.setStatoOrdine(rs.getString("Stato_Ordine"));
                    
                    listaOrdini.add(ordineb);
                }
            }
        }
        return listaOrdini;
    }
    
    public ArrayList<Map<String, Object>> getDettagliOrdine(int idOrdine) throws SQLException {
        ArrayList<Map<String, Object>> dettagli = new ArrayList<>();
        String query = "SELECT i.Nome, i.Quantita, i.prezzo " +
                       "FROM ProdottoOrdine i " +
                       "WHERE i.IdOrdine = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, idOrdine);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> dettaglio = new HashMap<>();
                    dettaglio.put("nomeProdotto", rs.getString("Nome"));
                    dettaglio.put("quantita", rs.getInt("Quantita"));
                    dettaglio.put("prezzo", rs.getDouble("Prezzo"));
                    dettagli.add(dettaglio);
                }
            }
        }
        return dettagli;
    }
}