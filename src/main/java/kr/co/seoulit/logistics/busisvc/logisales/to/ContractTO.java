package kr.co.seoulit.logistics.busisvc.logisales.to;

import java.util.ArrayList;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class ContractTO extends BaseTO {
	private String contractType;
	private String estimateNo;
	private String contractDate;
	private String description;
	private String contractRequester;
	private String customerCode;
	private String personCodeInCharge;
	private String contractNo;
	private ArrayList<ContractDetailTO> contractDetailTOList;

}
