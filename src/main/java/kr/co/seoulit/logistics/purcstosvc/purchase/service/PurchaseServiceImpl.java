package kr.co.seoulit.logistics.purcstosvc.purchase.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import kr.co.seoulit.logistics.purcstosvc.purchase.mapper.OrderMapper;
import kr.co.seoulit.logistics.purcstosvc.purchase.mapper.OutSourcingMapper;
import kr.co.seoulit.logistics.purcstosvc.purchase.to.OrderInfoTO;
import kr.co.seoulit.logistics.purcstosvc.purchase.to.OutSourcingTO;

@Service
public class PurchaseServiceImpl implements PurchaseService{

	@Autowired
	private OutSourcingMapper outSourcingMapper;
	@Autowired
	private OrderMapper orderMapper;
	
	@Override
	public ArrayList<OutSourcingTO> searchOutSourcingList(String fromDate, String toDate, String customerCode,
			String itemCode, String materialStatus) {

		ArrayList<OutSourcingTO> OutSourcingList = null;
		
		HashMap<String, String> map = new HashMap<>();

		map.put("fromDate", fromDate);
		map.put("toDate", toDate);
		map.put("customerCode", customerCode);
		map.put("itemCode", itemCode);
		map.put("materialStatus", materialStatus);

		OutSourcingList = outSourcingMapper.selectOutSourcingList(map);

		return OutSourcingList;
	}

	@Override
	public HashMap<String,Object> getOrderList(String startDate, String endDate) {

		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		
		orderMapper.getOrderList(map);
		
		HashMap<String, Object> resultMap = new HashMap<>();
		
		resultMap.put("gridRowJson", map.get("RESULT"));
		resultMap.put("errorCode",map.get("ERROR_CODE"));
		resultMap.put("errorMsg", map.get("ERROR_MSG"));

		return resultMap;
	}

	@Override
	public HashMap<String,Object> getOrderDialogInfo(String mrpNoArr) {
		
		HashMap<String,Object> resultMap = new HashMap<>();

		String mrpNoList = mrpNoArr.replace("[", "").replace("]", "").replace("\"", "");
		
		HashMap<String, String> map = new HashMap<String, String>();
		
		map.put("mrpNoList", mrpNoList);
		
		orderMapper.getOrderDialogInfo(map);
		
		resultMap.put("gridRowJson", map.get("RESULT"));
		resultMap.put("errorCode", map.get("ERROR_CODE"));
		resultMap.put("errorMsg", map.get("ERROR_MSG"));

		return resultMap;

	}

	@Override
	public ModelMap order(ArrayList<String> mrpGaNoArr) {

		String mpsNoList = mrpGaNoArr.toString().replace("[", "").replace("]", "");
		
		HashMap<String, String> map = new HashMap<String, String>();
		
		map.put("mpsNoList", mpsNoList);
		
		orderMapper.order(map);
		
		ModelMap resultMap = new ModelMap();
		
		resultMap.put("gridRowJson", map.get("RESULT"));
		resultMap.put("errorCode", map.get("ERROR_CODE"));
		resultMap.put("errorMsg", map.get("ERROR_MSG"));

    	return resultMap;

	}

	@Override
	public ModelMap optionOrder(String itemCode, String itemAmount) {

		ModelMap resultMap = null;
		
		HashMap<String, String> map = new HashMap<>();

		map.put("itemCode", itemCode);
		map.put("itemAmount", itemAmount);


		resultMap = orderMapper.optionOrder(map);

		return resultMap;

	}

	@Override
	public ArrayList<OrderInfoTO> getOrderInfoListOnDelivery() {

		ArrayList<OrderInfoTO> orderInfoListOnDelivery = null;

		orderInfoListOnDelivery = orderMapper.getOrderInfoListOnDelivery();

		return orderInfoListOnDelivery;

	}

	@Override
	public ArrayList<OrderInfoTO> getOrderInfoList(String startDate, String endDate) {

		ArrayList<OrderInfoTO> orderInfoList = null;
		
		HashMap<String, String> map = new HashMap<>();

		map.put("startDate", startDate);
		map.put("endDate", endDate);


		orderInfoList = orderMapper.getOrderInfoList(map);

		return orderInfoList;

	}

	@Override
	public ModelMap checkOrderInfo(ArrayList<String> orderNoArr) {
		
		String orderNoList = orderNoArr.toString().replace("[", "").replace("]", "");

		ModelMap resultMap = new ModelMap();
		
		HashMap<String, String> map = new HashMap<String, String>();
		
		map.put("orderNoList", orderNoList);
		
		orderMapper.updateOrderInfo(map);

		resultMap.put("gridRowJson", map.get("RESULT"));
		resultMap.put("errorCode", map.get("ERROR_CODE"));
		resultMap.put("errorMsg", map.get("ERROR_MSG"));

		return resultMap;
	}

}
