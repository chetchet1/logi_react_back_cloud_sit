package kr.co.seoulit.logistics.logiinfosvc.hr.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class EmployeeAuthorityTO {
	private String empCode;
	private String authorityGroupCode;
}
