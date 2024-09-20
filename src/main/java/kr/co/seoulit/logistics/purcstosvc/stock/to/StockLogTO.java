package kr.co.seoulit.logistics.purcstosvc.stock.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class StockLogTO {
	
	private String logDate;
	private String itemCode;
	private String itemName;
	private String amount;
	private String reason;
	private String cause;
	private String effect;

}
