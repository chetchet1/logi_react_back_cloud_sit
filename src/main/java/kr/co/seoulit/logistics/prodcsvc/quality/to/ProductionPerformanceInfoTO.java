package kr.co.seoulit.logistics.prodcsvc.quality.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class ProductionPerformanceInfoTO {

	private String workOrderCompletionDate;
	private String workOrderNo;
	private String mpsNo;
	private String contractDetailNo;
	private String itemClassification;
	private String itemCode;
	private String itemName;
	private String unit;
	private String workOrderAmount;
	private String actualCompletionAmount;
	private String workSuccessRate;

}
