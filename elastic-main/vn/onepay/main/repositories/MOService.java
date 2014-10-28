package vn.onepay.main.repositories;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import vn.onepay.search.entities.ESMO;


@Service
public class MOService {
	
	@Resource
	MyMORepository myMORepository;

	public MyMORepository getMyMORepository() {
		return myMORepository;
	}

	public void setMyMORepository(MyMORepository myMORepository) {
		this.myMORepository = myMORepository;
	}

	public void save(ESMO object) {
		myMORepository.save(object);
    }
	
	public void bulkSave(List<ESMO> objects) {
		myMORepository.save(objects);
    }
	
	public boolean checkExist(){
		return myMORepository.exists("id");
	}
	
	public void deleteAll(){
		myMORepository.deleteAll();
	}
}
