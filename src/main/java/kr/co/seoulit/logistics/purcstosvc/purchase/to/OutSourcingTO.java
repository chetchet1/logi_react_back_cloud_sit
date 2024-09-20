package kr.co.seoulit.logistics.purcstosvc.purchase.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class OutSourcingTO {
	private String outsourcingNo;
	private String materialStatus;
	private String customerCode;
	private String instructDate;
	private String completeDate;
	private String itemCode;
	private String itemName;
	private String instructAmount;
	private String completeStatus;
	private String checkStatus;
	private String unitPrice;
	private String totalPrice;
	private String outsourcingDate;
	private String customerName;

}
