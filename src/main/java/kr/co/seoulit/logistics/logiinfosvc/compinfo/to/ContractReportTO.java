package kr.co.seoulit.logistics.logiinfosvc.compinfo.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class ContractReportTO {

	private String contractNo;
	private String contractDate;
	private String itemCode;
	private String itemName;
	private String unitPriceOfContract;
	private String sumPriceOfContract;
	private String unitOfContract;
	private String contractAmount;
	private String businessLicenseNumber;
	private String customerName;
	private String customerCeo;
	private String customerBusinessConditions;
	private String customerBusinessItems;
	private String customerBasicAddress;
	private String tax;
	private String totalAmount;
	private String sumPrice;
	private String sumAmount;
	private String sumTax;
	private String sumTotalAmount;

}
