package kr.co.seoulit.logistics.purcstosvc.stock.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import kr.co.seoulit.logistics.purcstosvc.stock.service.StockService;
import kr.co.seoulit.logistics.purcstosvc.stock.to.BomDeployTO;
import kr.co.seoulit.logistics.purcstosvc.stock.to.BomInfoTO;
import kr.co.seoulit.logistics.purcstosvc.stock.to.BomTO;

// BOM관리 컨트롤러
// TEST 중

@CrossOrigin
@RestController
@RequestMapping("/stock/*")
public class BomController {

    @Autowired
    private StockService stockService;

    ModelMap map = null;


    private static Gson gson = new GsonBuilder().serializeNulls().create();

    @RequestMapping(value="/bom/deploy", method=RequestMethod.GET)
    public ArrayList<BomDeployTO> searchBomDeploy(HttpServletRequest request, HttpServletResponse response) {

        String deployCondition = request.getParameter("deployCondition");
        System.out.println("deployCondition : " + deployCondition);
        // forward 정전개 || reverse 역전개
        String itemCode = request.getParameter("itemCode");
        System.out.println("itemCode : " + itemCode);
        // CodeController를 사용하여 검색한 후 선택하여 텍스트박스에 들어있던 값을 파라미터로 받아옴
        // ex) DK-01
        String itemClassificationCondition = request.getParameter("itemClassificationCondition");
        System.out.println("itemClassificationCondition : " + itemClassificationCondition);

        ArrayList<BomDeployTO> bomDeployList = stockService.getBomDeployList(deployCondition, itemCode,
                itemClassificationCondition);

        return bomDeployList;
    }

    @RequestMapping(value="/bom/info", method=RequestMethod.GET)
    public ArrayList<BomInfoTO> searchBomInfo(HttpServletRequest request, HttpServletResponse response) {

        String parentItemCode = request.getParameter("parentItemCode");
        System.out.println(parentItemCode);

        ArrayList<BomInfoTO> bomInfoList = stockService.getBomInfoList(parentItemCode);

        return bomInfoList;
    }

    /////////////////////////////////
//	@RequestMapping(value="/bom/info", method=RequestMethod.GET)
//	public ModelMap searchBomInfo(HttpServletRequest request, HttpServletResponse response) {
//		String parentItemCode = request.getParameter("parentItemCode");
//		System.out.println(parentItemCode);
//
//		map= new ModelMap();
//		try {
//			ArrayList<BomInfoTO> bomInfoList = stockService.getBomInfoList(parentItemCode);
//
//			map.put("gridRowJson", bomInfoList);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공");
//
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//
//		}
//
//		return map;
//	}

    @RequestMapping(value="/bom/available", method=RequestMethod.GET)
    public ModelMap searchAllItemWithBomRegisterAvailable(HttpServletRequest request, HttpServletResponse response) {
        map= new ModelMap();
        try {
            ArrayList<BomInfoTO> allItemWithBomRegisterAvailable = stockService.getAllItemWithBomRegisterAvailable();

            map.put("gridRowJson", allItemWithBomRegisterAvailable);
            map.put("errorCode", 1);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;
    }


    @RequestMapping(value="/bom/batch", method=RequestMethod.POST) //여기 수정 중임~~(2023-03-03)
    public ModelMap batchBomListProcess(@RequestBody ArrayList<BomTO> batchList) {
        map= new ModelMap();
        System.out.println(batchList);
        try {

            HashMap<String, Object> resultList = stockService.batchBomListProcess(batchList);

            map.put("result", resultList);
            map.put("errorCode", 1);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;
    }

//	@RequestMapping(value="/bom/batch", method=RequestMethod.POST) //여기 수정 중임~~(2023-03-03)
//	public ModelMap batchBomListProcess(@RequestBody HashMap<String, ArrayList<BomTO>> batchList) {
//		map= new ModelMap();
//		System.out.println(batchList);
//		ArrayList<BomTO> batchBomList = batchList.get("batchList");
//		try {
////			ArrayList<BomTO> batchBomList = gson.fromJson(batchList, new TypeToken<ArrayList<BomTO>>() {}.getType());
//			HashMap<String, Object> resultList = stockService.batchBomListProcess(batchBomList);
//
//			map.put("result", resultList);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공");
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}

//	@RequestMapping(value="/bom/batch", method=RequestMethod.POST)
//	public ModelMap batchBomListProcess(HttpServletRequest request, HttpServletResponse response) {
//		String batchList = request.getParameter("batchList");
//		map= new ModelMap();
//		ArrayList<BomTO> batchBomList = gson.fromJson(batchList, new TypeToken<ArrayList<BomTO>>() {
//		}.getType());
//		try {
//			HashMap<String, Object> resultList = stockService.batchBomListProcess(batchBomList);
//
//			map.put("result", resultList);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공");
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}

}
