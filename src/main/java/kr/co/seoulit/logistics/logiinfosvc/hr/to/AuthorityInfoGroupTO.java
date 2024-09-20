package kr.co.seoulit.logistics.logiinfosvc.hr.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class AuthorityInfoGroupTO {
	private String authorityGroupCode;
	private String authorityGroupName;

}
