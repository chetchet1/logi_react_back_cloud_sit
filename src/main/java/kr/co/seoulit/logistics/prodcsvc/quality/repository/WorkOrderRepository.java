package kr.co.seoulit.logistics.prodcsvc.quality.repository;

import kr.co.seoulit.logistics.prodcsvc.quality.Entity.WorkOrderEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WorkOrderRepository extends JpaRepository<WorkOrderEntity, Long>{

}
