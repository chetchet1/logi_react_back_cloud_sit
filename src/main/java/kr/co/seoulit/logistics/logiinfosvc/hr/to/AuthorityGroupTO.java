package kr.co.seoulit.logistics.logiinfosvc.hr.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class AuthorityGroupTO {
	private String authorityGroupCode;
	private String authorityGroupName;
	private String authority;
	private String userAuthorityGroupCode;
}
