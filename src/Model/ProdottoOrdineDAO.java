package Model;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class ProdottoOrdineDAO extends DAO<ProdottoOrdineBean> {

    public ProdottoOrdineDAO() {
        super();
    }

    @Override
    public void doSave(ProdottoOrdineBean prodottoOrdine) throws SQLException {
        String sql = "INSERT INTO ProdottoOrdine (Nome, Prezzo, Quantita, Iva) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, prodottoOrdine.getNome());
            stmt.setDouble(2, prodottoOrdine.getPrezzoBase());
            stmt.setInt(3, prodottoOrdine.getQuantita());
            stmt.setDouble(4, prodottoOrdine.getIva());
            stmt.setInt(5, prodottoOrdine.getIdOrdine());
            
            stmt.executeUpdate();
        }
    }

    @Override
    public void doUpdate(ProdottoOrdineBean item) throws SQLException {
        String sql = "UPDATE ProdottoOrdine SET Nome = ?, Prezzo = ?, Quantita = ?, Iva = ?, IdOrdine = ? WHERE ID_ProdottoOrdine = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, item.getNome());
            stmt.setDouble(2, item.getPrezzoBase());
            stmt.setInt(3, item.getQuantita());
            stmt.setDouble(4, item.getIva());
            stmt.setInt(5, item.getIdProdottoOrdine());
            stmt.setInt(6, item.getIdOrdine());

            stmt.executeUpdate();
        }
    }

    @Override
    public boolean doDelete(int id) throws SQLException {
        String sql = "DELETE FROM ProdottoOrdine WHERE ID_ProdottoOrdine = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            int result = stmt.executeUpdate();
            return result > 0;
        }
    }

    @Override
    public ProdottoOrdineBean doRetrieveByKey(int id) throws SQLException {
        String sql = "SELECT * FROM ProdottoOrdine WHERE ID_ProdottoOrdine = ?";
        ProdottoOrdineBean prodottoOrdine = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    prodottoOrdine = new ProdottoOrdineBean();
                    prodottoOrdine.setIdProdottoOrdine(id);
                    prodottoOrdine.setNome(rs.getString("Nome"));
                    prodottoOrdine.setPrezzoBase(rs.getDouble("Prezzo"));
                    prodottoOrdine.setQuantita(rs.getInt("Quantita"));
                    prodottoOrdine.setIva(rs.getDouble("Iva"));
                }
            }
        }
        return prodottoOrdine;
    }

    @Override
    public ArrayList<ProdottoOrdineBean> doRetrieveAll(String ordine) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM ProdottoOrdine");

        if (ordine != null && !ordine.trim().isEmpty()) {
            if (ordine.equals("Prezzo ASC")) {
                sql.append(" ORDER BY Prezzo ASC");
            } else if (ordine.equals("Prezzo DESC")) {
                sql.append(" ORDER BY Prezzo DESC");
            } else {
                sql.append(" ORDER BY Nome");
            }
        }

        ArrayList<ProdottoOrdineBean> listaProdottiOrdine = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString());
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                ProdottoOrdineBean prodottoOrdine = new ProdottoOrdineBean();
                prodottoOrdine.setIdProdottoOrdine(rs.getInt("ID_ProdottoOrdine"));
                prodottoOrdine.setNome(rs.getString("Nome"));
                prodottoOrdine.setPrezzoBase(rs.getDouble("Prezzo"));
                prodottoOrdine.setQuantita(rs.getInt("Quantita"));
                prodottoOrdine.setIva(rs.getDouble("Iva"));
                prodottoOrdine.setIdOrdine(rs.getInt("IdOrdine"));

                listaProdottiOrdine.add(prodottoOrdine);
            }
        }
        return listaProdottiOrdine;
    }

    public ArrayList<ProdottoOrdineBean> doRetrieveFiltered(String nomeFiltro, 
                                                          Double prezzoMin, Double prezzoMax, 
                                                          String ordine) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM ProdottoOrdine WHERE 1=1");
        List<Object> parameters = new ArrayList<>();

        if (nomeFiltro != null && !nomeFiltro.trim().isEmpty()) {
            sql.append(" AND Nome LIKE ?");
            parameters.add("%" + nomeFiltro + "%");
        }

        if (prezzoMin != null) {
            sql.append(" AND Prezzo_Base >= ?");
            parameters.add(prezzoMin);
        }

        if (prezzoMax != null) {
            sql.append(" AND Prezzo_Base <= ?");
            parameters.add(prezzoMax);
        }

        if (ordine != null && !ordine.trim().isEmpty()) {
            if (ordine.equals("Prezzo ASC")) {
                sql.append(" ORDER BY Prezzo ASC");
            } else if (ordine.equals("Prezzo DESC")) {
                sql.append(" ORDER BY Prezzo DESC");
            } else {
                sql.append(" ORDER BY Nome");
            }
        }

        ArrayList<ProdottoOrdineBean> listaProdottiOrdine = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Imposta i parametri
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProdottoOrdineBean prodottoOrdine = new ProdottoOrdineBean();
                    prodottoOrdine.setIdProdottoOrdine(rs.getInt("ID_ProdottoOrdine"));
                    prodottoOrdine.setNome(rs.getString("Nome"));
                    prodottoOrdine.setPrezzoBase(rs.getDouble("Prezzo"));
                    prodottoOrdine.setQuantita(rs.getInt("Quantita"));
                    prodottoOrdine.setIva(rs.getDouble("Iva"));
                    prodottoOrdine.setIdOrdine(rs.getInt("IdOrdine"));
                    
                    listaProdottiOrdine.add(prodottoOrdine);
                }
            }
        }
        return listaProdottiOrdine;
    }

    public List<String> getProductSuggestions(String query) throws SQLException {
        List<String> suggestions = new ArrayList<>();
        String sql = "SELECT Nome FROM ProdottoOrdine WHERE Nome LIKE ? LIMIT 5";
        
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

    public Collection<ProdottoOrdineBean> searchProducts(String query) throws SQLException {
        Collection<ProdottoOrdineBean> products = new ArrayList<>();
        String sql = "SELECT * FROM ProdottoOrdine WHERE Nome LIKE ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + query + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProdottoOrdineBean bean = new ProdottoOrdineBean();
                    bean.setIdProdottoOrdine(rs.getInt("ID_ProdottoOrdine"));
                    bean.setNome(rs.getString("Nome"));
                    bean.setPrezzoBase(rs.getDouble("Prezzo"));
                    bean.setQuantita(rs.getInt("Quantita"));
                    bean.setIva(rs.getDouble("Iva"));
                    bean.setIdOrdine(rs.getInt("IdOrdine"));
                    
                    products.add(bean);
                }
            }
        }
        return products;
    }
}