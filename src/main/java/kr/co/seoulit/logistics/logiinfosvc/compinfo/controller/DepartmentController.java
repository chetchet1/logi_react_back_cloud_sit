package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.DepartmentEntity;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.JpaCompInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.DepartmentTO;
@CrossOrigin("${FRONTEND_SERVICE_URL}")
@RestController
@RequestMapping("/compinfo/*")
public class DepartmentController {

	@Autowired
	private CompInfoService compInfoService;
	@Autowired
	private JpaCompInfoService jpaCompInfoService;
	ModelMap map = null;

	private static Gson gson = new GsonBuilder().serializeNulls().create(); // 속성값이 null 인 속성도 JSON 변환

	@RequestMapping(value = "/department/list", method = RequestMethod.GET)
	public ModelMap searchDepartmentList(HttpServletRequest request, HttpServletResponse response) {
		String searchCondition = request.getParameter("searchCondition");
		String companyCode = request.getParameter("companyCode");
		String workplaceCode = request.getParameter("workplaceCode");
		map = new ModelMap();
		ArrayList<DepartmentTO> departmentList = null;
		try {
			departmentList = compInfoService.getDepartmentList(searchCondition, companyCode, workplaceCode);

			map.put("gridRowJson", departmentList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공!");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
//		@RequestMapping(value = "/department/list", method = RequestMethod.GET)
//	public ModelMap searchDepartmentList(@RequestParam("searchCondition") String searchCondition,
//										 @RequestParam("companyCode") String companyCode,
//										 @RequestParam("workplaceCode") String workplaceCode
//										 ) {
//
//		map = new ModelMap();
//		ArrayList<DepartmentEntity> departmentList = null;
//		try {
//			departmentList = jpaCompInfoService.getDepartmentList(searchCondition, companyCode, workplaceCode);
//
//			map.put("gridRowJson", departmentList);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공!");
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}

	@RequestMapping(value = "/department/batch", method = RequestMethod.POST)
	public ModelMap batchListProcess(@RequestBody HashMap<String,ArrayList<DepartmentTO>> batchList) {
		map = new ModelMap();
		ArrayList<DepartmentTO> batlist=batchList.get("batchList");
		System.out.println(batlist);
		try {

			HashMap<String, Object> resultMap = compInfoService.batchDepartmentListProcess(batlist);
	
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
