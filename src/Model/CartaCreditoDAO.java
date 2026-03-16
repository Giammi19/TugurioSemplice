package Model;

import java.sql.*;
import java.util.ArrayList;

public class CartaCreditoDAO extends DAO<CartaCreditoBean> {
    
    public CartaCreditoDAO() {
        super();
    }
    
    @Override
    public void doSave(CartaCreditoBean cartaCredito) throws SQLException {
        String sql = "INSERT INTO Carta_Credito (IdCliente, Nome, Cognome, NumeroCarta, DataScadenza, CVV) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cartaCredito.getIdCliente());
            stmt.setString(2, cartaCredito.getNome());
            stmt.setString(3, cartaCredito.getCognome());
            stmt.setString(4, cartaCredito.getNumeroCarta());
            stmt.setString(5, cartaCredito.getScadenza());
            stmt.setString(6, cartaCredito.getCvv());
            
            stmt.executeUpdate();
        }
    }
    
    @Override
    public boolean doDelete(int idCliente) throws SQLException {
        String sql = "DELETE FROM Carta_Credito WHERE IdCliente = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idCliente);
            int result = stmt.executeUpdate();
            
            return result > 0;
        }
    }
    
    @Override
    public void doUpdate(CartaCreditoBean cartaCredito) throws SQLException {
        String sql = "UPDATE Carta_Credito " +
                     "SET Nome = ?, " +
                     "    Cognome = ?, " +
                     "    NumeroCarta = ?, " +
                     "    DataScadenza = ?, " +
                     "    CVV = ? " +
                     "WHERE IdCliente = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, cartaCredito.getNome());
            stmt.setString(2, cartaCredito.getCognome());
            stmt.setString(3, cartaCredito.getNumeroCarta());
            stmt.setString(4, cartaCredito.getScadenza());
            stmt.setString(5, cartaCredito.getCvv());
            stmt.setInt(6, cartaCredito.getIdCliente());
            
            stmt.executeUpdate();
        }
    }
    
    @Override
    public CartaCreditoBean doRetrieveByKey(int IdCliente) throws SQLException {
        String sql = "SELECT * FROM Carta_Credito WHERE IdCliente = ?";
        CartaCreditoBean cartaCredito = null;
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, IdCliente);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    cartaCredito = new CartaCreditoBean();
                    cartaCredito.setCognome(rs.getString("Cognome"));
                    cartaCredito.setNome(rs.getString("Nome"));
                    cartaCredito.setIdCliente(rs.getInt("IdCliente"));
                    cartaCredito.setNumeroCarta(rs.getString("NumeroCarta"));
                    cartaCredito.setScadenza(rs.getString("DataScadenza"));
                    cartaCredito.setCvv(rs.getString("CVV")); // Correzione: ora legge il CVV dal resultset
                }
            }
        }
        return cartaCredito;
    }
    
    @Override
    public ArrayList<CartaCreditoBean> doRetrieveAll(String ordine) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM Carta_Credito");
        
        if (ordine != null && !ordine.isEmpty()) {
            sql.append(" ORDER BY ").append(ordine);
        }
        
        ArrayList<CartaCreditoBean> carteCredito = new ArrayList<>();
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString());
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                CartaCreditoBean cartaCredito = new CartaCreditoBean();
                cartaCredito.setCognome(rs.getString("Cognome"));
                cartaCredito.setNome(rs.getString("Nome"));
                cartaCredito.setIdCliente(rs.getInt("IdCliente"));
                cartaCredito.setNumeroCarta(rs.getString("NumeroCarta"));
                cartaCredito.setScadenza(rs.getString("DataScadenza"));
                cartaCredito.setCvv(rs.getString("CVV")); // Correzione: ora legge il CVV dal resultset
                
                carteCredito.add(cartaCredito);
            }
        }
        return carteCredito;
    }
}