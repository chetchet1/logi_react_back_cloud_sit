package kr.co.seoulit.logistics.prodcsvc.production.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class MpsTO extends BaseTO  {
	private String mpsPlanDate; //o
	private String mpsNo;
	private String contractDetailNo; //o
	private String dueDateOfMps;
	private String salesPlanNo;
	private String itemCode; //o
	private String itemName; //o
	private String mpsPlanAmount;
	private String mrpApplyStatus;
	private String description; //o
	private String unitOfMps;
	private String mpsPlanClassification;
	private String scheduledEndDate; //o

}