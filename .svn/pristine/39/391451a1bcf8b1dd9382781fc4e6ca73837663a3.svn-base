package vn.onepay.main.repositories;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import vn.onepay.search.entities.ESSMS;


@Service
public class SMSService {
	
	@Resource
	MySMSRepository myMORepository;

	public MySMSRepository getMyMORepository() {
		return myMORepository;
	}

	public void setMyMORepository(MySMSRepository myMORepository) {
		this.myMORepository = myMORepository;
	}

	public void save(ESSMS object) {
		myMORepository.save(object);
    }
	
	public void bulkSave(List<ESSMS> objects) {
		myMORepository.save(objects);
    }
	
	public boolean checkExist(){
		return myMORepository.exists("id");
	}
	
	public void deleteAll(){
		myMORepository.deleteAll();
	}
}
