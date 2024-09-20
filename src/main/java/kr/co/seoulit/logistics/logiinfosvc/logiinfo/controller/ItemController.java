package kr.co.seoulit.logistics.logiinfosvc.logiinfo.controller;

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

import kr.co.seoulit.logistics.logiinfosvc.logiinfo.service.LogiInfoService;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.ItemGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.ItemInfoTO;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.ItemTO;

@CrossOrigin
@RestController
@RequestMapping("/logiinfo/*")
public class ItemController {

	@Autowired
	private LogiInfoService logiInfoService;
	
	ModelMap map = null;

	private static Gson gson = new GsonBuilder().serializeNulls().create();

	@RequestMapping(value="/item/list", method=RequestMethod.GET)
	public ModelMap searchItem(HttpServletRequest request, HttpServletResponse response) {
		String searchCondition = request.getParameter("searchCondition");
		String itemClassification = request.getParameter("itemClassification");
		String itemGroupCode = request.getParameter("itemGroupCode");
		String minPrice = request.getParameter("minPrice");
		String maxPrice = request.getParameter("maxPrice");
		map = new ModelMap();

		ArrayList<ItemInfoTO> itemInfoList = null;
		String[] paramArray = null;
		try {
			switch (searchCondition) {
				case "ALL":
					paramArray = null;
					break;
				case "ITEM_CLASSIFICATION":
					paramArray = new String[] { itemClassification };
					break;
				case "ITEM_GROUP_CODE":
					paramArray = new String[] { itemGroupCode };
					break;
				case "STANDARD_UNIT_PRICE":
					paramArray = new String[] { minPrice, maxPrice };
					break;
			}

			itemInfoList = logiInfoService.getItemInfoList(searchCondition, paramArray);

			map.put("gridRowJson", itemInfoList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");

		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());

		}  
		return map;
	}
	
	@RequestMapping(value="/item/standardunitprice", method=RequestMethod.GET)
	public ModelMap getStandardUnitPrice(HttpServletRequest request, HttpServletResponse response) {
		String itemCode = request.getParameter("itemCode");
		map = new ModelMap();
		int price = 0;
		try {
			price = logiInfoService.getStandardUnitPrice(itemCode);

			map.put("gridRowJson", price);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	}
	
	@RequestMapping(value="/item/standardunitprice-box", method=RequestMethod.POST)
	public ModelMap getStandardUnitPriceBox(HttpServletRequest request, HttpServletResponse response) {
		String itemCode = request.getParameter("itemCode");
		map = new ModelMap();
		int price = 0;
		try {
			price = logiInfoService.getStandardUnitPriceBox(itemCode);

			map.put("gridRowJson", price);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	}
	
	@RequestMapping(value="/item/batch", method=RequestMethod.POST)
	public ModelMap batchListProcess(HttpServletRequest request, HttpServletResponse response) {
		String batchList = request.getParameter("batchList");
		map = new ModelMap();
		ArrayList<ItemTO> itemTOList = gson.fromJson(batchList, new TypeToken<ArrayList<ItemTO>>() {
		}.getType());
		try {
			HashMap<String, Object> resultMap = logiInfoService.batchItemListProcess(itemTOList);

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

	//품목상세 조회
	@RequestMapping(value="/item/info-list" , method=RequestMethod.GET)
	public ModelMap searchitemInfoList(HttpServletRequest request, HttpServletResponse response) {
		String ableContractInfo =request.getParameter("ableContractInfo");
		map = new ModelMap();

		HashMap<String,String> ableSearchConditionInfo = gson.fromJson(ableContractInfo, new TypeToken<HashMap<String,String>>() {
		}.getType());

		ArrayList<ItemInfoTO> itemCodeList = null;
		try {
			itemCodeList = logiInfoService.getitemInfoList(ableSearchConditionInfo);
	
			map.put("gridRowJson", itemCodeList);
			map.put("errorCode", 0);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	}

	//품목그룹조회
	@RequestMapping(value="/item/group-list" , method=RequestMethod.GET)
	public ModelMap searchitemGroupList(HttpServletRequest request, HttpServletResponse response) {
		String ableContractInfo =request.getParameter("ableContractInfo");
		map = new ModelMap();

		HashMap<String,String> ableSearchConditionInfo = gson.fromJson(ableContractInfo, new TypeToken<HashMap<String,String>>() {
		}.getType());
		ArrayList<ItemGroupTO> itemGroupList = null;
		try {
			itemGroupList = logiInfoService.getitemGroupList(ableSearchConditionInfo);
	
			map.put("gridRowJson", itemGroupList);
			map.put("errorCode", 0);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	}


	  //품목그룹삭제
	@RequestMapping(value="/item/group" , method=RequestMethod.DELETE)
	public ModelMap deleteItemGroup(HttpServletRequest request, HttpServletResponse response) {
		  String ableContractInfo =request.getParameter("ableContractInfo");
		  map = new ModelMap();
		  
		  HashMap<String,String> ableSearchConditionInfo =
		  gson.fromJson(ableContractInfo, new TypeToken<HashMap<String,String>>() {}.getType());
		try {
			logiInfoService.getdeleteitemgroup(ableSearchConditionInfo);
			map.put("errorCode", 0); 
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	}


	@RequestMapping(value="/item/batchsave" , method=RequestMethod.POST)
	public ModelMap itemBatchSave(@RequestBody ArrayList<ItemInfoTO> batchList) {
		System.out.println("값넘어오나요?"+batchList);
		map = new ModelMap();
//      ArrayList<ItemInfoTO> itemTOList = gson.fromJson(ableContractInfo, new TypeToken<ArrayList<ItemInfoTO>>() {
//      }.getType());
		try {
			ArrayList<ItemInfoTO> resultMap=logiInfoService.getBatchSave(batchList);
			map.put("gridRowJson", resultMap);
			map.put("errorCode", 0);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return null;
	}

//	//일괄저장
//	@RequestMapping(value="/item/batchsave" , method=RequestMethod.POST)
//	public ModelMap itemBatchSave(HttpServletRequest request, HttpServletResponse response) {
//		String ableContractInfo =request.getParameter("ableContractInfo");
//		map = new ModelMap();
//
//		ArrayList<ItemInfoTO> itemTOList = gson.fromJson(ableContractInfo, new TypeToken<ArrayList<ItemInfoTO>>() {
//		}.getType());
//		try {
//			logiInfoService.getbatchSave(itemTOList);
//			map.put("errorCode", 0);
//			map.put("errorMsg", "성공");
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}

	@RequestMapping("/getOptionItemList")
	public HashMap<String, Object> getOptionItemList(HttpServletRequest request, HttpServletResponse response) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("gridRowJson", logiInfoService.getOptionItemList());
			resultMap.put("errorCode", 1);
			resultMap.put("errorMsg", "성공");

		} catch (Exception e2) {
			e2.printStackTrace();
			resultMap.put("errorCode", -2);
			resultMap.put("errorMsg", e2.getMessage());
		}
		return resultMap;
	}
}
