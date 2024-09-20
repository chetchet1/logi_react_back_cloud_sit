package kr.co.seoulit.logistics.logiinfosvc.hr.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class EmployeeSecretTO extends BaseTO {
	
	 private String companyCode;
	 private String empCode;
	 private int seq;
	 private String userPassword;

}