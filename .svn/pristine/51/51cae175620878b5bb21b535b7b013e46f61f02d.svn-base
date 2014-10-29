package vn.onepay.search.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.map.LinkedMap;
import org.apache.commons.lang.StringUtils;
import org.elasticsearch.search.sort.SortOrder;
import org.springframework.data.elasticsearch.core.facet.result.IntervalUnit;
import org.springframework.data.elasticsearch.core.facet.result.Term;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import vn.onepay.account.model.Account;
import vn.onepay.search.entities.ESSMS;
import vn.onepay.search.entities.FilteringSMS;
import vn.onepay.search.service.ElasticSearchService;
import vn.onepay.web.secure.controllers.AbstractProtectedController;

public class SMSAnalyticController extends AbstractProtectedController{

	public ElasticSearchService elasticSearchService;

	public ElasticSearchService getElasticSearchService() {
		return elasticSearchService;
	}

	public void setElasticSearchService(ElasticSearchService elasticSearchService) {
		this.elasticSearchService = elasticSearchService;
	}

	private int limit;
	public void setLimit(int limit) {
	    this.limit = limit;
	}
	
	@SuppressWarnings("unused")
	@Override
	protected ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) throws Exception {
		Date start = new Date();
		Account account = (Account)request.getSession().getAttribute("account_logined");
		
		model.put("status", Arrays.asList(new Integer[]{0, 1, 2}));
		
		//Option param 
		String tab = StringUtils.trimToEmpty(request.getParameter("tab"));
		String merchant = StringUtils.trimToEmpty(request.getParameter("filter_merchant"));
		String reservation = StringUtils.trimToEmpty(request.getParameter("from_date"));
		String filter_command_code = StringUtils.trimToEmpty(request.getParameter("filter_command_code"));
		
		List<String> filter_providers = null;
		if(request.getParameterValues("providers") != null){
			filter_providers = Arrays.asList(request.getParameterValues("providers"));
		}
		
		//(KEY PARAMS*)
		@SuppressWarnings("unchecked")
		Map<String , String> fieldMaps = new LinkedMap();
		fieldMaps.put("msisdn", "Thuê bao");
		fieldMaps.put("merchant", "Merchant");
		fieldMaps.put("provider", "Nhà cung cấp");
		fieldMaps.put("telco", "Nhà mạng");
		
		model.put("fieldMaps", fieldMaps);
		
		//( KEY FIELDS*)
		List<String> fields = new ArrayList<String>();
		fields.add("msisdn");
		fields.add("merchant");
		fields.add("provider");
		fields.add("telco");
		
		
		List<String> terms = new ArrayList<String>();
		//Auto param 
		for(String field : fieldMaps.keySet()){
			
			String param = StringUtils.trimToEmpty(request.getParameter(field));
			terms.add(param);
		}
		
	    //(Regex Search*)
	    @SuppressWarnings("unchecked")
		Map<String , List<String>> keywords = new LinkedMap();
	    
	    if(!merchant.equals("")){
	    	String operator = "_operator_regex";
	    	keywords.put("merchant" + operator, Arrays.asList(new String[]{merchant}) );
	    }
	    
	    if(!filter_command_code.equals("")){
	    	String operator = "_operator_regex";
	    	keywords.put("command_code" + operator, Arrays.asList(new String[]{filter_command_code}) );
	    }
	    
	    //Operator IN: Merchant manager permissions
	    List<String> merchants = null;
	    if(account.isOperator())
	    	merchants = null;
	    else
	    	if(account.isMerchantManager())
		    	merchants = Arrays.asList(new String[]{account.getUsername(), "mwork", "tritueviet", "dungtt"});
	    	else
			    if(account.isMerchant())
			    	merchants = Arrays.asList(new String[]{account.getUsername()});
			    else
			    	merchants = Arrays.asList(new String[]{""});
	    
	    if(merchants != null && merchants.size() > 0){
	    	String operator = "_operator_in";
    		keywords.put("merchant" + operator, merchants);
	    }
	    
	    if(filter_providers != null && filter_providers.size() > 0){
	    	String operator = "_operator_in";
    		keywords.put("provider" + operator, filter_providers);
	    }
	    
	    //Operator TIME RANGE: filter with time reservation
	    /*String fromDateStr = "";
		String toDateStr = "";
		if(!reservation.equals("")){
			try{
				String[] reservationArr = reservation.split("-");
				fromDateStr = StringUtils.trimToEmpty(reservationArr[0]);
				toDateStr = StringUtils.trimToEmpty(reservationArr[1]);
			}catch(Exception e){
				e.printStackTrace();
			}
		}*/
		
	    List<String> timeRanges = Arrays.asList(new String[]{handleDate(reservation, false), handleDate(reservation, true)}); 
	    if(timeRanges != null && timeRanges.size() > 0){
	    	String operator = "_operator_time_range";
	    	keywords.put("request_time" + operator, timeRanges);
	    }
		
	    //(Sort *)
	    @SuppressWarnings("unchecked")
		Map<String , SortOrder> sorts = new LinkedMap();
	    sorts.put("merchant", SortOrder.ASC);
	    sorts.put("msisdn", SortOrder.ASC);
	    sorts.put("request_time", SortOrder.DESC);
	    
		int offset = 0;
		int page = 0;
	      if (StringUtils.isNumeric(request.getParameter("d-49520-p"))) {
	    	  offset = Integer.parseInt(request.getParameter("d-49520-p"));
	    	  page = Integer.parseInt(request.getParameter("d-49520-p")) - 1;
	        if (offset > 0) {
	          offset = (offset - 1) * this.limit;
	        }
	      }
	      
	      //histogram
	      @SuppressWarnings("unchecked")
		  Map<String, List<IntervalUnit>> dataHistogramMap = new LinkedMap();
	      
	      /*for(String key1 : dataHistogramMap.keySet()){
	    	  System.out.println(key1 + " ");
	    	  for(IntervalUnit i : dataHistogramMap.get(key1)){
	    		  System.out.println(" 		" + i.getKey() + " " + i.getCount());
	    	  }
	      }*/
	      
	      //List facets*
		  List<List<Term>> termLists = new ArrayList<List<Term>>();
		  //List all facets*
		  List<List<Term>> termAllLists = new ArrayList<List<Term>>();
		  
		  //List Object
	      List<ESSMS> dataList = new ArrayList<ESSMS>();
	      //Count
	      int count = 0;
	      
	      //Facet size to view
	      int facetSize = 20;
	      
	      if(elasticSearchService.checkIndex(ESSMS.class)){
	    	    count = elasticSearchService.count(fields, terms, keywords, facetSize, ESSMS.class);
	    	    termLists = elasticSearchService.getFacets(fields, terms, keywords, facetSize, ESSMS.class);
	    	    termAllLists = elasticSearchService.getFacets(fields, null, null, facetSize, ESSMS.class);
	    	    
	    	    dataList = elasticSearchService.search(fields, terms, keywords, sorts, 0/*page*/, count/*limit*/, facetSize, ESSMS.class);
	      }
	    
	    //Get provider
	    List<String> providers = new ArrayList<String>();
	    List<Term> termProviders = null;
		    if(termAllLists.size() > 3)  
		    	termProviders =  termAllLists.get(2);
		for(Term term : termProviders){
			providers.add(term.getTerm());
		}
		model.put("providers", providers);
		
		//Get Merchant
		List<String> merchantList = new ArrayList<String>();
	    List<Term> termMerchants = null;
		    if(termAllLists.size() > 2)  
		    	termMerchants =  termAllLists.get(1);
		for(Term term : termMerchants){
			merchantList.add(term.getTerm());
		}
		model.put("merchantList", merchantList);
		
	    int limit = 20;
	    String fieldHistogram = "request_time";
		String fieldFilter = "msisdn";
		String operator = "_operator_term";
		
	    List<ESSMS> sortedDataList = new ArrayList<ESSMS>();
	    if(tab.equalsIgnoreCase("") || tab.equalsIgnoreCase("subscriber") || !tab.equalsIgnoreCase("merchant")){
	    	sortedDataList = handleSortWithSubscriberByCount(dataList, limit);
	    	
	    	List<FilteringSMS> topMsisdns = new ArrayList<FilteringSMS>();
		    topMsisdns = getTopMsisdn(sortedDataList, limit);
		    model.put("topData", topMsisdns);
		    model.put("pagesize1", limit);
		    model.put("total1", topMsisdns==null?0:topMsisdns.size());
		    
		    // get histogram
		    if(topMsisdns != null && topMsisdns.size() > 0){
		    	for(FilteringSMS data : topMsisdns){
		    		keywords.put(fieldFilter + operator, Arrays.asList(new String[] { data.getMsisdn()}));
		    		keywords.put("merchant" + operator, Arrays.asList(new String[] { data.getMerchant().toLowerCase()}));
		    		keywords.put("provider" + operator, Arrays.asList(new String[] { data.getProvider()}));
		    		
		    		dataHistogramMap.put(data.getMsisdn() + " " +data.getMerchant()+ " " + data.getProvider(), elasticSearchService.getHistogramFacet(fieldHistogram, fields, terms, keywords, facetSize, ESSMS.class));
		    		
		    	}
		    }
	    }
	    else{
	    	sortedDataList = handleSortWithMerchantByCount(dataList, limit);
	    	
	    	List<FilteringSMS> topMerchant = new ArrayList<FilteringSMS>();
	    	topMerchant = getTopMerchant(sortedDataList, limit);
		    model.put("topData", topMerchant);
		    model.put("pagesize1", limit);
		    model.put("total1", topMerchant==null?0:topMerchant.size());
		    
		    // get histogram
		    if(topMerchant != null && topMerchant.size() > 0){
		    	for(FilteringSMS data : topMerchant){
		    		fieldFilter = "merchant";
		    		keywords.put(fieldFilter + operator, Arrays.asList(new String[] { data.getMerchant().toLowerCase()}));
		    		dataHistogramMap.put(data.getMerchant(), elasticSearchService.getHistogramFacet(fieldHistogram, fields, terms, keywords, facetSize, ESSMS.class));
		    		
		    	}
		    }
	    }
	    
	    //Term for histogram
	    /*List<Term> termForHistograms = null;
	    if(termLists.size() > 4)  
	    	termForHistograms =  termLists.get(3);*/
	    
	    //System.out.println("COUNT: "+count);
	    
		//(*)
		//push to layout
		@SuppressWarnings("unchecked")
		Map<String , List<Term>> facetsMap = new LinkedMap();
		int k = 0;
		for(String field : fieldMaps.keySet()){
			
			if(termLists.size() > k)
				facetsMap.put(field, termLists.get(k));
			
			k++;
		}

		model.put("facetsMap", facetsMap);
			
		model.put("pagesize", Integer.valueOf(this.limit));
	    model.put("offset", Integer.valueOf(offset));
	    model.put("list", sortedDataList);
	    model.put("total", sortedDataList==null?0:sortedDataList.size());
	    
	    model.put("dataHistogramMap", dataHistogramMap);
	    
	    Date end = new Date();
	    Long duration = end.getTime() - start.getTime();
	    Long timeHandleTotal = TimeUnit.MILLISECONDS.toMillis(duration);
	      
        model.put("timeHandleTotal", timeHandleTotal);
	      
		return new ModelAndView(getWebView(), "model", model);
	}
	
	public static List<FilteringSMS> getTopMsisdn(List<ESSMS> sortedDataList, int limit) {
	  if(sortedDataList == null || sortedDataList.size() == 0)
      return null;
    
    List<FilteringSMS> topMsisdn = new ArrayList<FilteringSMS>();
    for(ESSMS mo : sortedDataList){
      //limit
      if(limit >= 0 && limit <= topMsisdn.size())
        break;
      
      int index = -1;
      for(int i = 0; i < topMsisdn.size(); i++){
        if(topMsisdn.get(i).getMerchant().equalsIgnoreCase(mo.getMerchant()) && 
            topMsisdn.get(i).getMsisdn().equalsIgnoreCase(mo.getMsisdn()) &&
            topMsisdn.get(i).getProvider().equalsIgnoreCase(mo.getProvider())
            ){
          index = i;
          break;
        }
      }
      
      if(index != -1){
        topMsisdn.get(index).setAmount(topMsisdn.get(index).getAmount() + mo.getAmount());
        topMsisdn.get(index).setCount_sms(topMsisdn.get(index).getCount_sms() + 1);
      }
      else
        topMsisdn.add(new FilteringSMS(mo.getMsisdn(), mo.getMerchant(), mo.getProvider(), 1, 1, mo.getAmount()));
      
    }
    
    return topMsisdn;
	}
	
	public static List<FilteringSMS> getTopMerchant(List<ESSMS> sortedDataList, int limit) {
		if(sortedDataList == null || sortedDataList.size() == 0)
			return null;
		
		List<FilteringSMS> topMerchant = new ArrayList<FilteringSMS>();
		List<String> msisdns = new ArrayList<String>();
		
		for(ESSMS mo : sortedDataList){
			//limit
			if(limit >= 0 && limit <= topMerchant.size())
				break;
			
			int index = -1;
			for(int i = 0; i < topMerchant.size(); i++){
				if(topMerchant.get(i).getMerchant().equalsIgnoreCase(mo.getMerchant())){
					index = i;
					break;
				}
			}
			
			if(index != -1){
				if(!msisdns.contains(mo.getMsisdn())){
					msisdns.add(mo.getMsisdn());
					//System.out.println("merchant " + mo.getMerchant() + " " + mo.getMsisdn() + " " + msisdns.size());
				}
				
				topMerchant.get(index).setAmount(topMerchant.get(index).getAmount() + mo.getAmount());
				topMerchant.get(index).setCount_sms(topMerchant.get(index).getCount_sms() + 1);
				topMerchant.get(index).setCount_msisdn(msisdns.size());
			}
			else{
				System.out.println("merchant " + mo.getMerchant() + " ");
				topMerchant.add(new FilteringSMS("", mo.getMerchant(), mo.getProvider(), 1, 1, mo.getAmount()));
				
				//reset
				msisdns = new ArrayList<String>();
				msisdns.add(mo.getMsisdn());
			}
			
		}
		
		return topMerchant;
	}
	
	@SuppressWarnings({ "unchecked", "unused" })
	private List<ESSMS> handleSortWithSubscriberBySum(List<ESSMS> dataList){
		if(dataList == null || dataList.size() == 0)
			return null;
		
		Map<String , Integer> listSum = new LinkedMap();
		
		for(int i = 0; i < dataList.size(); i++){
			if(listSum.containsKey(dataList.get(i).getMerchant() +"::"+ dataList.get(i).getMsisdn())){
				int old = listSum.get(dataList.get(i).getMerchant() +"::"+ dataList.get(i).getMsisdn());
				listSum.put(dataList.get(i).getMerchant() +"::"+ dataList.get(i).getMsisdn(), dataList.get(i).getAmount() + old);
			}
			else
				listSum.put(dataList.get(i).getMerchant() +"::"+ dataList.get(i).getMsisdn(), dataList.get(i).getAmount());
		}
		listSum = sortByValue(listSum);
		
		//result
		List<ESSMS> results = new ArrayList<ESSMS>();
		for(String msisdn : listSum.keySet()){
			//System.out.println(msisdn.substring(msisdn.indexOf("::") + 2, msisdn.length()) + " " + listSum.get(msisdn));
			for(ESSMS mo : dataList){
				if(mo.getMsisdn().equalsIgnoreCase(msisdn.substring(msisdn.indexOf("::") + 2, msisdn.length()))){
					results.add(mo);
				}
			}
			
		}
		return results;
	}
	@SuppressWarnings("unchecked")
	public static List<ESSMS> handleSortWithSubscriberByCount(List<ESSMS> dataList, int limit){
		if(dataList == null || dataList.size() == 0)
			return null;
		
		Map<String , Integer> listSum = new LinkedMap();
		
		for(int i = 0; i < dataList.size(); i++){
			if(listSum.containsKey(dataList.get(i).getMerchant() +"::"+ dataList.get(i).getMsisdn())){
				int old = listSum.get(dataList.get(i).getMerchant() +"::"+ dataList.get(i).getMsisdn());
				listSum.put(dataList.get(i).getMerchant() +"::"+ dataList.get(i).getMsisdn(), 1 + old);
			}
			else{
				listSum.put(dataList.get(i).getMerchant() +"::"+ dataList.get(i).getMsisdn(), 1);
			}
		}
		listSum = sortByValue(listSum);
		
		//result
		List<ESSMS> results = new ArrayList<ESSMS>();
		int i = 0;
		for(String msisdn : listSum.keySet()){
			if(limit >= 0 && i++ >= limit)
				break;
			
			//System.out.println(msisdn.substring(msisdn.indexOf("::") + 2, msisdn.length()) + " " + listSum.get(msisdn));
			for(ESSMS mo : dataList){
				if(mo.getMsisdn().equalsIgnoreCase(msisdn.substring(msisdn.indexOf("::") + 2, msisdn.length()))){
					results.add(mo);
				}
			}
			
		}
		return results;
	}
	
	@SuppressWarnings("unchecked")
	public static List<ESSMS> handleSortWithMerchantByCount(List<ESSMS> dataList, int limit){
		if(dataList == null || dataList.size() == 0)
			return null;
		
		Map<String , Integer> listSum = new LinkedMap();
		List<String> msisdns = new ArrayList<String>();
		
		for(int i = 0; i < dataList.size(); i++){
			if(listSum.containsKey(dataList.get(i).getMerchant())){
				if(!msisdns.contains(dataList.get(i).getMsisdn()))
					msisdns.add(dataList.get(i).getMsisdn());
				
				listSum.put(dataList.get(i).getMerchant(), msisdns.size());
			}
			else{
				listSum.put(dataList.get(i).getMerchant(), 1);
				
				//reset
				msisdns = new ArrayList<String>();
				msisdns.add(dataList.get(i).getMsisdn());
				
			}
		}
		listSum = sortByValue(listSum);
		
		//result
		List<ESSMS> results = new ArrayList<ESSMS>();
		int i = 0;
		for(String merchant : listSum.keySet()){
			if(limit >= 0 && i++ >= limit)
				break;
			System.out.println(merchant + " " + listSum.get(merchant));
			for(ESSMS mo : dataList){
				if(mo.getMerchant().equalsIgnoreCase(merchant)){
					results.add(mo);
				}
			}
			
		}
		return results;
	}
	@SuppressWarnings({ "unused", "unchecked" })
	private List<ESSMS> handleSortWithMerchantBySum(List<ESSMS> dataList){
		if(dataList == null || dataList.size() == 0)
			return null;
		
		Map<String , Integer> listSum = new LinkedMap();
		for(int i = 0; i < dataList.size(); i++){
			if(listSum.containsKey(dataList.get(i).getMerchant())){
				int old = listSum.get(dataList.get(i).getMerchant());
				listSum.put(dataList.get(i).getMerchant(), dataList.get(i).getAmount() + old);
			}
			else
				listSum.put(dataList.get(i).getMerchant(), dataList.get(i).getAmount());
		}
		listSum = sortByValue(listSum);
		
		//result
		List<ESSMS> results = new ArrayList<ESSMS>();
		for(String merchant : listSum.keySet()){
			System.out.println(merchant + " " + listSum.get(merchant));
			for(ESSMS mo : dataList){
				if(mo.getMerchant().equalsIgnoreCase(merchant)){
					results.add(mo);
				}
			}
			
		}
		return results;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Map sortByValue(Map unsortMap) {	 
		List list = new LinkedList(unsortMap.entrySet());
	 
		Collections.sort(list, new Comparator() {
			public int compare(Object o1, Object o2) {
				return ((Comparable) ((Map.Entry) (o2)).getValue())
							.compareTo(((Map.Entry) (o1)).getValue());
			}
		});
	 
		Map sortedMap = new LinkedMap();
		for (Iterator it = list.iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			sortedMap.put(entry.getKey(), entry.getValue());
		}
		return sortedMap;
	}

	public static String handleDate(String date, boolean end) throws ParseException {
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		SimpleDateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
		String time = " 00:00:00";
		String today = df2.format(new Date()) + time;
		
		if(!end){
			if(!date.equals("")){
				date += time;
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
				date += time;
				try{
					if (df.parse(date) != null){
						Calendar c2 = Calendar.getInstance();
						c2.setTime(df.parse(date));
						c2.add(Calendar.SECOND, 24*60*60-1);
						
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
}
