package vn.onepay.search.client;

import java.util.Map;

import org.apache.log4j.Logger;

import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.Unirest;

public class SearchIndexThread extends Thread {
	private final static Logger logger = Logger.getLogger(SearchIndexThread.class);
	private String endPoint;
	private Map<String, Object> mParams;

	public SearchIndexThread(String endPoint, Map<String, Object> mParams) {
		this.endPoint = endPoint;
		this.mParams = mParams;
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		try {
			Unirest.setTimeouts(2000, 10000);
			HttpResponse<String> response = Unirest.post(this.endPoint).header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
					.fields(this.mParams).asString();
			logger.info(response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
