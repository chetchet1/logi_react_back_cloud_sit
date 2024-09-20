package kr.co.seoulit.logistics.prodcsvc.production.to;

import java.util.ArrayList;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class MrpGatheringTO extends BaseTO {

	private String mrpGatheringNo;
	private String orderOrProductionStatus;
	private String itemCode;
	private String itemName;
	private String unitOfMrpGathering;
	private String claimDate;
	private String dueDate;
	private int necessaryAmount;
	private ArrayList<MrpTO> mrpTOList;
	private int mrpGatheringSeq;

}