package Model;

import java.io.Serializable;

public class CartaCreditoBean implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	private String nome;
	private String cognome;
	private int idCliente;
	private String numeroCarta;
	private String scadenza;
	private String cvv;
	
	public CartaCreditoBean() {
		
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getCognome() {
		return cognome;
	}

	public void setCognome(String cognome) {
		this.cognome = cognome;
	}

	public int getIdCliente() {
		return idCliente;
	}

	public void setIdCliente(int idCliente) {
		this.idCliente = idCliente;
	}

	public String getNumeroCarta() {
		return numeroCarta;
	}

	public void setNumeroCarta(String numeroCarta) {
		this.numeroCarta = numeroCarta;
	}

	public String getScadenza() {
		return scadenza;
	}

	public void setScadenza(String scadenza) {
		this.scadenza = scadenza;
	}

	public String getCvv() {
		return cvv;
	}

	public void setCvv(String cvv) {
		this.cvv = cvv;
	}
	
	@Override
	public String toString() {
		return "Id: " + this.idCliente + "\tNome: " + this.nome + "\tCognome: " + this.cognome + "\tNumero Carta: " + this.numeroCarta + "\tScadenza: " + this.scadenza + "\tCVV: " + this.cvv + "\n";
	}
	
	@Override
	public boolean equals(Object obj) {
	    if (this == obj) return true;
	    if (obj == null || getClass() != obj.getClass()) return false;

	    CartaCreditoBean that = (CartaCreditoBean) obj;

	    return idCliente == that.idCliente &&
	           (nome != null ? nome.equals(that.nome) : that.nome == null) &&
	           (cognome != null ? cognome.equals(that.cognome) : that.cognome == null) &&
	           (numeroCarta != null ? numeroCarta.equals(that.numeroCarta) : that.numeroCarta == null) &&
	           (scadenza != null ? scadenza.equals(that.scadenza) : that.scadenza == null) &&
	           (cvv != null ? cvv.equals(that.cvv) : that.cvv == null);
	}
	
}
