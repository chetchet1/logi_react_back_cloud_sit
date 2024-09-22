package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.JpaCompInfoService;
import org.eclipse.jdt.internal.compiler.ast.ArrayQualifiedTypeReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CustomerTO;
@CrossOrigin("${FRONTEND_SERVICE_URL}:3000")
@RestController
@RequestMapping("/compinfo/*")
public class CustomerController {

	@Autowired
	private CompInfoService compInfoService;
	@Autowired
	private JpaCompInfoService jpaCompInfoService;
	
	ModelMap map = null;

	// GSON 라이브러리
	private static Gson gson = new GsonBuilder().serializeNulls().create(); // 속성값이 null 인 속성도 JSON 변환

	/*은비 수정*/
//	@RequestMapping(value = "/customer/list", method=RequestMethod.GET)
//	public ModelMap searchCustomerList(@RequestParam("searchCondition") String searchCondition,
//									   @RequestParam("companyCode") String companyCode,
//									   @RequestParam("workplaceCode") String workplaceCode,
//									   @RequestParam("itemGroupCode") String itemGroupCode) {
//
//		System.out.println("안돼?"+searchCondition);
//		map = new ModelMap();
//		ArrayList<CustomerTO> customerList = null;
//		try {
//			customerList = compInfoService.getCustomerList(searchCondition, companyCode, workplaceCode,itemGroupCode);
//
//			map.put("gridRowJson", customerList);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공!");
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}
	@RequestMapping(value = "/customer/list", method=RequestMethod.GET)
	public ModelMap searchCustomerList(HttpServletRequest request, HttpServletResponse response) {
		String searchCondition = request.getParameter("searchCondition");
		String companyCode = request.getParameter("companyCode");
		String workplaceCode = request.getParameter("workplaceCode");
		String itemGroupCode = request.getParameter("itemGroupCode");
		map = new ModelMap();
		ArrayList<CustomerTO> customerList = null;
		try {
			customerList = compInfoService.getCustomerList(searchCondition, companyCode, workplaceCode,itemGroupCode);

			map.put("gridRowJson", customerList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공!");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	/*은비 수정*/
	@RequestMapping(value = "/customer/batch", method=RequestMethod.POST)
	public ModelMap batchListProcess(@RequestBody HashMap<String, ArrayList<CustomerTO>> batchList) {
		System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		System.out.println(batchList);
		System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		map = new ModelMap();
		ArrayList<CustomerTO> customerList=batchList.get("batchList");
		try {
//			ArrayList<CustomerTO> customerList = gson.fromJson(batchList, new TypeToken<ArrayList<CustomerTO>>() {
//			}.getType());
			HashMap<String, Object> resultMap = compInfoService.batchCustomerListProcess(customerList);
	
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
