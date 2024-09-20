package kr.co.seoulit.logistics.logiinfosvc.compinfo.repository;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.CodeDetailEntity;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.CodeDetailPK;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;

@Repository
public interface CodeDetailRepository extends CrudRepository<CodeDetailEntity, CodeDetailPK> {
    public ArrayList<CodeDetailEntity> findByDivisionCodeNoLike(String divisionCode);
}
