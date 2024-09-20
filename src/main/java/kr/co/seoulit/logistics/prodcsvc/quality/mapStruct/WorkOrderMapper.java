package kr.co.seoulit.logistics.prodcsvc.quality.mapStruct;


import kr.co.seoulit.logistics.prodcsvc.quality.Entity.WorkOrderEntity;
import kr.co.seoulit.logistics.prodcsvc.quality.to.WorkOrderInfoTO;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface WorkOrderMapper {
    WorkOrderMapper INSTANCE = Mappers.getMapper(WorkOrderMapper.class);
    WorkOrderInfoTO entitiyToDTO(WorkOrderEntity workOrderEntity);
}
