package kr.co.seoulit.logistics.logiinfosvc.logiinfo.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.WorkplaceTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.logiinfo.service.LogiInfoService;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.WarehouseTO;

@CrossOrigin("*")
@RestController
@RequestMapping("/logiinfo/*")
public class WarehouseController {

	@Autowired
	private LogiInfoService logiInfoService;

	ModelMap map = null;

	private static Gson gson = new GsonBuilder().serializeNulls().create();

	@RequestMapping(value = "/warehouse/list", method = RequestMethod.GET)
	public ModelMap getWarehouseList(HttpServletRequest request, HttpServletResponse response) {

		System.out.println("getWarehouseList메서드");

		map = new ModelMap();

		try {
			ArrayList<WarehouseTO> WarehouseTOList = logiInfoService.getWarehouseInfoList();
			map.put("gridRowJson", WarehouseTOList);
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
	@RequestMapping(value = "/warehouse/batch", method = RequestMethod.POST)
	public ModelMap modifyWarehouseInfo(@RequestBody ArrayList<WarehouseTO> batchList) {
		System.out.println("batchList메서드"+ batchList);



		map = new ModelMap();
		try {
//			ArrayList<WarehouseTO> warehouseTOList = gson.fromJson(batchList,
//				new TypeToken<ArrayList<WarehouseTO>>() {
//					}.getType());

			logiInfoService.batchWarehouseInfo(batchList);

			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}


	@RequestMapping(value = "/warehouse/page-list", method = RequestMethod.GET)
	public ModelMap findLastWarehouseCode(@RequestBody WarehouseTO batchList){
		System.out.println("findWarehouseCode메서드"+batchList);
		map = new ModelMap();

		try {
			String warehouseCode = logiInfoService.findLastWarehouseCode();
			map.put("lastWarehouseCode", warehouseCode);
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