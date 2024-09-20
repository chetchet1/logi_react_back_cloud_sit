package kr.co.seoulit.logistics.logiinfosvc.hr.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityGroupMenuTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityInfoGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeAuthorityTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.MenuAuthorityTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.MenuTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.UserMenuTO;

@Mapper
public interface AuthorityMapper {
	
	//AuthorityGroup
	public ArrayList<AuthorityGroupTO> selectUserAuthorityGroupList(String empCode);

	public ArrayList<AuthorityInfoGroupTO> selectAuthorityGroupList();
	
	public void insertEmployeeAuthorityGroup(EmployeeAuthorityTO bean);
	
	public void deleteEmployeeAuthorityGroup(String empCode);
	
	//MenuAuthority
	public void deleteMenuAuthority(String authorityGroupCode);
	
	public void insertMenuAuthority(MenuAuthorityTO bean);
	
	public ArrayList<MenuAuthorityTO> selectMenuAuthorityList(String authorityGroupCode);
	
	public ArrayList<AuthorityGroupMenuTO> selectUserMenuAuthorityList(String empCode);
	
	//Menu
	public ArrayList<MenuTO> selectAllMenuList();
	
	//UserMenu
	public HashMap<String, UserMenuTO> selectUserMenuCodeList(HashMap<String, String> map);

}
