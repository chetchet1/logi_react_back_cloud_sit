package kr.co.seoulit.logistics.prodcsvc.quality.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import kr.co.seoulit.logistics.prodcsvc.quality.to.WorkSiteLog;
import kr.co.seoulit.logistics.prodcsvc.quality.to.ProductionPerformanceInfoTO;
import kr.co.seoulit.logistics.prodcsvc.quality.to.WorkOrderInfoTO;

@Mapper
public interface WorkOrderMapper {

	public void getWorkOrderableMrpList(HashMap<String, Object> map);

//	public void getWorkOrderSimulationList(HashMap<String, Object> map);

	public void getWorkOrderSimulationList(HashMap<String, Object> map);

	public void workOrder(HashMap<String, String> map);

	public ArrayList<WorkOrderInfoTO> selectWorkOrderInfoList();

	public void workOrderCompletion(HashMap<String, Object> map);

	public ArrayList<ProductionPerformanceInfoTO> selectProductionPerformanceInfoList();

	public void selectWorkSiteSituation(HashMap<String, Object> map);

	public void updateWorkCompletionStatus(HashMap<String, Object> param);

	public ArrayList<WorkSiteLog> workSiteLogList(HashMap<String, String> param);

	public void updateWorkCompletionStatusString(HashMap<String, String> map);
}
