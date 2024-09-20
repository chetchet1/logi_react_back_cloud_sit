package kr.co.seoulit.logistics.logiinfosvc.hr.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.mapper.CodeMapper;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CodeDetailTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.IdNotFoundException;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.PwMissMatchException;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.PwNotFoundException;
import kr.co.seoulit.logistics.logiinfosvc.hr.mapper.AuthorityMapper;
import kr.co.seoulit.logistics.logiinfosvc.hr.mapper.EmpMapper;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityGroupMenuTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityInfoGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmpInfoTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeAuthorityTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeBasicTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeDetailTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeSecretTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.MenuAuthorityTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.MenuTO;

@Service
public class HRServiceImpl implements HRService {
	
	@Autowired
	private EmpMapper empMapper;
	@Autowired
	private CodeMapper codeMapper;
	@Autowired
	private AuthorityMapper authorityMapper;

	@Override
	public ArrayList<EmpInfoTO> getAllEmpList(String searchCondition, String[] paramArray) {

		ArrayList<EmpInfoTO> empList = null;
		
		HashMap<String, String> map = new HashMap<>();
		HashMap<String, String> map1 = new HashMap<>();
		
		map.put("searchCondition", searchCondition);
		for(int a=0; a<paramArray.length; a++) {
			switch (a + "") {
				case "0":
					map.put("companyCode", paramArray[0]);
					break;
				case "1":
					map.put("workplaceCode", paramArray[1]);
					break;
				case "2":
					map.put("deptCode", paramArray[2]);
					break;
			}
		}

		empList = empMapper.selectAllEmpList(map);

		for (EmpInfoTO bean : empList) {
			
			String companyCode = bean.getCompanyCode();
			String empCode = bean.getEmpCode();
			
			map1.put("companyCode", companyCode);
			map1.put("empCode", empCode);

			bean.setEmpDetailTOList(
					empMapper.selectEmployeeDetailList(map));

			bean.setEmpSecretTOList(
					empMapper.selectEmployeeSecretList(map));

		}

		return empList;
	}

	@Override
	public EmpInfoTO getEmpInfo(String companyCode, String empCode) {

		EmpInfoTO TO = new EmpInfoTO();
		
		HashMap<String, String> map = new HashMap<>();

		map.put("companyCode", companyCode);
		map.put("empCode", empCode);
		
		ArrayList<EmployeeDetailTO> empDetailTOList = empMapper.selectEmployeeDetailList(map);

		ArrayList<EmployeeSecretTO> empSecretTOList = empMapper.selectEmployeeSecretList(map);

		TO.setEmpDetailTOList(empDetailTOList);
		TO.setEmpSecretTOList(empSecretTOList);

		EmployeeBasicTO basicTo = empMapper.selectEmployeeBasicTO(map);

		if (basicTo != null) {

			TO.setCompanyCode(companyCode);
			TO.setEmpCode(empCode);
			TO.setEmpName(basicTo.getEmpName());
			TO.setEmpEngName(basicTo.getEmpEngName());
			TO.setSocialSecurityNumber(basicTo.getSocialSecurityNumber());
			TO.setHireDate(basicTo.getHireDate());
			TO.setRetirementDate(basicTo.getRetirementDate());
			TO.setUserOrNot(basicTo.getUserOrNot());
			TO.setBirthDate(basicTo.getBirthDate());
			TO.setGender(basicTo.getGender());

		}

		return TO;
	}

	@Override
	public String getNewEmpCode(String companyCode) {

		ArrayList<EmployeeBasicTO> empBasicList = null;
		String newEmpCode = null;

		empBasicList = empMapper.selectEmployeeBasicList(companyCode);

		TreeSet<Integer> empCodeNoSet = new TreeSet<>();

		for (EmployeeBasicTO TO : empBasicList) {

			if (TO.getEmpCode().startsWith("EMP-")) {

				try {

					Integer no = Integer.parseInt(TO.getEmpCode().split("EMP-")[1]);
					empCodeNoSet.add(no);

				} catch (NumberFormatException e) {

				}

			}

		}

		if (empCodeNoSet.isEmpty()) {
			newEmpCode = "EMP-" + String.format("%03d", 1);
		} else {
			newEmpCode = "EMP-" + String.format("%03d", empCodeNoSet.pollLast() + 1);
		}

		return newEmpCode;
	}

	@Override
	public ModelMap batchEmpBasicListProcess(ArrayList<EmployeeBasicTO> empBasicList) {

		ModelMap resultMap = new ModelMap();
		
		ArrayList<String> insertList = new ArrayList<>();
		// ArrayList<String> updateList = new ArrayList<>();
		// ArrayList<String> deleteList = new ArrayList<>();

		CodeDetailTO detailCodeTO = new CodeDetailTO();

		for (EmployeeBasicTO TO : empBasicList) {

			String status = TO.getStatus();

			switch (status) {

			case "INSERT":

				empMapper.insertEmployeeBasic(TO);

				insertList.add(TO.getEmpCode());

				detailCodeTO.setDivisionCodeNo("HR-02");
				detailCodeTO.setDetailCode(TO.getEmpCode());
				detailCodeTO.setDetailCodeName(TO.getEmpEngName());

				codeMapper.insertDetailCode(detailCodeTO);

				break;

			}

		}

		resultMap.put("INSERT", insertList);
		// resultMap.put("UPDATE", updateList);
		// resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public ModelMap batchEmpDetailListProcess(ArrayList<EmployeeDetailTO> empDetailList) {

		ModelMap resultMap = new ModelMap();

		ArrayList<String> insertList = new ArrayList<>();
		// ArrayList<String> updateList = new ArrayList<>();
		// ArrayList<String> deleteList = new ArrayList<>();

		for (EmployeeDetailTO bean : empDetailList) {

			String status = bean.getStatus();

			switch (status) {

			case "INSERT":

				empMapper.insertEmployeeDetail(bean);
				insertList.add(bean.getEmpCode());

				if (bean.getUpdateHistory().equals("계정 정지")) {

					changeEmpAccountUserStatus(bean.getCompanyCode(), bean.getEmpCode(), "N");
					
					String companyCode = bean.getCompanyCode();
					String empCode = bean.getEmpCode();
					
					HashMap<String, String> map = new HashMap<>();

					map.put("companyCode", companyCode);
					map.put("empCode", empCode);

					int newSeq = empMapper.selectUserPassWordCount(map);

					EmployeeSecretTO newSecretBean = new EmployeeSecretTO();

					newSecretBean.setCompanyCode(companyCode);
					newSecretBean.setEmpCode(empCode);
					newSecretBean.setSeq(newSeq);

					empMapper.insertEmployeeSecret(newSecretBean);

				}

				break;

			}

		}

		resultMap.put("INSERT", insertList);
		// resultMap.put("UPDATE", updateList);
		// resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public ModelMap batchEmpSecretListProcess(ArrayList<EmployeeSecretTO> empSecretList) {

		ModelMap resultMap = new ModelMap();

		ArrayList<String> insertList = new ArrayList<>();
		// ArrayList<String> updateList = new ArrayList<>();
		// ArrayList<String> deleteList = new ArrayList<>();

		for (EmployeeSecretTO TO : empSecretList) {

			String status = TO.getStatus();

			switch (status) {

			case "INSERT":

				empMapper.insertEmployeeSecret(TO);

				insertList.add(TO.getEmpCode());

				break;

			}

		}

		resultMap.put("INSERT", insertList);
		// resultMap.put("UPDATE", updateList);
		// resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public Boolean checkUserIdDuplication(String companyCode, String newUserId) {

		ArrayList<EmployeeDetailTO> empDetailList = null;
		Boolean duplicated = false;

		empDetailList = empMapper.selectUserIdList(companyCode);

		for (EmployeeDetailTO TO : empDetailList) {

			if (TO.getUserId().equals(newUserId)) {

				duplicated = true;

			}

		}

		return duplicated;
	}

	@Override
	public Boolean checkEmpCodeDuplication(String companyCode, String newEmpCode) {

		Boolean duplicated = false;
		ArrayList<EmployeeBasicTO> empBasicList = null;

		empBasicList = empMapper.selectEmployeeBasicList(companyCode);

		for (EmployeeBasicTO TO : empBasicList) {

			if (TO.getEmpCode().equals(newEmpCode)) {

				duplicated = true;

			}

		}

		return duplicated;
	}

	public void changeEmpAccountUserStatus(String companyCode, String empCode, String userStatus) {

		HashMap<String, String> map = new HashMap<>();

		map.put("companyCode", companyCode);
		map.put("empCode", empCode);
		map.put("userStatus", userStatus);
		
		empMapper.changeUserAccountStatus(map);

	}

	@Override
	public EmpInfoTO accessToAuthority(String companyCode, String workplaceCode, String userId, String userPassword)
			throws IdNotFoundException, PwMissMatchException, PwNotFoundException {

		EmpInfoTO TO = null;

		TO = checkEmpInfo(companyCode, workplaceCode, userId);	// 데이터 베이스 에서 우리가 로그인 화면에서 입력한 값을 보내줘서 비교한후 있으면 들고와서 그사람의 정보를 bean 에 담는다
		checkPassWord(companyCode, TO.getEmpCode(), userPassword); // 비밀번호를 확인 해주는 메서드
			
		String[] userAuthorityGroupList = getUserAuthorityGroupList(TO.getEmpCode()); // 사용자의 권한그룹 리스트를 가져오는 메서드
		TO.setAuthorityGroupList(userAuthorityGroupList); 
			 
		String[] menuList = getUserAuthorityGroupMenu(TO.getEmpCode()); // 권한그룹별 메뉴 리스트를 가져오는 메서드 
		TO.setAuthorityGroupMenuList(menuList); 

		return TO;
	}

	@Override
	public String[] getAllMenuList() {

		String[] allMenuList = new String[3];
		
		// 메뉴와 nav메뉴를 담을 변수
		StringBuffer menuList = new StringBuffer();
		StringBuffer menuList_b = new StringBuffer();
		StringBuffer navMenuList = new StringBuffer();

		// nav메뉴 정렬을 위한 treemap
		TreeMap<Integer, MenuTO> treeMap = new TreeMap<>();

		
		ArrayList<MenuTO> allMenuTOList = authorityMapper.selectAllMenuList();

		ArrayList<MenuTO> lv0 = new ArrayList<>();
		ArrayList<MenuTO> lv1 = new ArrayList<>();
		ArrayList<MenuTO> lv2 = new ArrayList<>();
			
		for (MenuTO bean : allMenuTOList) {
			if (bean.getMenuURL() != null) {
				String lv = bean.getMenuLevel();
				switch (lv) {
				case "0":
					lv0.add(bean); break;
				case "1":
					lv1.add(bean); break;
				default:
					lv2.add(bean);
				}
			}
		}

		menuList.append("<ul class='list-unstyled components mb-5' id='menuUlTag'>");

		for (MenuTO bean0 : lv0) {

			menuList.append("<li>");
			menuList.append("<a href=" + bean0.getMenuURL()
					+ " data-toggle='collapse' aria-expanded='false' class='dropdown-toggle'>");
			menuList.append(bean0.getMenuName() + "</a>");
			menuList.append("<ul class='collapse list-unstyled' id=" + bean0.getMenuURL().substring(1) + ">");

			// 레벨1 메뉴
			for (MenuTO bean1 : lv1) {

				menuList.append("<li>");

				// 자식이 없는 레벨1 메뉴
				if (bean1.getChildMenu() == null && bean1.getParentMenuCode().equals(bean0.getMenuCode())) {

					menuList.append("<a href=" + bean1.getMenuURL() + " id=" + bean1.getMenuCode() + " class='m'>"
							+ bean1.getMenuName() + "</a>");

					if (bean1.getNavMenu() != null) {
						treeMap.put(Integer.parseInt(bean1.getNavMenu()), bean1);
					}

					// 자식이 있는 레벨1 메뉴
				} else if (bean1.getChildMenu() != null && bean1.getParentMenuCode().equals(bean0.getMenuCode())) {

					menuList.append("<a href=" + bean1.getMenuURL()
							+ " data-toggle='collapse' aria-expanded='false' class='dropdown-toggle' ");
					menuList.append("id=" + bean1.getMenuCode() + ">" + bean1.getMenuName() + "</a>");
					menuList.append(
							"<ul class='collapse list-unstyled' id=" + bean1.getMenuURL().substring(1) + ">");

					// 레벨2 메뉴
					for (MenuTO bean2 : lv2) {

						if (bean2.getParentMenuCode().equals(bean1.getMenuCode())) {
							menuList.append("<li>");
							menuList.append("<a href=" + bean2.getMenuURL() + " id=" + bean2.getMenuCode()
									+ " class='m'>" + bean2.getMenuName() + "</a>");
							menuList.append("</li>");
						}

						if (bean2.getNavMenu() != null) {
							treeMap.put(Integer.parseInt(bean2.getNavMenu()), bean2);
						}
					}
					menuList.append("</ul>");
				}
				menuList.append("</li>");
			}
			menuList.append("</ul>");
			menuList.append("</li>");
		}
		menuList.append("</ul>");

		//******************************************************************************************
			
		int l=0, j=0, k=0;
		menuList_b.append("<nav class='navbar navbar-expand-sm navbar-light bg-light'>");
		menuList_b.append("<button class='navbar-toggler' type='button' "
				+ "data-toggle='collapse' data-target='#navbarSupportedContent' "
				+ "aria-controls='navbarSupportedContent' aria-expanded='false' aria-label='Toggle navigation'>");
		menuList_b.append("<span class='navbar-toggler-icon'></span>");
		menuList_b.append("</button>");
		menuList_b.append("<div class='collapse navbar-collapse' id='navbarSupportedContent'>");
		//lv0
		for (MenuTO bean0 : lv0) {
			menuList_b.append("<ul class='nav-item dropdown'>");
			menuList_b.append("<a href='#' data-toggle='dropdown' id='navbarDropdown' role='button'"
					+ "aria-haspopup='true' aria-expanded='false' class='nav-link dropdown-toggle'>");
			menuList_b.append(bean0.getMenuName());
			menuList_b.append("</a>&nbsp");
			//lv1
			menuList_b.append("<div class='dropdown-menu' aria-labelledby='navbarDropdown'>");
			for (MenuTO bean1 : lv1) {
				if(bean1.getChildMenu() == null && bean1.getParentMenuCode().equals(bean0.getMenuCode())) {
					if(l!=0) menuList_b.append("<div class='dropdown-divider'></div>");
					menuList_b.append("<a href='"+ bean1.getMenuURL() 
					+"'class='dropdown-item'>" + bean1.getMenuName() + "</a>");
					l++;
				} else if (bean1.getChildMenu() != null && bean1.getParentMenuCode().equals(bean0.getMenuCode())) {
					if(j!=0) {menuList_b.append("<div class='dropdown-divider'></div>");}
					j++;l++;
					menuList_b.append("<a href='#' class='dropdown-item'"
							+ "role='button' id='" + bean1.getMenuCode() +"'"
							+ "data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>"
							+ bean1.getMenuName() + "</a>");
					menuList_b.append("<ul id='"+bean1.getMenuURL().substring(1)+"'>");
					//lv2
					for (MenuTO bean2 : lv2) {
						if (bean2.getParentMenuCode().equals(bean1.getMenuCode())) {
							menuList_b.append("<li style='list-style-type:disc;'>");
							k++;
							if(k!=0) {menuList_b.append("<div class='dropdown-divider'></div>");}
							
							menuList_b.append("<a href='"+ bean2.getMenuURL() +"'"
									+ "id='" + bean2.getMenuCode()+ "'"
									+ "'class='dropdown-item'>" + bean2.getMenuName() + "</a>");
							menuList_b.append("</li>");
						}
					}
					k=0;
					menuList_b.append("</ul>");
				}
			}
			l=0; 
			menuList_b.append("</div>");
			menuList_b.append("</ul>");
		}
		menuList_b.append("</div>");
		menuList_b.append("</nav>");
			
		//******************************************************************************************
			
		// nav메뉴
		navMenuList.append("<ul class='nav navbar-nav ml-auto'>");
		for (Integer i : treeMap.keySet()) {
			MenuTO bean = treeMap.get(i);
			navMenuList.append("<li class='nav-item'>");
			navMenuList
					.append("<a class='nav-link m' href=" + bean.getMenuURL() + " id=" + bean.getMenuCode() + ">");
			navMenuList.append(bean.getNavMenuName() + "</a>");
			navMenuList.append("</li>");
		}
		navMenuList.append("</ul>");
		
		allMenuList[0] = menuList.toString();
		allMenuList[1] = navMenuList.toString();
		allMenuList[2] = menuList_b.toString();

		return allMenuList;
	}
	
	@Override
	public ArrayList<AuthorityInfoGroupTO> getAuthorityGroup() {

		ArrayList<AuthorityInfoGroupTO> authorityGroupTOList = authorityMapper.selectAuthorityGroupList();

		return authorityGroupTOList;
	}

	@Override
	public ArrayList<AuthorityGroupTO> getUserAuthorityGroup(String empCode) {

		ArrayList<AuthorityGroupTO> authorityGroupTOList = authorityMapper.selectUserAuthorityGroupList(empCode);

		return authorityGroupTOList;
		
	}

	@Override
	public void insertEmployeeAuthorityGroup(String empCode, ArrayList<EmployeeAuthorityTO> employeeAuthorityTOList) {

	   	  authorityMapper.deleteEmployeeAuthorityGroup(empCode);
	    	  
	   	  for(EmployeeAuthorityTO bean : employeeAuthorityTOList) {
	    		  
	    	  authorityMapper.insertEmployeeAuthorityGroup(bean);
	    		  
	   	  }

	}

	@Override
	public ArrayList<MenuAuthorityTO> getMenuAuthority(String authorityGroupCode) {

		ArrayList<MenuAuthorityTO> menuAuthorityTOList =  null;
		
		menuAuthorityTOList = authorityMapper.selectMenuAuthorityList(authorityGroupCode);

		return menuAuthorityTOList;
	}

	@Override
	public void insertMenuAuthority(String authorityGroupCode, ArrayList<MenuAuthorityTO> menuAuthorityTOList) {

		authorityMapper.deleteMenuAuthority(authorityGroupCode);

		for (MenuAuthorityTO bean : menuAuthorityTOList) {

			authorityMapper.insertMenuAuthority(bean);
				
		}

	}

	private EmpInfoTO checkEmpInfo(String companyCode, String workplaceCode, String userId)
			throws IdNotFoundException {

		EmpInfoTO bean = null;
		ArrayList<EmpInfoTO> empInfoTOList = null;
		HashMap<String,String> map=new HashMap<>();
		
		map.put("companyCode", companyCode);
		map.put("workplaceCode", workplaceCode);
		map.put("userId", userId);
		
		empInfoTOList = empMapper.getTotalEmpInfo(map);
		
		System.out.println("LoginInfo : "+empInfoTOList);

		if (empInfoTOList.size() == 1) {

			for (EmpInfoTO e : empInfoTOList) {
				bean = e;
			}

		} else if (empInfoTOList.size() == 0) {
			throw new IdNotFoundException("입력된 정보에 해당하는 사원은 없습니다.");
		}

		return bean;
	}
	
	private void checkPassWord(String companyCode, String empCode, String userPassword)
			throws PwMissMatchException, PwNotFoundException {
		
		HashMap<String, String> map = new HashMap<>();

		map.put("companyCode", companyCode);
		map.put("empCode", empCode);

		EmployeeSecretTO bean = empMapper.selectUserPassWord(map);

		StringBuffer userPassWord = new StringBuffer();
		if (bean != null) {
			userPassWord.append(bean.getUserPassword());

		} else if (bean == null || bean.getUserPassword().equals("") || bean.getUserPassword() == null) {
			throw new PwNotFoundException("비밀번호 정보를 찾을 수 없습니다.");
		}

		if (!userPassword.equals(userPassWord.toString())) {
			throw new PwMissMatchException("비밀번호가 가입된 정보와 같지 않습니다.");
		}

	}
	
	private String[] getUserAuthorityGroupList(String empCode) {
		
		String[] userAuthorityGroupList = null;

		ArrayList<AuthorityGroupTO> userAuthorityGroupTOList = authorityMapper.selectUserAuthorityGroupList(empCode);

		Iterator<AuthorityGroupTO> iter=userAuthorityGroupTOList.iterator();
		while(iter.hasNext()){	
			if(iter.next().getAuthority().equals("0")) {
				iter.remove();
			}
		}
			
		// ArrayList 요소를 배열에 담음 
		int size = userAuthorityGroupTOList.size();
		userAuthorityGroupList = new String[size];
		  for(int i=0; i<size; i++ ) { 
			  userAuthorityGroupList[i] = userAuthorityGroupTOList.get(i).getUserAuthorityGroupCode(); 
		  }

		return userAuthorityGroupList;
	}

	private String[] getUserAuthorityGroupMenu(String empCode) {

		String[] authorityGroupMenuList = null;

		ArrayList<AuthorityGroupMenuTO> authorityGroupMenuTOList = authorityMapper.selectUserMenuAuthorityList(empCode);

		// ArrayList 요소를 배열에 담음 
		int size = authorityGroupMenuTOList.size();
		authorityGroupMenuList = new String[size];
		  for(int i=0; i<size; i++ ) { 
			  authorityGroupMenuList[i] = authorityGroupMenuTOList.get(i).getMenuCode(); 
		  }

		return authorityGroupMenuList;
	}

}
