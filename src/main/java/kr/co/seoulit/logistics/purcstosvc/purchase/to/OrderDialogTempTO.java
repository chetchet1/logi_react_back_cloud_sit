package kr.co.seoulit.logistics.purcstosvc.purchase.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class OrderDialogTempTO {
	
	private String mrpGatheringNo;
	private String itemCode;
	private String itemName;
	private String unitOfMrp;
	private String requiredAmount;
	private String stockAmount;
	private String calculatedRequiredAmount;
	private String standardUnitPrice;
	private String sumPrice;

}
