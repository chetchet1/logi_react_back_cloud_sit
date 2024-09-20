package kr.co.seoulit.logistics.purcstosvc.purchase.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class OrderTempTO {
	private String mrpGatheringNo;
	private String itemCode;
	private String itemName;
	private String unitOfMrp;
	private int requiredAmount;
	private int stockAmount;
	private String orderDate;
	private String requiredDate;

}
