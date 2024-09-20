package kr.co.seoulit.logistics.logiinfosvc.compinfo.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class TodoTO {
	private String empName;
	private String empCode;
	private String be;
	private String ing;
	private String done;
	private String updateDate;
	private String mag;
	private String contentStatus;
	private String todoNum;

}
