package vn.onepay.search.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TimerTask;

import org.apache.commons.collections.map.LinkedMap;
import org.springframework.data.elasticsearch.core.facet.result.IntervalUnit;

import vn.onepay.cache.dynacache.PassiveDynaMemoryCache;
import vn.onepay.search.entities.ESMO;
import vn.onepay.search.entities.FilteringMO;
import vn.onepay.search.service.ElasticSearchService;

public class WarningMOFixRateService extends TimerTask
{
  public static String CACHE_ERROR_MERCHANT = "errorMerchants";
  
	public void run() {
	  try {
      getValues();
    } catch (ParseException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
	  
		System.out.println("DemoTimerTask2 running at: "
				+ new Date(this.scheduledExecutionTime()));
	}
	
	public ElasticSearchService elasticSearchService;
	public PassiveDynaMemoryCache passiveDynaMemoryCache;
	
  public PassiveDynaMemoryCache getPassiveDynaMemoryCache() {
    return passiveDynaMemoryCache;
  }

  public void setPassiveDynaMemoryCache(PassiveDynaMemoryCache passiveDynaMemoryCache) {
    this.passiveDynaMemoryCache = passiveDynaMemoryCache;
  }

  public ElasticSearchService getElasticSearchService() {
    return elasticSearchService;
  }

  public void setElasticSearchService(ElasticSearchService elasticSearchService) {
    this.elasticSearchService = elasticSearchService;
  }
	private void getValues() throws ParseException{
	  //Get exist error merchants
    List<String> existSuspectMerchants = (List<String>)passiveDynaMemoryCache.getCachedItem(CACHE_ERROR_MERCHANT);
    
    List<String> fields = new ArrayList<String>();
    fields.add("merchant");
    
    //get data
	  @SuppressWarnings("unchecked")
    Map<String , List<String>> keywords = new LinkedMap();
	  List<String> timeRanges = Arrays.asList(new String[]{MOAnalyticController.handleDate("09/10/2014", false), MOAnalyticController.handleDate("09/10/2014", true)}); 
    if(timeRanges != null && timeRanges.size() > 0){
      String operator = "_operator_time_range";
      keywords.put("request_time" + operator, timeRanges);
    }
    
  	//List Object
    List<ESMO> dataList = new ArrayList<ESMO>();
    int count = 0;
    int facetSize = 20;
    
	  if(elasticSearchService.checkIndex(ESMO.class)){
	    count = elasticSearchService.count(fields, null, keywords, facetSize, ESMO.class);
	    dataList = elasticSearchService.search(fields, null, keywords, null, 0/*page*/, count/*limit*/, facetSize, ESMO.class);
	  }
	  
	  List<ESMO> sortedDataList = new ArrayList<ESMO>();
	  //histogram
    @SuppressWarnings("unchecked")
	  Map<String, List<IntervalUnit>> dataHistogramMap = new LinkedMap();
      
    int limit = -1;
    String fieldHistogram = "request_time";
		String fieldFilter = "msisdn";
		String operator = "_operator_term";
		
		sortedDataList = MOAnalyticController.handleSortWithSubscriberByCount(dataList, limit);
		
		List<FilteringMO> topMsisdns = new ArrayList<FilteringMO>();
		topMsisdns = MOAnalyticController.getTopMsisdn(sortedDataList, limit);
    
    // get histogram
    if(topMsisdns != null && topMsisdns.size() > 0){
      for(FilteringMO data : topMsisdns){
        //System.out.println("data.getMerchant(): " + data.getMerchant());
        
        keywords.put(fieldFilter + operator, Arrays.asList(new String[] { data.getMsisdn()}));
        dataHistogramMap.put(data.getMerchant()+"::"+ data.getMsisdn(), elasticSearchService.getHistogramFacet(fieldHistogram, fields, null, keywords, facetSize, ESMO.class));
        
      }
    }
    
    if(dataHistogramMap != null && dataHistogramMap.size() > 0){
      /*for(String key : dataHistogramMap.keySet()){
        System.out.println(key + " " + dataHistogramMap.get(key).get(0));
      }*/
      
      List<String> suspectMerchants = findSuspectMerchant(dataHistogramMap, LIMIT_ERROR, existSuspectMerchants);
      if(suspectMerchants != null && suspectMerchants.size() > 0){
        if(existSuspectMerchants == null || existSuspectMerchants.size() == 0)
          passiveDynaMemoryCache.setCachedItem(CACHE_ERROR_MERCHANT, suspectMerchants, 24*60*60);
        else{
          for(String merchant : suspectMerchants){
            existSuspectMerchants.add(merchant);
          }
          
          passiveDynaMemoryCache.updateCachedItem(CACHE_ERROR_MERCHANT, existSuspectMerchants);
        }
        
        for(String merchant : suspectMerchants){
          System.out.println("MERCHANT ERROR: " + merchant);
        }
      }
    }
			
	}
	
	public static int LIMIT_ERROR = 3;
	
	private List<String> findSuspectMerchant(Map<String, List<IntervalUnit>> dataHistogramMap, int limit, List<String> existSuspectMerchants){
	  List<String> suspectMerchants = new ArrayList<String>();
	  
	  if(dataHistogramMap != null && dataHistogramMap.size() > 0)
  	  for(String key : dataHistogramMap.keySet()){
  	    String merchant = key.substring(0, key.indexOf("::"));
  	    
  	    if(suspectMerchants.contains(merchant))
  	      continue;
  	    if(existSuspectMerchants != null && existSuspectMerchants.size() > 0){
  	      if(existSuspectMerchants.contains(merchant))
  	        continue;
  	    }
  	    
  	    System.out.println("key merchant: " + merchant);
  	    
  	    List<IntervalUnit> intervalUnits = dataHistogramMap.get(key);
  	    if(intervalUnits != null && intervalUnits.size() > 0)
    	    for(IntervalUnit iUnit : intervalUnits){
    	      if(iUnit.getCount() >= limit){
    	        suspectMerchants.add(merchant);
    	        break;
    	      }
    	        
    	    }
  	  }
	  
	  return suspectMerchants;
	}
	
}
