package vn.onepay.search.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.map.LinkedMap;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.elasticsearch.search.sort.SortOrder;
import org.springframework.data.elasticsearch.core.facet.result.IntervalUnit;
import org.springframework.data.elasticsearch.core.facet.result.Term;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import vn.onepay.account.model.Account;
import vn.onepay.card.model.ChargeStatus;
import vn.onepay.common.SharedConstants;
import vn.onepay.search.entities.ESCardCdr;
import vn.onepay.search.service.ElasticSearchService;
import vn.onepay.web.secure.controllers.AbstractProtectedController;

public class CardChargingAnalyticController extends AbstractProtectedController {
	private final static Logger logger = Logger.getLogger(CardChargingAnalyticController.class);

	public static String ALL_STATUS = "allStatus";
	public static String SUCCESS_STATUS = "successStatus";
	public static String INVALID_STATUS = "invalidStatus";
	public static String ERROR_STATUS = "errorStatus";

	private ElasticSearchService elasticSearchService;

	public void setElasticSearchService(ElasticSearchService elasticSearchService) {
		this.elasticSearchService = elasticSearchService;
	}

	@Override
	protected ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		Account account = (Account) request.getSession().getAttribute(SharedConstants.ACCOUNT_LOGINED);
		boolean isStaff = account.checkRole(Account.ACCOUNT_STAFF_ROLE) && account.checkRoles(new String[]{Account.ACCOUNT_ADMIN_ROLE, Account.ACCOUNT_OPERATION_MANAGER_ROLE, Account.ACCOUNT_REPORTER_ROLE, Account.ACCOUNT_SHARE_HOLDER_ROLE, Account.ACCOUNT_MERCHANT_MANAGER_ROLE, Account.ACCOUNT_BIZ_SUPPORTER_ROLE, Account.ACCOUNT_CUSTOMER_CARE_ROLE});
		List<String> myOwnMerchants = findMyOwnMerchants(account);
		//-------
		if(account.isAdmin() && SharedConstants.MBIZ && SharedConstants.MBIZ_MERCHANTS!=null && SharedConstants.MBIZ_MERCHANTS.length>0){
			if(myOwnMerchants!=null){
				List<String> myMerchants = new ArrayList<String>();
    			for(String mc: myOwnMerchants){
	    			for(String activedMerchant:SharedConstants.MBIZ_MERCHANTS){
						if(activedMerchant.equalsIgnoreCase(mc)){
							myMerchants.add(mc);
							break;
						}
					}
    			}
    			myOwnMerchants = myMerchants;
			}
		} else if(!isStaff && account.checkRole(Account.ACCOUNT_CUSTOMER_CARE_ROLE)) {
			if(!StringUtils.isBlank(account.getOwner())) {
				Account owner = accountDAO.find(account.getOwner());
				if(owner != null) {
					myOwnMerchants = findMyOwnMerchants(owner);
				}
			}
		}
		//-------
		if(myOwnMerchants!=null && myOwnMerchants.size() > 1)
			model.put("merchants", 	myOwnMerchants);
		//-------
		Date start = new Date();
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat df2 = new SimpleDateFormat("dd/MM/yyyy HH:mm");

		model.put("status", Arrays.asList(new Integer[] { 0, 1, 2 }));

		model.put(SUCCESS_STATUS, Arrays.asList(new String[] { ChargeStatus.SUCCESS_STATUS }));
		model.put(ERROR_STATUS, ChargeStatus.ALL_CHARGING_ERROR_STATUS);
		model.put(INVALID_STATUS, ChargeStatus.ALL_CHARGING_INVALID_STATUS);
		
		//status for filter
		@SuppressWarnings("unchecked")
		Map<String , String> statusMap = new LinkedMap();
		statusMap.put(SUCCESS_STATUS, "Thành công");
		statusMap.put(ERROR_STATUS, "Thẻ lỗi");
		statusMap.put(INVALID_STATUS, "Thẻ sai");
		model.put("statusMap", statusMap);
		
		// Option param
		//Handle date time
		String from_date = StringUtils.trimToEmpty(request.getParameter("from_date"));
		String to_date = StringUtils.trimToEmpty(request.getParameter("to_date"));
//		if(!from_date.equalsIgnoreCase(""))
//			model.put("from_date", df2.format(new Date()));
//		if(!to_date.equalsIgnoreCase(""))
//			model.put("to_date", df2.format(new Date()));
		
		from_date = handleDate(from_date, false);
		to_date = handleDate(to_date, true);
		
		System.out.println("Time search: " + from_date + " " + to_date);
		//End Handle date time
		
		//------- get myOwnMerchants to check Operator IN: Merchant manager permissions
		List<String> merchants = myOwnMerchants;
		if(isStaff || (!isStaff && (account.isMerchantManager() || account.checkRole(Account.ACCOUNT_CUSTOMER_CARE_ROLE)))){
			//Do nothing
			merchants = myOwnMerchants;
		}else{
			merchants = Arrays.asList(new String[]{account.getUsername()});
		}
		model.put("displayMerchant", checkRolesForDisplayMerchant(merchants));
		
		// (KEY PARAMS*)
		@SuppressWarnings("unchecked")
		Map<String, String> fieldMaps = new LinkedMap();
		fieldMaps.put("type", "Loại thẻ");
		if(checkRolesForDisplayProvider(account))
			fieldMaps.put("paymentProvider", "Nhà cung cấp");
		if(checkRolesForDisplayMerchant(merchants))
			fieldMaps.put("merchant", "Merchant");
		fieldMaps.put("status", "Trạng thái");
		model.put("fieldMaps", fieldMaps);

		// ( KEY FIELDS*)
		List<String> fields = new ArrayList<String>();
		fields.add("type");
		if(checkRolesForDisplayProvider(account))
			fields.add("paymentProvider");
		if(checkRolesForDisplayMerchant(merchants))
			fields.add("merchant");
		fields.add("status");

		// terms and fields have a size is equals
		List<String> terms = new ArrayList<String>();

		// (Regex Search*)
		@SuppressWarnings("unchecked")
		Map<String, List<String>> keywords = new LinkedMap();
		// Filter histograms
		List<String> filter_merchant = null;
		List<String> filter_provider = null;
		List<String> filter_status = null;
		// List<String> filter_card_type = null;

		String merchantParam = StringUtils.trimToEmpty(request.getParameter("filter_merchant"));
		if (!merchantParam.equalsIgnoreCase("")) {
			filter_merchant = Arrays.asList(new String[] { merchantParam });
		}

		String providerParam = StringUtils.trimToEmpty(request.getParameter("filter_provider"));
		if (!providerParam.equalsIgnoreCase("")) {
			filter_provider = Arrays.asList(new String[] { providerParam });
		}

		String statusParam = StringUtils.trimToEmpty(request.getParameter("filter_status"));
		if(statusParam.equalsIgnoreCase(SUCCESS_STATUS)){
			filter_status = Arrays.asList(new String[] { ChargeStatus.SUCCESS_STATUS });
		}
		else if(statusParam.equalsIgnoreCase(ERROR_STATUS)){
			filter_status = ChargeStatus.ALL_CHARGING_ERROR_STATUS;
		}else if(statusParam.equalsIgnoreCase(INVALID_STATUS)){
			filter_status = ChargeStatus.ALL_CHARGING_INVALID_STATUS;
		}
		// if(request.getParameterValues("filter_card_type") != null)
		// filter_card_type =
		// Arrays.asList(request.getParameterValues("filter_card_type"));

		/*
		 * //Auto param for(String field : fieldMaps.keySet()){ String param =
		 * StringUtils.trimToEmpty(request.getParameter(field));
		 * terms.add(param); }
		 */

		// click on facet card type
		if (StringUtils.isNotBlank(request.getParameter("type"))) {
			terms.add(StringUtils.trimToEmpty(request.getParameter("type")));
		} else {
			terms.add("");
			// Operator IN:
			/*
			 * if(filter_card_type != null && filter_card_type.size() > 0){
			 * String operator = "_operator_in"; keywords.put("type" + operator,
			 * filter_card_type); }
			 */
		}

		// click on facet paymentprovider
		if(checkRolesForDisplayProvider(account))
			if (StringUtils.isNotBlank(request.getParameter("paymentProvider"))) {
				terms.add(StringUtils.trimToEmpty(request.getParameter("paymentProvider")));
			} else {
				terms.add("");
				// logger.info("filter_provider: " + filter_provider);
				// Operator IN:
				if (filter_provider != null && filter_provider.size() > 0) {
					String operator = "_operator_in";
					keywords.put("paymentProvider" + operator, filter_provider);
				}
			}

		// click on facet merchant
		if(checkRolesForDisplayMerchant(merchants))
			if (StringUtils.isNotBlank(request.getParameter("merchant"))) {
				terms.add(StringUtils.trimToEmpty(request.getParameter("merchant")));
			} else {
				terms.add("");
				// Operator Regex:
				if (filter_merchant != null && filter_merchant.size() > 0) {
					String operator = "_operator_regex";
					keywords.put("merchant" + operator, filter_merchant);
				}
			}
		// status
		terms.add("");
		if(filter_status != null && filter_status.size() > 0){
			String operator = "_operator_in";
			keywords.put("status" + operator, filter_status);
		}
		// End Filter histograms
		
		//Operator IN: Merchant manager permissions
		if (merchants != null && merchants.size() > 0) {
			String operator = "_operator_in";
			keywords.put("merchant" + operator, merchants);
		}
		//-------
		// Operator time range:
		List<String> timeRanges = Arrays.asList(new String[] { from_date, to_date });
		if (timeRanges != null && timeRanges.size() > 0) {
			String operator = "_operator_time_range";
			keywords.put("timestamp" + operator, timeRanges);
		}

		// (Sort *)
		@SuppressWarnings("unchecked")
		Map<String, SortOrder> sorts = new LinkedMap();
		sorts.put("timestamp", SortOrder.DESC);
		sorts.put("amount", SortOrder.ASC);

		// (List facets*)
		List<List<Term>> termLists = new ArrayList<List<Term>>();
		// list all facets
		List<List<Term>> termAllLists = new ArrayList<List<Term>>();

		@SuppressWarnings("unchecked")
		Map<String, List<IntervalUnit>> statusHistogramMap = new LinkedMap();

		// To compare with last day -----------------------------------------
		@SuppressWarnings("unchecked")
		Map<String, List<IntervalUnit>> statusHistogramMapLast = new LinkedMap();
		@SuppressWarnings("unchecked")
		Map<String, List<String>> keywordsLast = new LinkedMap();
		keywordsLast.putAll(keywords);
		// Operator time range:
		
		Date fr = df.parse(from_date);
		Date to = df.parse(to_date);
		int dayBetween =  (int)(Math.abs(to.getTime() - fr.getTime()) / (24*60*60*1000)) + 1;
		
		//get last from
		Calendar c = Calendar.getInstance();
		c.setTime(fr);
		c.add(Calendar.DAY_OF_MONTH, -1*dayBetween);
		String frStr = df.format(c.getTime());
		//get last to
		Calendar c2 = Calendar.getInstance();
		c2.setTime(to);
		c2.add(Calendar.DAY_OF_MONTH, -1*dayBetween);
		String toStr = df.format(c2.getTime());
		
		System.out.println("DAY Last: " + frStr + " " + toStr);
		List<String> timeRangeLast = Arrays.asList(new String[] { frStr, toStr }); 
																				
		if (timeRangeLast != null && timeRangeLast.size() > 0) {
			String operator = "_operator_time_range";
			keywordsLast.put("timestamp" + operator, timeRangeLast);
		}
		
		// end compare ------------------------------------------------------

		// field filter
		List<String> fieldHistogram = new ArrayList<String>();
		fieldHistogram.add(ALL_STATUS);
		fieldHistogram.add(SUCCESS_STATUS);
		fieldHistogram.add(INVALID_STATUS);
		fieldHistogram.add(ERROR_STATUS);

		// Count
		int count = 0;

		// Facet size to view
		int facetSize = 20;

		if (elasticSearchService.checkIndex(ESCardCdr.class)) {
			count = elasticSearchService.count(fields, terms, keywords, facetSize, ESCardCdr.class);
			termAllLists = elasticSearchService.getFacets(fields, null, null, facetSize, ESCardCdr.class);

			termLists = elasticSearchService.getFacets(fields, terms, keywords, facetSize, ESCardCdr.class);

			// get histogram
			String field = "timestamp";
			String fieldFilter = "status";
			String operator = "_operator_in";
			
			if(filter_status == null || filter_status.size() == 0){
				for (String status : fieldHistogram) {
					if (status.equalsIgnoreCase(SUCCESS_STATUS)) {
						keywords.put(fieldFilter + operator, Arrays.asList(new String[] { ChargeStatus.SUCCESS_STATUS }));
						keywordsLast.put(fieldFilter + operator, Arrays.asList(new String[] { ChargeStatus.SUCCESS_STATUS }));
					} else if (status.equalsIgnoreCase(INVALID_STATUS)) {
						keywords.put(fieldFilter + operator, ChargeStatus.ALL_CHARGING_INVALID_STATUS);
						keywordsLast.put(fieldFilter + operator, ChargeStatus.ALL_CHARGING_INVALID_STATUS);
					} else if (status.equalsIgnoreCase(ERROR_STATUS)) {
						keywords.put(fieldFilter + operator, ChargeStatus.ALL_CHARGING_ERROR_STATUS);
						keywordsLast.put(fieldFilter + operator, ChargeStatus.ALL_CHARGING_ERROR_STATUS);
					}
	
					statusHistogramMap.put(status, elasticSearchService.getHistogramFacet(field, fields, terms, keywords, facetSize, ESCardCdr.class));
					statusHistogramMapLast.put(status, elasticSearchService.getHistogramFacet(field, fields, terms, keywordsLast, facetSize, ESCardCdr.class));
	
				}
			}else{
				statusHistogramMap.put(statusParam, elasticSearchService.getHistogramFacet(field, fields, terms, keywords, facetSize, ESCardCdr.class));
				statusHistogramMapLast.put(statusParam, elasticSearchService.getHistogramFacet(field, fields, terms, keywordsLast, facetSize, ESCardCdr.class));

			}
		}

		// (*)
		// push to layout
		@SuppressWarnings("unchecked")
		Map<String, List<Term>> facetsMap = new LinkedMap();
		@SuppressWarnings("unchecked")
		Map<String, List<Term>> facetAllsMap = new LinkedMap();

		int k = 0;
		for (String field : fieldMaps.keySet()) {
			// filter
			if (termLists.size() > k)
				facetsMap.put(field, termLists.get(k));

			// All
			if (termAllLists.size() > k)
				facetAllsMap.put(field, termAllLists.get(k));

			k++;
		}

		// logger.info("COUNT: " + count);
		model.put("total", count);
		model.put("facetsMap", facetsMap);
		model.put("facetAllsMap", facetAllsMap);
		model.put("statusHistogramMap", statusHistogramMap);
		model.put("statusHistogramMapLast", statusHistogramMapLast);

		Date end = new Date();
		Long duration = end.getTime() - start.getTime();
		Long timeHandleTotal = TimeUnit.MILLISECONDS.toMillis(duration);

		model.put("timeHandleTotal", timeHandleTotal);

		return new ModelAndView(getWebView(), "model", model);
	}

	private String handleDate(String date, boolean end) throws ParseException {
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
		String secondZero = ":00";
		String today = df2.format(new Date()) + " 00:00:00";
		
		if(!end){
			if(!date.equals("")){
				date += secondZero;
				try{
					if (df.parse(date) != null){
						return date;
					}
					else
						return today;
				}catch(Exception e){
					e.printStackTrace();
					return today;
				}
			}
			else{
				return today;
			}
		}
		else{
			Calendar c = Calendar.getInstance();
			c.setTime(df.parse(today));
			c.add(Calendar.SECOND, 24*60*60-1);
			
			today = df.format(c.getTime());
			
			if(!date.equals("")){
				date += secondZero;
				try{
					if (df.parse(date) != null){
						Calendar c2 = Calendar.getInstance();
						c2.setTime(df.parse(date));
						c2.add(Calendar.SECOND, 60*60-1);
						
						return df.format(c2.getTime());
					}
					else
						return today;
				}catch(Exception e){
					e.printStackTrace();
					return today;
				}
			}
			else{
				return today;
			}
		}
		
	}

	private boolean checkRolesForDisplayMerchant(List<String> merchants) {
		
		if(merchants != null && merchants.size() > 1)
			return true;
		return false;
	}

	private boolean checkRolesForDisplayProvider(Account account) {
		if(account.isOperator() || account.isBizSupporter() || account.isCustomerCare())
			return true;
		return false;
	}
}
