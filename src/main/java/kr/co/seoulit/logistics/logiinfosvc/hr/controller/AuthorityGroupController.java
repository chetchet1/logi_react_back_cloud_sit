package kr.co.seoulit.logistics.logiinfosvc.hr.controller;

import java.util.ArrayList;

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
import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.AuthorityInfoGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmployeeAuthorityTO;

@RestController
@RequestMapping(value = "/hr/*")
public class AuthorityGroupController {
	
	@Autowired
	private HRService hrService;
	
	ModelMap map = null;
	
	private static Gson gson = new GsonBuilder().serializeNulls().create();
	
	@RequestMapping(value="/authoritygroup/user", method = RequestMethod.GET)
	public ModelMap getUserAuthorityGroup(HttpServletRequest request, HttpServletResponse response) {
		String empCode = request.getParameter("empCode");
		map = new ModelMap();
		try {
			ArrayList<AuthorityGroupTO> authorityGroupTOList = hrService.getUserAuthorityGroup(empCode);
			
			map.put("gridRowJson", authorityGroupTOList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
	
	@RequestMapping(value="/authoritygroup", method = RequestMethod.GET)
	public ModelMap getAuthorityGroup(HttpServletRequest request, HttpServletResponse response) {
		map = new ModelMap();
		try {
			ArrayList<AuthorityInfoGroupTO> authorityGroupTOList = hrService.getAuthorityGroup();
			
			map.put("gridRowJson", authorityGroupTOList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
	
	@RequestMapping(value="/employeeauthoritygroup", method = RequestMethod.POST)
	public ModelMap insertEmployeeAuthorityGroup(HttpServletRequest request, HttpServletResponse response) {
		String empCode = request.getParameter("empCode");
		String insertDataList = request.getParameter("insertData");
		map = new ModelMap();
		ArrayList<EmployeeAuthorityTO> employeeAuthorityTOList = gson.fromJson(insertDataList,
				new TypeToken<ArrayList<EmployeeAuthorityTO>>() {}.getType());
		try {
			hrService.insertEmployeeAuthorityGroup(empCode, employeeAuthorityTOList);

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
