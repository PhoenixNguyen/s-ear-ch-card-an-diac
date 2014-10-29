package vn.onepay.search.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import vn.onepay.common.HmacSHA256;
import vn.onepay.common.MapUtil;
import vn.onepay.search.entities.ESSMS;
import vn.onepay.search.service.ElasticSearchService;
import vn.onepay.service.ServiceFinder;

@SuppressWarnings("serial")
public class IndexESSmsServlet extends HttpServlet {
	private final static Logger logger = Logger.getLogger(IndexESSmsServlet.class);

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}
	private static DateFormat isoDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		ElasticSearchService elasticSearch = ServiceFinder.getContext(req).getBean(ElasticSearchService.BEAN_NAME, ElasticSearchService.class);
		final String access_key = StringUtils.trimToEmpty(this.getServletConfig().getInitParameter("access-key"));
		final String secret = StringUtils.trimToEmpty(this.getServletConfig().getInitParameter("secret-key"));

		Map<String, String> params = MapUtil.httpRequestParameterToMap(req);
		logger.info(MapUtil.mapToHttpQueryString(params));
		// ------------------------
		JSONObject jsonObject = new JSONObject();
		final long t1 = System.currentTimeMillis();
		
		//http://localhost:8080/search/mo/pushIn?id=123&merchant=123&app_id=123&provider=123&telco=123&msisdn=123&amount=1000&command_code=123&short_code=123&mo_message=123&request_time=1412794080000
		try {
			String id = StringUtils.trimToEmpty(params.get("id"));
			String merchant = StringUtils.trimToEmpty(params.get("merchant"));
			String app_id = StringUtils.trimToEmpty(params.get("app_id"));
			String provider = StringUtils.trimToEmpty(params.get("provider"));
			String telco = StringUtils.trimToEmpty(params.get("telco"));
			String msisdn = StringUtils.trimToEmpty(params.get("msisdn"));
			String amount = StringUtils.trimToEmpty(params.get("amount"));
			String command_code = StringUtils.trimToEmpty(params.get("command_code"));
			String short_code = StringUtils.trimToEmpty(params.get("short_code"));
			String mo_message = StringUtils.trimToEmpty(params.get("mo_message"));
			String request_time = StringUtils.trimToEmpty(params.get("request_time"));
			
			final String signature = StringUtils.trimToEmpty(params.remove("signature"));
			final String data = MapUtil.mapToQueryString(params);
			HmacSHA256 hmacSHA256 = new HmacSHA256(secret);
			final String aSign = hmacSHA256.sign(data);
			
			ESSMS mo = new ESSMS(id, merchant, app_id, provider, telco, msisdn, Integer.parseInt(amount), command_code, short_code, mo_message, isoDateTimeFormat.parse(request_time));
			if (elasticSearch.checkIndex(ESSMS.class)) {
				if (!elasticSearch.exist(mo.getId(), ESSMS.class)) {
					if (StringUtils.isNotEmpty(elasticSearch.index(mo.getId(), mo))) {
						logger.info("indexed");
						jsonObject.put("status", "00");
						jsonObject.put("message", "Đẩy dữ liệu thành công");
					}
				} else {
					logger.info("existed");
					jsonObject.put("status", "01");
					jsonObject.put("message", "Đã tồn tại mo");
				}
			}
		} catch (Exception e) {
			logger.error(e);
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
		} finally {
			// -------------------------
			final long t2 = System.currentTimeMillis();
			logger.info("Take time " + (t2 - t1) + " ms for");
		}
		resp.setContentType("application/json;charset=UTF-8");
		PrintWriter out = resp.getWriter();
		out.append(jsonObject.toString());
		out.flush();
		out.close();
	}
}
