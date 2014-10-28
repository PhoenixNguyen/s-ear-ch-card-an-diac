
package vn.onepay.search.client;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import vn.onepay.common.HmacSHA256;
import vn.onepay.common.MapUtil;

public class SearchClient {
	private final static Logger logger = Logger.getLogger(SearchClient.class);
	private static DateFormat isoDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
	private String endPoint;
	private String accessKey;
	private String secretKey;
	private boolean isActived;

	public void setEndPoint(String endPoint) {
		this.endPoint = endPoint;
	}

	public void setAccessKey(String accessKey) {
		this.accessKey = accessKey;
	}

	public void setSecretKey(String secretKey) {
		this.secretKey = secretKey;
	}
	
	public void setIsActived(boolean isActived){
		this.isActived = isActived;
	}

	public void pushIndex(String id, String merchant, String paymentProvider, String appCode, String serial, String pin, String type, int amount,
			String status, String message, Date timestamp) {
//		logger.info("Index to Search Engine: " + this.isActived);
		if(!this.isActived)
			return;
		try {
			Map<String, String> mParams = new HashMap<String, String>();
			mParams.put("id", StringUtils.trimToEmpty(id));
			mParams.put("amount", Integer.toString(amount));
			mParams.put("merchant", StringUtils.trimToEmpty(merchant));
			mParams.put("paymentProvider", StringUtils.trimToEmpty(paymentProvider));
			mParams.put("app_code", StringUtils.trimToEmpty(appCode));
			mParams.put("pin", StringUtils.trimToEmpty(pin));
			mParams.put("serial", StringUtils.trimToEmpty(serial));
			mParams.put("type", StringUtils.trimToEmpty(type));
			mParams.put("status", StringUtils.trimToEmpty(status));
			mParams.put("message", StringUtils.trimToEmpty(message));
			mParams.put("timestamp", isoDateTimeFormat.format(timestamp));

			final String data = MapUtil.mapToQueryString(mParams);
			HmacSHA256 hmacSHA256 = new HmacSHA256(secretKey);
			final String signature = hmacSHA256.sign(data);
			mParams.put("signature", signature);
			Thread myThread = new SearchIndexThread(endPoint, (Map) mParams);
			myThread.start();
		} catch (Exception e) {
			logger.error(e);
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		SearchClient client = new SearchClient();
		String id = "541a49460cf2560687b68af199";
		String merchant = "changic";
		String paymentProvider = "ahha_c_15_1";
		String appCode = "bnc";
		String serial = "54429823652";
		String pin = "8592515236179";
		String type = "viettel";
		int amount = 50000;
		String status = "00";
		String message = "01|Kiem tra thanh cong";
		Date timestamp = new Date();
		client.pushIndex(id, merchant, paymentProvider, appCode, serial, pin, type, amount, status, message, timestamp);
	}
}
