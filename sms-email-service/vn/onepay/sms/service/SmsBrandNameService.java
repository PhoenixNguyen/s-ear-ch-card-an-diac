package vn.onepay.sms.service;

public interface SmsBrandNameService {
	String BEAN_NAME="smsBrandNameService";
	public boolean sendSMSMessage(String msisdn, String content);
	public boolean sendSMSMessageToMerchant(String msisdn, String content);
	public boolean sendSMSMessageToStaff(String msisdn, String content);
	public boolean sendSMSMessageToBizStaff(String msisdn, String content);
	public boolean sendSMSMessageToBizManager(String msisdn, String content);
	public boolean sendSMSMessageToBizSupporter(String msisdn, String content);
	public boolean sendSMSMessageToBizSupportManager(String msisdn, String content);
	public boolean sendSMSMessageToCustomerCare(String msisdn, String content);
	public boolean sendSMSMessageToCustomerCareManager(String msisdn, String content);
	public boolean sendSMSMessageToOperator(String msisdn, String content);
}
