package Model;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public abstract class DAO<T> {
    
    private static DataSource ds;
    
    static {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            ds = (DataSource) envCtx.lookup("jdbc/Tugurio");
        } catch (NamingException e) {
            throw new RuntimeException("DataSource initialization failed", e);
        }
    }
    
    
    protected Connection getConnection() throws SQLException {
        return ds.getConnection();
    }
    
    public abstract void doSave(T item) throws SQLException;
    public abstract boolean doDelete(int id) throws SQLException;
    public abstract void doUpdate(T item) throws SQLException;
    public abstract T doRetrieveByKey(int id) throws SQLException;
    public abstract ArrayList<T> doRetrieveAll(String ordine) throws SQLException;
 
}