package kr.co.seoulit.logistics.prodcsvc.quality.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import kr.co.seoulit.logistics.prodcsvc.quality.to.WorkSiteSimulationTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.prodcsvc.quality.service.QualityService;
import kr.co.seoulit.logistics.prodcsvc.quality.to.ProductionPerformanceInfoTO;
import kr.co.seoulit.logistics.prodcsvc.quality.to.WorkOrderInfoTO;

@RestController
@CrossOrigin("*")
@RequestMapping("/quality/*")
@Tag(name="Quality")
public class WorkOrderController {

	@Autowired
	private QualityService qualityService;

	ModelMap map = null;


	private static Gson gson = new GsonBuilder().serializeNulls().create();

	@RequestMapping(value="/workorder/mrpavailable" , method=RequestMethod.GET)
	@Operation(summary = "WorkOrderableMrpList", description = "get WorkOrderableMrpList.", tags = {"Quality", })
	public HashMap<String, Object> getWorkOrderableMrpList(HttpServletRequest request, HttpServletResponse response) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			resultMap = qualityService.getWorkOrderableMrpList();
			System.out.println("resultMap.toString() = " + resultMap.toString());
		} catch (Exception e2) {
			e2.printStackTrace();
			resultMap.put("errorCode", -2);
			resultMap.put("errorMsg", e2.getMessage());

		}
		return resultMap;
	}

	@RequestMapping(value="/workorder/dialog" , method=RequestMethod.GET)
	@Operation(summary = "WorkOrderDialog", description = "show WorkOrderDialog.", tags = {"Quality", })
	public HashMap<String, Object> showWorkOrderDialog(HttpServletRequest request, HttpServletResponse response) {
		String mrpGatheringNo = request.getParameter("mrpGatheringNo");
		String mrpNo = request.getParameter("mrpNo");

		System.out.println("mrpGatheringNo = " + mrpGatheringNo);
		System.out.println("mrpNo = " + mrpNo);
		
		HashMap<String, Object> map =new HashMap<>();
		System.out.println("작업지시");
		try {
//			map = qualityService.getWorkOrderSimulationList(mrpGatheringNoList,mrpNoList);
			map = qualityService.getWorkOrderSimulationList(mrpNo, mrpGatheringNo);
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		System.out.println("map = " + map);
		return map;
	}

	@RequestMapping(value="/workorder" , method=RequestMethod.POST)
	@Operation(summary = "workOrder", description = "post workOrder.", tags = {"Quality", })
	public ModelMap workOrder(HttpServletRequest request, HttpServletResponse response) {
		String mrpGatheringNo = request.getParameter("mrpGatheringNo"); // mrpGatheringNo
		String workPlaceCode = request.getParameter("workPlaceCode");
		String productionProcess = request.getParameter("productionProcessCode");
		String mrpNo = request.getParameter("mrpNo");
		map = new ModelMap();
		try {

			map = qualityService.workOrder(mrpGatheringNo,workPlaceCode,productionProcess,mrpNo);

		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="/workorder/list" , method=RequestMethod.GET)		//작업장 조회
	@Operation(summary = "작업장 조회", description = "작업장 조회하기", tags = {"Quality", })
	public ModelMap showWorkOrderInfoList(HttpServletRequest request, HttpServletResponse response) {
		ArrayList<WorkOrderInfoTO> workOrderInfoList = null;
		map = new ModelMap();
		try {
			workOrderInfoList = qualityService.getWorkOrderInfoList();

			map.put("gridRowJson", workOrderInfoList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="/workorder/completion" , method=RequestMethod.GET)
	@Operation(summary = "workOrderCompletion", description = "get workOrderCompletion", tags = {"Quality", })
	public ModelMap workOrderCompletion(HttpServletRequest request, HttpServletResponse response) {
		String workOrderNo=request.getParameter("workOrderNo");
		String actualCompletionAmount=request.getParameter("actualCompletionAmount");
		map = new ModelMap();
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap = qualityService.workOrderCompletion(workOrderNo,actualCompletionAmount);

			map.put("errorCode",resultMap.get("ERROR_CODE"));
			map.put("errorMsg", resultMap.get("ERROR_MSG"));
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="/workorder/performance-list" , method=RequestMethod.GET)
	@Operation(summary = "ProductionPerformanceInfoList", description = "get ProductionPerformanceInfoList", tags = {"Quality", })
	public ModelMap getProductionPerformanceInfoList(HttpServletRequest request, HttpServletResponse response) {
		ArrayList<ProductionPerformanceInfoTO> productionPerformanceInfoList = null;
		map = new ModelMap();
		try {
			productionPerformanceInfoList = qualityService.getProductionPerformanceInfoList();

			map.put("gridRowJson", productionPerformanceInfoList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="/worksite/situation" , method=RequestMethod.GET)
	@Operation(summary = "situation list", description = "get situation list.", tags = {"Quality", })
	public ModelMap showWorkSiteSituation(HttpServletRequest request, HttpServletResponse response) {
		String workSiteCourse = request.getParameter("workSiteCourse");
		String workOrderNo = request.getParameter("workOrderNo");
		String itemClassIfication = request.getParameter("itemClassIfication");
		map = new ModelMap();
		try {
			map = qualityService.showWorkSiteSituation(workSiteCourse,workOrderNo,itemClassIfication);
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

//	@RequestMapping(value="/workorder/workcompletion" , method=RequestMethod.POST)
//	public ModelMap workCompletion(HttpServletRequest request, HttpServletResponse response) {
//		String workOrderNo = request.getParameter("workOrderNo");
//		String itemCode = request.getParameter("itemCode");
//		String itemCodeList = request.getParameter("itemCodeList");
//		map = new ModelMap();
//		try {
//			ArrayList<String> itemCodeListArr = gson.fromJson(itemCodeList,
//					new TypeToken<ArrayList<String>>() {}.getType());
//			qualityService.workCompletion(workOrderNo,itemCode,itemCodeListArr);
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}

	// /workorder/workcompletion 주석처리, /workCompletion 열려있었는데
	// 기존 검사 및 제작완료 안될 거 같아서 String 이름으로 Service 하나 만들었음
	@RequestMapping(value="/workorder/workcompletion" , method=RequestMethod.POST)
	@Operation(summary = "workCompletion", description = "post workCompletion", tags = {"Quality", })
	public void workCompletion(HttpServletRequest request, HttpServletResponse response) {

		String workOrderNo = request.getParameter("workOrderNo");
		String itemCode = request.getParameter("itemCode");
		String itemCodeList = request.getParameter("itemCodeList");

		System.out.println("workOrderNo = " + workOrderNo);
		System.out.println("itemCode = " + itemCode);

		ArrayList<String> itemCodeListArr = gson.fromJson(itemCodeList, new TypeToken<ArrayList<String>>() {}.getType());

		System.out.println("itemCodeListArr = " + itemCodeListArr);
		qualityService.workCompletionString(workOrderNo,itemCode,itemCodeListArr);

	}

	@RequestMapping("/workCompletion")
	@Operation(summary = "workCompletion", description = "get workCompletion", tags = {"Quality", })
	public ModelMap workCompletion(@RequestBody HashMap<String, ArrayList<WorkSiteSimulationTO>> workOrderInfo) {

//		ArrayList<String> itemCodeListArr = gson.fromJson(itemCodeList,
//				new TypeToken<ArrayList<String>>() {}.getType());
		System.out.println("@@@@" + workOrderInfo);
//		System.out.println(workOrderNo);
//		System.out.println(itemCode);s
		try {

			qualityService.workCompletion(workOrderInfo);

		} catch (Exception e2) {
			e2.printStackTrace();
			map.put("errorCode", -2);
			map.put("errorMsg", e2.getMessage());

		}
		return map;
	}

	@RequestMapping(value="/workorder/worksitelog" , method=RequestMethod.GET)
	@Operation(summary = "workSiteLogList", description = "get workSiteLogList", tags = {"Quality", })
	public ModelMap workSiteLogList(HttpServletRequest request, HttpServletResponse response) {
		String workSiteLogDate = request.getParameter("workSiteLogDate");
		map = new ModelMap();
		HashMap<String, Object> resultMap = new HashMap<>();
		System.out.println(workSiteLogDate);
		try {
			resultMap = qualityService.workSiteLogList(workSiteLogDate);

			map.put("gridRowJson", resultMap.get("gridRowJson"));
			map.put("errorCode", resultMap.get("errorCode"));
			map.put("errorMsg", resultMap.get("errorMsg"));
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	/****************************
	        작업장 조회 JPA
	 ****************************/
	@RequestMapping(value="/getWorkOrderInfoList" , method=RequestMethod.GET)
	public ModelMap showWorkOrderInfoListJpa(HttpServletRequest request, HttpServletResponse response) {
		ArrayList<WorkOrderInfoTO> workOrderInfoList = null;
		map = new ModelMap();
		try {
			workOrderInfoList = qualityService.getWorkOrderInfoListJpa();

			map.put("gridRowJson", workOrderInfoList);
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
