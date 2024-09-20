package kr.co.seoulit.logistics.busisvc.logisales.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class DeliveryInfoTO extends BaseTO {

	private String deliveryNo;
	private String estimateNo;
	private String contractNo;
	private String contractDetailNo;
	private String customerCode;
	private String personCodeInCharge;
	private String itemCode;
	private String itemName;
	private String unitOfDelivery;
	private String deliveryAmount;
	private String unitPrice;
	private String sumPrice;
	private String deliverydate;
	private String deliveryPlaceName;

}
