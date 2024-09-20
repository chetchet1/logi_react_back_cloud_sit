package kr.co.seoulit.logistics.prodcsvc.quality.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

@Data
@EqualsAndHashCode(callSuper = false)
public class WorkOrderInfoTO implements Serializable {

	private String workOrderNo;
	private String mrpGatheringNo;
	private String mrpNo;
	private String mpsNo;
	private String itemClassification;
	private String itemCode;
	private String itemName;
	private String unitOfMrp;
	private String requiredAmount;
	private String workSiteCode;
	private String workSiteName;
	private String productionProcessCode;
	private String productionProcessName;
	private String inspectionStatus;
	private String productionStatus;
	private String completionStatus;
	private String operaioncompleted;

}
