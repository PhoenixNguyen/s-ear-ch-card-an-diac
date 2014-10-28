package vn.onepay.main.repositories;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import vn.onepay.search.entities.ESMO;

public interface MyMORepository extends ElasticsearchRepository<ESMO,String>{

}
