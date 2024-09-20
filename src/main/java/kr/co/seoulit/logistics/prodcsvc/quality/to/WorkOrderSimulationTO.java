package kr.co.seoulit.logistics.prodcsvc.quality.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class WorkOrderSimulationTO {

	private String mrpNo;
	private String mpsNo;
	private String mrpGatheringNo;
	private String itemClassification;
	private String itemCode;
	private String itemName;
	private String unitOfMrp;
	private String inputAmount;
	private String requiredAmount;
	private String stockAfterWork;
	private String orderDate;
	private String requiredDate;

}
