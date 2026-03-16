package Model;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class ProdottoDAO extends DAO<ProdottoBean> {

    public ProdottoDAO() {
        super();
    }

    @Override
    public void doSave(ProdottoBean prodotto) throws SQLException {
        String sql = "INSERT INTO prodotto (Nome, Descrizione, Quantita, Disponibilita, Prezzo_Base, Iva, Immagine) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, prodotto.getNome());
            stmt.setString(2, prodotto.getDescrizione());
            stmt.setInt(3, prodotto.getQuantita());
            stmt.setBoolean(4, prodotto.getDisponibilita());
            stmt.setDouble(5, prodotto.getPrezzoBase());
            stmt.setDouble(6, prodotto.getIva());
            stmt.setString(7, prodotto.getImmagine());

            stmt.executeUpdate();
        }
    }

    @Override
    public void doUpdate(ProdottoBean item) throws SQLException {
        String sql = "UPDATE prodotto SET Nome = ?, Descrizione = ?, Quantita = ?, Disponibilita = ?, Prezzo_Base = ?, Iva = ?, Immagine = ? WHERE ID_Prodotto = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, item.getNome());
            stmt.setString(2, item.getDescrizione());
            stmt.setInt(3, item.getQuantita());
            stmt.setBoolean(4, item.getDisponibilita());
            stmt.setDouble(5, item.getPrezzoBase());
            stmt.setDouble(6, item.getIva());
            stmt.setString(7, item.getImmagine());
            stmt.setInt(8, item.getIdProdotto());

            stmt.executeUpdate();
        }
    }

    @Override
    public boolean doDelete(int id) throws SQLException {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                String sql1 = "DELETE FROM acquista WHERE IdProdotto = ?";
                try (PreparedStatement stmt1 = conn.prepareStatement(sql1)) {
                    stmt1.setInt(1, id);
                    stmt1.executeUpdate();
                }
                
                String sql2 = "DELETE FROM prodotto WHERE ID_Prodotto = ?";
                try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                    stmt2.setInt(1, id);
                    int result = stmt2.executeUpdate();        
                    conn.commit();
                    return result > 0;
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    @Override
    public ProdottoBean doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM prodotto WHERE ID_Prodotto = ?";
        ProdottoBean prodotto = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    prodotto = new ProdottoBean();
                    prodotto.setIdProdotto(id);
                    prodotto.setNome(rs.getString("Nome"));
                    prodotto.setDescrizione(rs.getString("Descrizione"));
                    prodotto.setQuantita(rs.getInt("Quantita"));
                    prodotto.setDisponibilita(rs.getBoolean("Disponibilita"));
                    prodotto.setPrezzoBase(rs.getDouble("Prezzo_Base"));
                    prodotto.setIva(rs.getDouble("Iva"));
                    prodotto.setImmagine(rs.getString("Immagine"));
                }
            }
        }
        return prodotto;
    }

    @Override
    public ArrayList<ProdottoBean> doRetrieveAll(String ordine) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM prodotto");

        if (ordine != null && !ordine.trim().isEmpty()) {
            if (ordine.equals("Prezzo_Base ASC")) {
                sql.append(" ORDER BY Prezzo_Base ASC");
            } else if (ordine.equals("Prezzo_Base DESC")) {
                sql.append(" ORDER BY Prezzo_Base DESC");
            } else {
                sql.append(" ORDER BY Nome");
            }
        }

        ArrayList<ProdottoBean> listaProdotti = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString());
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                ProdottoBean prodotto = new ProdottoBean();
                prodotto.setIdProdotto(rs.getInt("ID_Prodotto"));
                prodotto.setNome(rs.getString("Nome"));
                prodotto.setDescrizione(rs.getString("Descrizione"));
                prodotto.setQuantita(rs.getInt("Quantita"));
                prodotto.setDisponibilita(rs.getBoolean("Disponibilita"));
                prodotto.setPrezzoBase(rs.getDouble("Prezzo_Base"));
                prodotto.setIva(rs.getDouble("Iva"));
                prodotto.setImmagine(rs.getString("Immagine"));

                listaProdotti.add(prodotto);
            }
        }
        return listaProdotti;
    }

    public ArrayList<ProdottoBean> doRetrieveFiltered(String ordine) 
                                                     throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM prodotto WHERE 1=1");

        if (ordine != null && !ordine.trim().isEmpty()) {
            if (ordine.equals("Prezzo_Base ASC")) {
                sql.append(" ORDER BY Prezzo_Base ASC");
            } else if (ordine.equals("Prezzo_Base DESC")) {
                sql.append(" ORDER BY Prezzo_Base DESC");
            } else {
                sql.append(" ORDER BY Nome");
            }
        }

        ArrayList<ProdottoBean> listaProdotti = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProdottoBean prodotto = new ProdottoBean();
                    prodotto.setIdProdotto(rs.getInt("ID_Prodotto"));
                    prodotto.setNome(rs.getString("Nome"));
                    prodotto.setDescrizione(rs.getString("Descrizione"));
                    prodotto.setQuantita(rs.getInt("Quantita"));
                    prodotto.setDisponibilita(rs.getBoolean("Disponibilita"));
                    prodotto.setPrezzoBase(rs.getDouble("Prezzo_Base"));
                    prodotto.setIva(rs.getDouble("Iva"));
                    prodotto.setImmagine(rs.getString("Immagine"));
                    
                    listaProdotti.add(prodotto);
                }
            }
        }
        return listaProdotti;
    }

    public List<String> getProductSuggestions(String query) throws SQLException {
        List<String> suggestions = new ArrayList<>();
        String sql = "SELECT Nome FROM Prodotto WHERE Nome LIKE ? AND Disponibilita = 1 LIMIT 5";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + query + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    suggestions.add(rs.getString("Nome"));
                }
            }
        }
        return suggestions;
    }

    public Collection<ProdottoBean> searchProducts(String query) throws SQLException {
        Collection<ProdottoBean> products = new ArrayList<>();
        String sql = "SELECT * FROM Prodotto WHERE Nome LIKE ? AND Disponibilita = 1";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + query + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProdottoBean bean = new ProdottoBean();
                    bean.setIdProdotto(rs.getInt("ID_Prodotto"));
                    bean.setNome(rs.getString("Nome"));
                    bean.setPrezzoBase(rs.getDouble("Prezzo_Base"));
                    bean.setImmagine(rs.getString("Immagine"));
                    bean.setQuantita(rs.getInt("Quantita"));
                    bean.setDisponibilita(rs.getBoolean("Disponibilita"));
                    bean.setDescrizione(rs.getString("Descrizione"));
                    bean.setIva(rs.getDouble("Iva"));
                    
                    products.add(bean);
                }
            }
        }
        return products;
    }
}