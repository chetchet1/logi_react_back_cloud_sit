package kr.co.seoulit.logistics.logiinfosvc.hr.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class MenuTO {
	private String menuCode;
	private String parentMenuCode;
	private String menuName;
	private String menuLevel;
	private String menuURL;
	private String menuStatus;
	private String childMenu;
	private String navMenu;
	private String navMenuName;
}
