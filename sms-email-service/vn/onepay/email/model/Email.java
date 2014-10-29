package vn.onepay.email.model;

import java.io.Serializable;
import java.util.Date;

import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.TypeAlias;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

@Document(collection = "MyEmail")
@TypeAlias("myEmail")
public class Email implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2675500708324726561L;
	@Id
	String id;
	@Indexed
	String from;
	@Indexed
	String replyTo;
	@Indexed
	String to;
	@Indexed
	String cc;
	@Indexed
	String bcc;
	String subject;
	String body;
	String attachments;
	@Indexed
	@DateTimeFormat(iso=ISO.DATE_TIME)
	private Date created_time = new Date();
	
	public String getId() {
		return this.id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFrom() {
		return this.from;
	}
	public void setFrom(String from) {
		this.from = from;
	}
	public String getTo() {
		return this.to;
	}
	public void setTo(String to) {
		this.to = to;
	}
	public String getReplyTo() {
		return this.replyTo;
	}
	public void setReplyTo(String replyTo) {
		this.replyTo = replyTo;
	}
	public String getCc() {
		return this.cc;
	}
	public void setCc(String cc) {
		this.cc = cc;
	}
	public String getBcc() {
		return this.bcc;
	}
	public void setBcc(String bcc) {
		this.bcc = bcc;
	}
	public String getSubject() {
		return this.subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getBody() {
		return this.body;
	}
	public void setBody(String body) {
		this.body = body;
	}
	public String getAttachments() {
		return this.attachments;
	}
	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}
	public java.util.Date getCreated_time() {
		return this.created_time;
	}
	public void setCreated_time(java.util.Date created_time) {
		this.created_time = created_time;
	}
}
