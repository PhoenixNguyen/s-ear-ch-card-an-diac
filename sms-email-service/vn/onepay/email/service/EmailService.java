package vn.onepay.email.service;

import java.util.Date;
import java.util.List;

import javax.mail.Message;

import vn.onepay.email.model.Email;

public interface EmailService {
	String BEAN_NAME="emailService";
	void sendEmail(Email emailObj);
	void sendEmail(String from, String replyTo, String to, String cc, String bcc, String subject, String body);
	void sendEmail(String from, String replyTo, String to, String cc, String bcc, String subject, String body, String attachments);
	
	void sendEmail(String from, String replyTo, List<String> to, List<String> cc, List<String> bcc, String subject, String body);
	void sendEmail(String from, String replyTo, List<String> to, List<String> cc, List<String> bcc, String subject, String body, String attachments);
	
	List<Message> readMail(String mailProtocol, String mailServer, String mailAccount, String password, Date fromTime, Date toTime);
}
