package kr.co.seoulit.logistics.purcstosvc.purchase.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.ui.ModelMap;

import kr.co.seoulit.logistics.purcstosvc.purchase.to.OrderInfoTO;

@Mapper
public interface OrderMapper {
	
	public void getOrderList(HashMap<String, Object> map);
	 
	public void getOrderDialogInfo(HashMap<String, String> map);
	 
	 public ArrayList<OrderInfoTO> getOrderInfoListOnDelivery();
	 
	 public ArrayList<OrderInfoTO> getOrderInfoList(HashMap<String, String> map);

	 public void order(HashMap<String, String> map);
	 
	 public ModelMap optionOrder(HashMap<String, String> map);

	 public void updateOrderInfo(HashMap<String, String> map);

}
