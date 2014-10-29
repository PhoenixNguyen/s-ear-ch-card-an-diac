package vn.onepay.main.repositories;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import vn.onepay.search.entities.ESSMS;

public interface MySMSRepository extends ElasticsearchRepository<ESSMS,String>{

}
