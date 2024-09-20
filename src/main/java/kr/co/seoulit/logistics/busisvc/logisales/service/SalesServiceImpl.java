package kr.co.seoulit.logistics.busisvc.logisales.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import kr.co.seoulit.logistics.busisvc.logisales.mapper.ContractMapper;
import kr.co.seoulit.logistics.busisvc.logisales.to.ContractInfoTO;
import kr.co.seoulit.logistics.busisvc.logisales.mapper.DeliveryMapper;
import kr.co.seoulit.logistics.busisvc.logisales.mapper.SalesPlanMapper;
import kr.co.seoulit.logistics.busisvc.logisales.to.DeliveryInfoTO;
import kr.co.seoulit.logistics.busisvc.logisales.to.SalesPlanTO;

@Service
public class SalesServiceImpl implements SalesService {

	@Autowired
	private ContractMapper contractMapper;
	@Autowired
	private SalesPlanMapper salesPlanMapper;
	@Autowired
	private DeliveryMapper deliveryMapper;



	@Override
	public ArrayList<ContractInfoTO> getDeliverableContractList(HashMap<String,String> ableSearchConditionInfo) {

		ArrayList<ContractInfoTO> deliverableContractList = null;

		deliverableContractList = contractMapper.selectDeliverableContractList(ableSearchConditionInfo);

		for (ContractInfoTO bean : deliverableContractList) { // 해당 수주의 수주상세 리스트 세팅

			bean.setContractDetailTOList(contractMapper.selectDeliverableContractDetailList(bean.getContractNo()));

		}

		return deliverableContractList;
	}

	@Override
	public ArrayList<SalesPlanTO> getSalesPlanList(String dateSearchCondition, String startDate, String endDate) {

		ArrayList<SalesPlanTO> salesPlanTOList = null;

		HashMap<String, String> map = new HashMap<>();

		map.put("dateSearchCondition", dateSearchCondition);
		map.put("startDate", startDate);
		map.put("endDate", endDate);

		salesPlanTOList = salesPlanMapper.selectSalesPlanList(map);

		return salesPlanTOList;
	}

	public String getNewSalesPlanNo(String salesPlanDate) {

		StringBuffer newEstimateNo = null;
		System.out.println("daate"+salesPlanDate);
		int newNo = salesPlanMapper.selectSalesPlanCount(salesPlanDate);
		System.out.println("intint"+newNo);

		newEstimateNo = new StringBuffer();

		newEstimateNo.append("SA");
		newEstimateNo.append(salesPlanDate.replace("-", ""));
		newEstimateNo.append(String.format("%02d", newNo)); // 2자리 숫자

		return newEstimateNo.toString();
	}

	@Override
	public ModelMap addNewSales(SalesPlanTO newSalesInfo) {
		ModelMap resultMap = null;
		System.out.println("@@@@@@@@@@@"+newSalesInfo);
		System.out.println("##############"+newSalesInfo.getSalesPlanNo());
		String newSalesPlanNo = getNewSalesPlanNo(newSalesInfo.getSalesPlanDate());
		newSalesInfo.setSalesPlanNo(newSalesPlanNo);
		System.out.println("####!!!!!"+newSalesInfo.getSalesPlanNo());
		salesPlanMapper.insertSalesPlan(newSalesInfo);
		return resultMap;
	}

	@Override
	public ModelMap removeSales(String salesplanNo) {
		System.out.println("여긴가"+salesplanNo);
		ModelMap resultMap = null;
		salesPlanMapper.deleteSalesPlan(salesplanNo);
		return resultMap;
	}



//	@Override
//	public ModelMap batchSalesPlanListProcess(ArrayList<SalesPlanTO> salesPlanTOList) {
//
//		ModelMap resultMap = new ModelMap();
//
//		ArrayList<String> insertList = new ArrayList<>();
//		ArrayList<String> updateList = new ArrayList<>();
//		ArrayList<String> deleteList = new ArrayList<>();
//
//		for (SalesPlanTO bean : salesPlanTOList) {
//
//			String status = bean.getStatus();
//
//			switch (status) {
//
//			case "INSERT":
//
//				String newSalesPlanNo = getNewSalesPlanNo(bean.getSalesPlanDate());
//
//				bean.setSalesPlanNo(newSalesPlanNo);
//
//				salesPlanMapper.insertSalesPlan(bean);
//
//				insertList.add(newSalesPlanNo);
//
//				break;
//
//			case "UPDATE":
//
//				salesPlanMapper.updateSalesPlan(bean);
//
//				updateList.add(bean.getSalesPlanNo());
//
//				break;
//
//			case "DELETE":
//
//				salesPlanMapper.deleteSalesPlan(bean);
//
//				deleteList.add(bean.getSalesPlanNo());
//
//				break;
//
//			}
//
//		}
//
//		resultMap.put("INSERT", insertList);
//		resultMap.put("UPDATE", updateList);
//		resultMap.put("DELETE", deleteList);
//
//		return resultMap;
//	}



	@Override
	public ArrayList<DeliveryInfoTO> getDeliveryInfoList() {

		ArrayList<DeliveryInfoTO> deliveryInfoList = null;

		deliveryInfoList = deliveryMapper.selectDeliveryInfoList();

		return deliveryInfoList;
	}

	@Override
	public ModelMap batchDeliveryListProcess(List<DeliveryInfoTO> deliveryTOList) {

		ModelMap resultMap = new ModelMap();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		for (DeliveryInfoTO bean : deliveryTOList) {

			String status = bean.getStatus();

			switch (status.toUpperCase()) {

				case "INSERT":

					String newDeliveryNo = "새로운";

					bean.setDeliveryNo(newDeliveryNo);
					deliveryMapper.insertDeliveryResult(bean);
					insertList.add(newDeliveryNo);

					break;

				case "UPDATE":

					deliveryMapper.updateDeliveryResult(bean);

					updateList.add(bean.getDeliveryNo());

					break;

				case "DELETE":

					deliveryMapper.deleteDeliveryResult(bean);

					deleteList.add(bean.getDeliveryNo());

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public ModelMap deliver(String contractDetailNo) {

		ModelMap resultMap = new ModelMap();

		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put("contractDetailNo", contractDetailNo);

		deliveryMapper.deliver(map);

		resultMap.put("errorCode", map.get("ERROR_CODE"));
		resultMap.put("errorMsg", map.get("ERROR_MSG"));

		return resultMap;
	}

}
