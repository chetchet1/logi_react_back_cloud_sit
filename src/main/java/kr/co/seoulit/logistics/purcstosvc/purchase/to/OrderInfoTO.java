package kr.co.seoulit.logistics.purcstosvc.purchase.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class OrderInfoTO {
	
	private String orderNo;
	private String orderDate;
	private String orderInfoStatus;
	private String orderSort;
	private String itemCode;
	private String itemName;
	private String orderAmount;
	private String inspectionStatus;

}
