package kr.co.seoulit.logistics.prodcsvc.production.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class SalesPlanInMpsAvailableTO extends BaseTO {
	 
	 private String salesPlanNo;
	 private String planClassification;
	 private String itemCode;
	 private String itemName;
	 private String unitOfSales;
	 private String salesPlanDate;
	 private String mpsPlanDate;
	 private String scheduledEndDate;
	 private String dueDateOfSales;
	 private String salesAmount;
	 private int unitPriceOfSales;
	 private int sumPriceOfSales;
	 private String mpsApplyStatus;
	 private String description;

}