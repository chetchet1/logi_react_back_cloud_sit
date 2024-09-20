package kr.co.seoulit.logistics.logiinfosvc.hr.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.hr.service.HRService;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmpInfoTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeBasicTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeDetailTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeSecretTO;

@RestController
@RequestMapping(value = "/hr/*")
public class EmpController {

	@Autowired
	private HRService hrService;
	
	ModelMap map = null;

	private static Gson gson = new GsonBuilder().serializeNulls().create(); // 속성값이 null 인 속성도 json 변환

	@RequestMapping(value="/emp/alllist", method=RequestMethod.GET)
	public ModelMap searchAllEmpList(HttpServletRequest request, HttpServletResponse response) {
		String searchCondition = request.getParameter("searchCondition");
		String companyCode = request.getParameter("companyCode");
		String workplaceCode = request.getParameter("workplaceCode");
		String deptCode = request.getParameter("deptCode");
		map = new ModelMap();

		ArrayList<EmpInfoTO> empList = null;
		String[] paramArray = null;
		try {
			switch (searchCondition) {
				case "ALL":
					paramArray = new String[] { companyCode };
					break;
	
				case "WORKPLACE":
					paramArray = new String[] { companyCode, workplaceCode };
					break;
	
				case "DEPT":
					paramArray = new String[] { companyCode, deptCode };
					break;
	
				case "RETIREMENT":
					paramArray = new String[] { companyCode };
					break;
			}
			empList = hrService.getAllEmpList(searchCondition, paramArray);

			map.put("gridRowJson", empList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="/emp/list", method=RequestMethod.GET)
	public ModelMap searchEmpInfo(HttpServletRequest request, HttpServletResponse response) {
		String companyCode = request.getParameter("companyCode");
		String empCode = request.getParameter("empCode");
		map = new ModelMap();
		EmpInfoTO empInfoTO = null;
		try {
			empInfoTO = hrService.getEmpInfo(companyCode, empCode);

			map.put("empInfo", empInfoTO);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="/emp/userid-duplication", method=RequestMethod.GET)
	public ModelMap checkUserIdDuplication(HttpServletRequest request, HttpServletResponse response) {
		String companyCode = request.getParameter("companyCode");
		String newUserId = request.getParameter("newUseId");
		map = new ModelMap();
		try {
			Boolean flag = hrService.checkUserIdDuplication(companyCode, newUserId);

			map.put("result", flag);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="/emp/code-duplication", method=RequestMethod.GET)
	public ModelMap checkEmpCodeDuplication(HttpServletRequest request, HttpServletResponse response) {
		String companyCode = request.getParameter("companyCode");
		String newEmpCode = request.getParameter("newEmpCode");
		map = new ModelMap();
		try {
			Boolean flag = hrService.checkEmpCodeDuplication(companyCode, newEmpCode);

			map.put("result", flag);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	}

	@RequestMapping(value="/emp/newempcode", method=RequestMethod.GET)
	public ModelMap getNewEmpCode(HttpServletRequest request, HttpServletResponse response) {
		String companyCode = request.getParameter("companyCode");
		String newEmpCode = null;
		map = new ModelMap();
		try {
			newEmpCode = hrService.getNewEmpCode(companyCode);

			map.put("newEmpCode", newEmpCode);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
	
	
	@RequestMapping(value="/emp/batch", method=RequestMethod.POST)
	public ModelMap batchListProcess(HttpServletRequest request, HttpServletResponse response) {
		String batchList = request.getParameter("batchList");
		String tableName = request.getParameter("tableName");
		map = new ModelMap();

		ArrayList<EmployeeBasicTO> empBasicList = null;
		ArrayList<EmployeeDetailTO> empDetailList = null;
		ArrayList<EmployeeSecretTO> empSecretList = null;

		HashMap<String, Object> resultMap = null;
		try {
			if (tableName.equals("BASIC")) {
				empBasicList = gson.fromJson(batchList, new TypeToken<ArrayList<EmployeeBasicTO>>() {
				}.getType());
	
				resultMap = hrService.batchEmpBasicListProcess(empBasicList);
			} else if (tableName.equals("DETAIL")) {
				empDetailList = gson.fromJson(batchList, new TypeToken<ArrayList<EmployeeDetailTO>>() {
				}.getType());
				
				System.out.println(gson.toJson(empDetailList));
				resultMap = hrService.batchEmpDetailListProcess(empDetailList);
			} else if (tableName.equals("SECRET")) {
				empSecretList = gson.fromJson(batchList, new TypeToken<ArrayList<EmployeeSecretTO>>() {
				}.getType());
				System.out.println(gson.toJson(empSecretList));
				
				resultMap = hrService.batchEmpSecretListProcess(empSecretList);
			}
			map.put("result", resultMap);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

}
