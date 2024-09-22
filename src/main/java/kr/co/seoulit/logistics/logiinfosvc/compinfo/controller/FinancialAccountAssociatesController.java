package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.FinancialAccountAssociatesTO;
@CrossOrigin("${FRONTEND_SERVICE_URL}:3000")
@RestController
@RequestMapping("/compinfo/*")
public class FinancialAccountAssociatesController {

	@Autowired
	private CompInfoService compInfoService;
	
	ModelMap map = null;

	private static Gson gson = new GsonBuilder().serializeNulls().create(); // 속성값이 null 인 속성도 JSON 변환

	@RequestMapping(value = "/financialaccountassociates/list", method = RequestMethod.GET)
	public ModelMap searchFinancialAccountAssociatesList(HttpServletRequest request, HttpServletResponse response) {
		String searchCondition = request.getParameter("searchCondition");
		String workplaceCode = request.getParameter("workplaceCode");
		map = new ModelMap();
		ArrayList<FinancialAccountAssociatesTO> financialAccountAssociatesList = null;
		try {
			financialAccountAssociatesList = compInfoService.getFinancialAccountAssociatesList(searchCondition,
					workplaceCode);
	
			map.put("gridRowJson", financialAccountAssociatesList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	/*은비 수정*/
	@RequestMapping(value = "/financialaccountassociates/batch", method = RequestMethod.POST)
	public ModelMap batchListProcess(@RequestBody HashMap<String, ArrayList<FinancialAccountAssociatesTO>> batchList) {
		System.out.println(batchList);
		map = new ModelMap();
		ArrayList<FinancialAccountAssociatesTO> financialAccountAssociatesList=batchList.get("batchList");
		try {
//			ArrayList<FinancialAccountAssociatesTO> financialAccountAssociatesList = gson.fromJson(batchList,
//					new TypeToken<ArrayList<FinancialAccountAssociatesTO>>() {
//					}.getType());
			HashMap<String, Object> resultMap = compInfoService
					.batchFinancialAccountAssociatesListProcess(financialAccountAssociatesList);
	
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
