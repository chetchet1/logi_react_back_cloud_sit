package kr.co.seoulit.logistics.logiinfosvc.compinfo.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class CodeDetailTO extends BaseTO {
	
	private String divisionCodeNo;
	private String detailCode;
	private String detailCodeName;
	private String codeUseCheck;
	private String description;

}