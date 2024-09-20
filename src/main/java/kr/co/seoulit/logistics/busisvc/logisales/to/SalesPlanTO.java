package kr.co.seoulit.logistics.busisvc.logisales.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class SalesPlanTO extends BaseTO {
	 private int unitPriceOfSales;
	 private int salesAmount;
	 private String salesPlanNo;
	 private String description;
	 private String salesPlanDate;
	 private int sumPriceOfSales;
	 private String itemCode;
	 private String dueDateOfSales;
	 private String unitOfSales;
	 private String mpsApplyStatus;
	 private String itemName;

}
