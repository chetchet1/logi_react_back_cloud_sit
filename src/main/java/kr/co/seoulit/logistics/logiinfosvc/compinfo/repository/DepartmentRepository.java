package kr.co.seoulit.logistics.logiinfosvc.compinfo.repository;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.DepartmentEntity;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.DepartmentPK;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;

@Repository
public interface DepartmentRepository extends CrudRepository<DepartmentEntity, DepartmentPK> {

    public ArrayList<DepartmentEntity> findByCompanyCode(String companyCode);

    public ArrayList<DepartmentEntity> findByWorkplaceCode(String workplaceCode);
}
