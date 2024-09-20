package kr.co.seoulit.logistics.logiinfosvc.hr.service;

import java.util.ArrayList;

import org.springframework.ui.ModelMap;

import kr.co.seoulit.logistics.logiinfosvc.hr.exception.IdNotFoundException;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.PwMissMatchException;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.PwNotFoundException;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityInfoGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmpInfoTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeAuthorityTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeBasicTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeDetailTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeSecretTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.MenuAuthorityTO;

public interface HRService {

	public ArrayList<EmpInfoTO> getAllEmpList(String searchCondition, String[] paramArray);

	public EmpInfoTO getEmpInfo(String companyCode, String empCode);

	public String getNewEmpCode(String companyCode);
	
	public Boolean checkEmpCodeDuplication(String companyCode, String newEmpCode);
	
	public Boolean checkUserIdDuplication(String companyCode, String newUserId);
	
	public ModelMap batchEmpBasicListProcess(ArrayList<EmployeeBasicTO> empBasicList);

	public ModelMap batchEmpDetailListProcess(ArrayList<EmployeeDetailTO> empDetailList);
	
	public ModelMap batchEmpSecretListProcess(ArrayList<EmployeeSecretTO> empSecretList);
	
	//권한
	public EmpInfoTO accessToAuthority(String companyCode, String workplaceCode, String inputId, String inputPassWord)
			throws IdNotFoundException, PwMissMatchException, PwNotFoundException;

	public String[] getAllMenuList();

	public ArrayList<AuthorityGroupTO> getUserAuthorityGroup(String empCode);
	
	public ArrayList<AuthorityInfoGroupTO> getAuthorityGroup();

	public ArrayList<MenuAuthorityTO> getMenuAuthority(String authorityGroupCode);
	
	public void insertEmployeeAuthorityGroup(String empCode, ArrayList<EmployeeAuthorityTO> employeeAuthorityTOList);
	
	public void insertMenuAuthority(String authorityGroupCode, ArrayList<MenuAuthorityTO> menuAuthorityTOList);
	
}
