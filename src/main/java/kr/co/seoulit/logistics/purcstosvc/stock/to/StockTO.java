package kr.co.seoulit.logistics.purcstosvc.stock.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class StockTO extends BaseTO {
	
	private String warehouseCode;
	private String itemCode;
	private String itemName;
	private String unitOfStock;
	private String safetyAllowanceAmount;
	private String stockAmount;
	private String orderAmount;
	private String inputAmount;
	private String deliveryAmount;
	private String totalStockAmount;

}
