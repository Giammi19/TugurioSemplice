package Model;

import java.io.Serializable;

public class ProdottoOrdineBean implements Serializable {

	private static final long serialVersionUID = 1L;
	
		    private int idProdottoOrdine;  
		    private String nome; 
		    private double prezzoBase;
		    private double iva;
		    private int quantita;
		    private int idOrdine;

		    public ProdottoOrdineBean(){
		    	
		    }

	public int getIdProdottoOrdine() { return this.idProdottoOrdine;}
	public void setIdProdottoOrdine(int idProdotto) { this.idProdottoOrdine = idProdotto;}
	public String getNome() { return this.nome;}
	public void setNome(String nome) { this.nome = nome;}
	public void setPrezzoBase(double prezzoBase) { this.prezzoBase = prezzoBase;}	
	public double getPrezzoBase() { return this.prezzoBase;}
	public void setIva(double iva) { this.iva = iva;}
	public double getIva() { return this.iva;}
	public void setQuantita(int quantita) { this.quantita = quantita;}
	public int getQuantita() { return this.quantita;}
	public int getIdOrdine() { return this.idOrdine;}
	public void setIdOrdine(int idOrdine) { this.idOrdine = idOrdine;}

	@Override
	public String toString() {
		return "Id: " + this.idProdottoOrdine + "\tNome: " + this.nome + "\t Prezzo base: " + this.prezzoBase + "\n";
	}

}
