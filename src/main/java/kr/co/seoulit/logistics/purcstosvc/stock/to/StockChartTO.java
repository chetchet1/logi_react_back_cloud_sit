package kr.co.seoulit.logistics.purcstosvc.stock.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class StockChartTO extends BaseTO {
	
	private String itemName;
	private String stockAmount;
	private String saftyAmount;
	private String allowanceAmount;

}
