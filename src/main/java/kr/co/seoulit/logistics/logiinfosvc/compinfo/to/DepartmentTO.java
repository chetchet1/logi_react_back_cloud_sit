package kr.co.seoulit.logistics.logiinfosvc.compinfo.to;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class DepartmentTO extends BaseTO  {
	 private String workplaceName;
	 private String deptName;
	 private String deptCode;
	 private String workplaceCode;
	 private String companyCode;
	 private String deptEndDate;
	 private String deptStartDate;

}