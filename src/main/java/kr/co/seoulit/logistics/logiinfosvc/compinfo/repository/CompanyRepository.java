package kr.co.seoulit.logistics.logiinfosvc.compinfo.repository;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.CompanyEntity;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.WorkplaceEntity;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;

@Repository
public interface CompanyRepository extends CrudRepository<CompanyEntity, String> {

    ArrayList<CompanyEntity> findAllBy();
}
