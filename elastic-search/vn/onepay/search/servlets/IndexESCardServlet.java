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

import vn.onepay.card.model.ChargeStatus;
import vn.onepay.common.HmacSHA256;
import vn.onepay.common.MapUtil;
import vn.onepay.search.entities.ESCardCdr;
import vn.onepay.search.service.ElasticSearchService;
import vn.onepay.service.ServiceFinder;

@SuppressWarnings("serial")
public class IndexESCardServlet extends HttpServlet {
	private final static Logger logger = Logger.getLogger(IndexESCardServlet.class);

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
		try {
			String id = StringUtils.trimToEmpty(params.get("id"));
			String amount = StringUtils.trimToEmpty(params.get("amount"));
			String merchant = StringUtils.trimToEmpty(params.get("merchant"));
			String paymentProvider = StringUtils.trimToEmpty(params.get("paymentProvider"));
			String appCode = StringUtils.trimToEmpty(params.get("app_code"));
			String pin = StringUtils.trimToEmpty(params.get("pin"));
			String serial = StringUtils.trimToEmpty(params.get("serial"));
			String type = StringUtils.trimToEmpty(params.get("type"));
			String status = StringUtils.trimToEmpty(params.get("status"));
			String message = StringUtils.trimToEmpty(params.get("message"));
			String timestamp = StringUtils.trimToEmpty(params.get("timestamp"));
			final String signature = StringUtils.trimToEmpty(params.remove("signature"));
			final String data = MapUtil.mapToQueryString(params);
			HmacSHA256 hmacSHA256 = new HmacSHA256(secret);
			final String aSign = hmacSHA256.sign(data);
			if (signature.equalsIgnoreCase(aSign)) {
				if(!ChargeStatus.MAP_STATUS_MESSAGE.containsKey(status))
					status = ChargeStatus.CARD_CAN_NOT_BE_USED_STATUS;
				ESCardCdr cardCdr = new ESCardCdr(id, Integer.parseInt(amount), merchant, paymentProvider, appCode, pin, serial, type, status, message,
						isoDateTimeFormat.parse(timestamp));
				if (elasticSearch.checkIndex(ESCardCdr.class)) {
					if (!elasticSearch.exist(cardCdr.getId(), ESCardCdr.class)) {
						if (StringUtils.isNotEmpty(elasticSearch.index(cardCdr.getId(), cardCdr))) {
							logger.info("indexed");
							jsonObject.put("status", "00");
							jsonObject.put("message", "Đẩy dữ liệu thành công");
						}
					} else {
						logger.info("existed");
						jsonObject.put("status", "01");
						jsonObject.put("message", "Đã tồn tại thẻ");
					}
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
