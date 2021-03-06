package vn.onepay.main;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.data.mongodb.core.MongoTemplate;

import vn.onepay.main.repositories.SMSService;
import vn.onepay.search.entities.ESSMS;
import vn.onepay.sms.model.SMS;
import vn.onepay.utils.Utils;

public class Main {
	public static void main(String [] args){
		Main main = new Main();
		
		//Use template
		//main.cardIndexTemplate();
		
		//Use Repository
		main.moIndexRepository();
		
	}

	private void moIndexRepository() {
		@SuppressWarnings("resource")
		ApplicationContext ctx1 = new ClassPathXmlApplicationContext("/vn/onepay/main/elastic-repository-config.xml");
		SMSService myMOService = (SMSService)ctx1.getBean("myMOService");
		
		ElasticsearchTemplate elasticsearchTemplate = (ElasticsearchTemplate) ctx1.getBean("elasticsearchTemplate");
		
		@SuppressWarnings("resource")
		ApplicationContext ctx = new ClassPathXmlApplicationContext("/vn/onepay/main/mongo-config.xml");
		MongoTemplate mongoTemplate = (MongoTemplate) ctx.getBean("mongoTemplate");
		
		//List<CardCdr> cardCdrList = cardCdrDAO.findAllCardCdrs();
		List<SMS> mos = mongoTemplate.findAll(SMS.class);
	    if ((mos != null) && (mos.size() > 0)) {
	      for (SMS mo : mos) {
	    	  mo.setRequest_time(Utils.mongoDbTimeToDisplayTime(mo.getRequest_time()));
	      }
	    }
	    
	  	if(mos == null || mos.size() == 0){
  		  return;
  	    }
	  	
	  	System.out.println("Size: " + mos.size());
	  	
	  	//delete all data
	  	myMOService.deleteAll();
	  	
	  	//delete index
	  	elasticsearchTemplate.deleteIndex(ESSMS.class);
	  	
	    //INDEX
	    if(!elasticsearchTemplate.indexExists(ESSMS.class)){
    	  System.out.println("Dang danh chi muc ...");
    	  
    	  List<String> provider = Arrays.asList(new String[]{"mwork", "ngan_luong", "homedirect", "vdconline"});
    	  
    	  List<ESSMS> objList = new ArrayList<ESSMS>();
    	  List<String> ids = new ArrayList<String>();
    	  for(SMS mo : mos){
    		  ids.add(mo.getId());
    		  objList.add(new ESSMS(mo.getId(), mo.getCp_code(), mo.getContent_id(), getRandomList(provider), mo.getTelco(), 
    				  mo.getMsisdn(), mo.getAmount(), mo.getGame_code(), 
    				  "9029", mo.getMo_message(), mo.getRequest_time()));
    		  
	  	  }
    	  
    	  //cardCdrService.bulkSave(objList); too much
    	  int MAX = 100000;
    	  int times = objList.size()/MAX;
    	  for(int i = 0; i <= times; i++){
    		  
    		  if( i != times){
    			  System.out.println("Danh chi muc lan " + (i + 1) + " tu " + i * MAX + " den " + (MAX*(i+1) - 1) + " ...");
    			  myMOService.bulkSave(objList.subList(i * MAX, MAX*(i+1)));
    		  }
    		  else{
    			  System.out.println("Danh chi muc lan " + (i + 1) + " tu " + i * MAX + " den " + (objList.size() - 1) + " ...");
    			  myMOService.bulkSave(objList.subList(i * MAX, objList.size()));
    		  }
    		  
    		  System.out.println("		Hoan thanh lan " + (i + 1));
    	  }
    	  
    	  System.out.println("Hoan thanh tat ca");
	    }
	    else{
    	  System.out.println("Da ton tai chi muc");
        }
	}
	
	private Random random = new Random();
	private String getRandomList(List<String> list) {
	    int index = random.nextInt(list.size());
	    //System.out.println("\nIndex :" + index );
	    return list.get(index);
	}
	
//	private void cardIndexTemplate() {
//		ApplicationContext ctx1 = new ClassPathXmlApplicationContext("/vn/onepay/search/resources/elastic-config.xml");
//		ElasticSearch elasticSearch = (ElasticSearch) ctx1.getBean("elasticSearch");
//		
//		ApplicationContext ctx = new ClassPathXmlApplicationContext("/main/mongo-config.xml");
//		CardCdrDAO cardCdrDAO= (CardCdrDAO) ctx.getBean("cardCdrDAO");
//		
//		List<CardCdr> cardCdrList = cardCdrDAO.findAllCardCdrs();
//  	  
//	  	  if(cardCdrList != null){
//	  		  System.out.println("Size: " + cardCdrList.size());
//	  	  }
//	  	  
//		  elasticSearch.deleteIndex(vn.onepay.search.entities.CardCdr.class);
//	      //INDEX
//	      if(!elasticSearch.checkIndex(vn.onepay.search.entities.CardCdr.class) ){
//	    	  System.out.println("Dang danh chi muc ...");
//	    	  //cardCdrElasticSearch.deleteIndex();
//	    	  //List<CardCdr> cardCdrList = cardCdrDAO.findAllCardCdrs();
//	    	  
//	    	  if(cardCdrList != null){
//	    		  System.out.println("Size: " + cardCdrList.size());
//	    	  }
//	    	  if(cardCdrList == null || cardCdrList.size() == 0){
//	    		  return;
//	    	  }
//	    	  
//	    	  List<vn.onepay.search.entities.CardCdr> objList = new ArrayList<vn.onepay.search.entities.CardCdr>();
//	    	  List<String> ids = new ArrayList<String>();
//	    	  for(CardCdr card : cardCdrList){
//	    		  ids.add(card.getId());
//	    		  objList.add(new vn.onepay.search.entities.CardCdr(card.getId(), card.getAmount(), card.getMerchant(), card.getPaymentProvider(),
//	    				  card.getApp_code(), card.getPin(), card.getSerial(), card.getType(), 
//	    				  card.getStatus(), card.getMessage(), card.getTimestamp(), card.getExtractStatus()));
//	    		  
//	    	  }
//	    	  
//	    	  for(int i = 0; i <= objList.size()/20000; i++){
//	    		  System.out.println("Danh chi muc lan " + (i + 1));
//	    		  elasticSearch.bulkIndex(ids, objList.subList(i, 20000*(i+1)));
//	    	  }
//	    	  
//	    	  
//	    	  System.out.println("Hoan thanh");
//	      }
//	      else{
//	    	  System.out.println("Da ton tai chi muc");
//	      }
//		
//	}
}
