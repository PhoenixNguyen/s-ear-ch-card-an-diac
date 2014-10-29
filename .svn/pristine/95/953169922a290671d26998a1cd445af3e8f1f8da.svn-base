package vn.onepay.sms.model;

import java.io.Serializable;
import java.util.Date;

import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.TypeAlias;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;
@Document(collection = "SmsBrand")
@TypeAlias("smsBrand")
public class SmsBrand implements Serializable{
	@Id
	private String id;
	@Indexed
	private String msisdn;
	private String message;
	@Indexed
	@DateTimeFormat(iso=ISO.DATE_TIME)
	private Date created_time = new Date();
	
	public void setId(String id) {
		this.id = id;
	}
	public String getId() {
		return this.id;
	}
	public String getMsisdn() {
		return this.msisdn;
	}
	public void setMsisdn(String msisdn) {
		this.msisdn = msisdn;
	}
	public String getMessage() {
		return this.message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public java.util.Date getCreated_time() {
		return this.created_time;
	}
	public void setCreated_time(java.util.Date created_time) {
		this.created_time = created_time;
	}
}
