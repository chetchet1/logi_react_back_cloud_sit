package kr.co.seoulit.logistics.prodcsvc.production.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class MrpInsertInfoTO {
	private String firstMrpNo;
	private String lastMrpNo;
	private String length;

}
