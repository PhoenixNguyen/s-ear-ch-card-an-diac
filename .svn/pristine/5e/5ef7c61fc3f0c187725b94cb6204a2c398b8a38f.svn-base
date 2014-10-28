package vn.onepay.mo.model;

import java.io.Serializable;
import java.util.Date;

import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.TypeAlias;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

import vn.onepay.common.SharedConstants;
@Document(collection = "IACGateway.MO")
@TypeAlias("iacMO")
public class MO implements Serializable{
	@Id
	private String id;
	@Indexed(unique=true, dropDups = true)
	private String request_id;
	private String cp_code;
	@Indexed
	private String telco;
	private String msisdn;
	private int amount=0;
	private String message;// CPCode_GameCode_ContentID_Accounts_ThongTinKhac
	private String game_code;
	private String content_id;
	private String account;
	private String error_code;
	private String error_message;
	//-------------
	private String mo_message;
	private String mt_message;
	
	@Indexed
	@DateTimeFormat(iso=ISO.DATE_TIME)
	private Date request_time = new Date();
	@DateTimeFormat(iso=ISO.DATE_TIME)
	private Date response_time;
	@Indexed
	boolean export_cdr_status = false;//true: đã xuất cdr; false: chưa xuất cdr;
	
	private String api_request;
	private String api_response;
	
	
	
	public String getId() {
		return this.id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	public String getRequest_id() {
		return this.request_id;
	}
	public void setRequest_id(String request_id) {
		this.request_id = request_id;
	}
	
	public String getCp_code() {
		return this.cp_code;
	}
	public void setCp_code(String cp_code) {
		this.cp_code = cp_code;
	}
	
	public String getTelco() {
		return this.telco;
	}
	public void setTelco(String telco) {
		this.telco = telco;
	}
	
	public String getMsisdn() {
		return this.msisdn;
	}
	
	public void setMsisdn(String msisdn) {
		this.msisdn = msisdn;
	}
	
	public int getAmount() {
		return this.amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}

	public String getMessage() {
		return this.message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	public String getGame_code() {
		return this.game_code;
	}
	public void setGame_code(String game_code) {
		this.game_code = game_code;
	}
	
	public String getContent_id() {
		return this.content_id;
	}
	public void setContent_id(String content_id) {
		this.content_id = content_id;
	}
	
	public String getAccount() {
		return this.account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	
	public String getError_code() {
		return this.error_code;
	}
	public void setError_code(String error_code) {
		this.error_code = error_code;
	}
	
	public String getError_message() {
		return this.error_message;
	}
	public void setError_message(String error_message) {
		this.error_message = error_message;
	}
	
	//-------------
	public String getMo_message() {
		return this.mo_message;
	}
	public void setMo_message(String mo_message) {
		this.mo_message = mo_message;
	}
	
	public String getMt_message() {
		return this.mt_message;
	}
	public void setMt_message(String mt_message) {
		this.mt_message = mt_message;
	}
	
	public Date getRequest_time() {
		return this.request_time;
	}
	public void setRequest_time(Date request_time) {
		this.request_time = request_time;
	}
	
	public Date getResponse_time() {
		return this.response_time;
	}
	public void setResponse_time(Date response_time) {
		this.response_time = response_time;
	}
	
	public boolean isExport_cdr_status() {
	    return this.export_cdr_status;
	}
	
	public void setExport_cdr_status(boolean export_cdr_status) {
	    this.export_cdr_status = export_cdr_status;
	}
	
	public String getApi_request() {
		return this.api_request;
	}
	public void setApi_request(String api_request) {
		this.api_request = api_request;
	}
	
	public String getApi_response() {
		return this.api_response;
	}
	public void setApi_response(String api_response) {
		this.api_response = api_response;
	}
}
