package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.WorkplaceEntity;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.JpaCompInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.WorkplaceTO;

@CrossOrigin("*")
@RestController
@RequestMapping("/compinfo/*")
public class WorkplaceController {

	@Autowired
	private CompInfoService compInfoService;
	@Autowired
	private JpaCompInfoService jpaCompInfoService;
	
	ModelMap map = null;

	private static Gson gson = new GsonBuilder().serializeNulls().create();

//	@RequestMapping(value = "/workplace/list", method = RequestMethod.GET)
//	public ModelMap searchWorkplaceList(HttpServletRequest request, HttpServletResponse response) {
//		String companyCode = request.getParameter("companyCode");
//		map = new ModelMap();
//		ArrayList<WorkplaceTO> workplaceList = null;
//		try {
//			workplaceList = compInfoService.getWorkplaceList(companyCode);
//
//			map.put("gridRowJson", workplaceList);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공");
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}
	/*은비 수정*/
	@RequestMapping(value = "/workplace/list", method = RequestMethod.GET)
	public ModelMap searchWorkplaceList(@RequestParam("companyCode") String companyCode) {
		map = new ModelMap();

		try {
			ArrayList<WorkplaceEntity> workplaceList = jpaCompInfoService.getWorkplaceList(companyCode);

			map.put("gridRowJson", workplaceList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
	@RequestMapping(value = "/workplace/batch", method = RequestMethod.POST)
	public ModelMap batchListProcess(@RequestBody HashMap<String,ArrayList<WorkplaceTO>> batchList) {
		map = new ModelMap();
		ArrayList<WorkplaceTO> list=batchList.get("batchList");
		try {
			HashMap<String, Object> resultMap = compInfoService.batchWorkplaceListProcess(list);
	
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
