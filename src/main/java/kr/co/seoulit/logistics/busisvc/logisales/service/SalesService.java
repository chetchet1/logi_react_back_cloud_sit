package kr.co.seoulit.logistics.busisvc.logisales.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.ui.ModelMap;

import kr.co.seoulit.logistics.busisvc.logisales.to.ContractInfoTO;
import kr.co.seoulit.logistics.busisvc.logisales.to.DeliveryInfoTO;
import kr.co.seoulit.logistics.busisvc.logisales.to.SalesPlanTO;

public interface SalesService {

	// SalesPlanApplicationServiceImpl
	public ArrayList<ContractInfoTO> getDeliverableContractList(HashMap<String,String> ableSearchConditionInfo);

	public ArrayList<SalesPlanTO> getSalesPlanList(String dateSearchCondition, String startDate, String endDate);

//	public HashMap<String, Object> batchSalesPlanListProcess(ArrayList<SalesPlanTO> salesPlanTOList);

	public HashMap<String, Object> batchDeliveryListProcess(List<DeliveryInfoTO> deliveryTOList);



	public ModelMap addNewSales(SalesPlanTO newSalesInfo);

	public ModelMap removeSales(String salesplanNo);

	public ModelMap deliver(String contractDetailNo);

	public ArrayList<DeliveryInfoTO> getDeliveryInfoList();

}
