package vn.onepay.search.entities;

public class FilteringMO {
	private String msisdn;
	private String merchant;
	private int count_sms;
	private int count_msisdn;
	private int amount;
	
	public FilteringMO(String msisdn, String merchant, int count_sms, int count_msisdn, int amount) {
		super();
		this.msisdn = msisdn;
		this.merchant = merchant;
		this.count_sms = count_sms;
		this.count_msisdn = count_msisdn;
		this.amount = amount;
	}
	
	public String getMsisdn() {
		return msisdn;
	}
	public void setMsisdn(String msisdn) {
		this.msisdn = msisdn;
	}
	public String getMerchant() {
		return merchant;
	}
	public void setMerchant(String merchant) {
		this.merchant = merchant;
	}
	public int getCount_sms() {
		return count_sms;
	}
	public void setCount_sms(int count_sms) {
		this.count_sms = count_sms;
	}
	public int getCount_msisdn() {
		return count_msisdn;
	}
	public void setCount_msisdn(int count_msisdn) {
		this.count_msisdn = count_msisdn;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	
}
