package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.CompanyEntity;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.JpaCompInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CompanyTO;

//@CrossOrigin("${FRONTEND_SERVICE_URL}:3000")

@RestController
@RequestMapping("/compinfo/*")
public class CompanyController {

	@Autowired
	private CompInfoService compInfoService;
	@Autowired
	private JpaCompInfoService jpaCompInfoService;

	ModelMap map = null;
	
	private static Gson gson = new GsonBuilder().serializeNulls().create(); // 속성값이 null 인 속성도 JSON 변환

//	@RequestMapping(value = "/company/list", method = RequestMethod.GET)
//	public ModelMap searchCompanyList(HttpServletRequest request, HttpServletResponse response) {
//		map = new ModelMap();
//		try {
//			ArrayList<CompanyTO> companyList  = compInfoService.getCompanyList();
//
//			map.put("gridRowJson", companyList);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공!");
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}
@RequestMapping(value = "/company/list", method = RequestMethod.GET)
public ModelMap searchCompanyList(HttpServletRequest request, HttpServletResponse response) {
	map = new ModelMap();
	try {
		ArrayList<CompanyEntity> companyList  = jpaCompInfoService.getCompanyList();

		map.put("gridRowJson", companyList);
		map.put("errorCode", 1);
		map.put("errorMsg", "성공!");
	} catch (Exception e1) {
		e1.printStackTrace();
		map.put("errorCode", -1);
		map.put("errorMsg", e1.getMessage());
	}
	return map;
}

	@RequestMapping(value = "/company/batch", method = RequestMethod.POST)
	public ModelMap batchListProcess(HttpServletRequest request, HttpServletResponse response) {
		String batchList = request.getParameter("batchList");
		map = new ModelMap();
		try {
			ArrayList<CompanyTO> companyList = gson.fromJson(batchList, new TypeToken<ArrayList<CompanyTO>>() {
			}.getType());
	
			HashMap<String, Object> resultMap = compInfoService.batchCompanyListProcess(companyList);
	
			map.put("result", resultMap);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공!");
		} catch (Exception e1) { 
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

}
