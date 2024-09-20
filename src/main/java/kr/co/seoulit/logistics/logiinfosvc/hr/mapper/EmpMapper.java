package kr.co.seoulit.logistics.logiinfosvc.hr.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmpInfoTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeBasicTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeDetailTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeSecretTO;

@Mapper
public interface EmpMapper {

	//EmployeeBasic
	public ArrayList<EmployeeBasicTO> selectEmployeeBasicList(String companyCode);
	
	public EmployeeBasicTO selectEmployeeBasicTO(HashMap<String, String> map);
	
	public void insertEmployeeBasic(EmployeeBasicTO TO);
	
	public void changeUserAccountStatus(HashMap<String, String> map);
	
	//EmployeeDetail
	public ArrayList<EmployeeDetailTO> selectEmployeeDetailList(HashMap<String, String> map);
	
	public ArrayList<EmployeeDetailTO> selectUserIdList(String companyCode);
	
	public void insertEmployeeDetail(EmployeeDetailTO TO);
	
	//EmployeeSecret
	public ArrayList<EmployeeSecretTO> selectEmployeeSecretList(HashMap<String, String> map);

	public EmployeeSecretTO selectUserPassWord(HashMap<String, String> map);

	public void insertEmployeeSecret(EmployeeSecretTO TO);
	
	public int selectUserPassWordCount(HashMap<String, String> map);

	//EmpSearching
	public ArrayList<EmpInfoTO> selectAllEmpList(HashMap<String, String> map);

	public ArrayList<EmpInfoTO> getTotalEmpInfo(HashMap<String, String> map);
	
}
