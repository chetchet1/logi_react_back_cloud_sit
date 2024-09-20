package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.CodeDetailEntity;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.JpaCompInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CodeDetailTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CodeTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.ImageTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.LatLngTO;

@CrossOrigin("*")
@RestController
@RequestMapping("/compinfo/*")
public class CodeController {

	@Autowired
	private CompInfoService compInfoService;
	@Autowired
	private JpaCompInfoService jpaCompInfoService;

	ModelMap map = null;

	private static Gson gson = new GsonBuilder().serializeNulls().create();

	/*은비 수정*/
	@RequestMapping(value = "/codedetail/list", method = RequestMethod.GET)
	public ModelMap findCodeDetailList(@RequestParam("divisionCodeNo") String CodeDetail) { //RequestParam(divisionCode) => RequestParam(divisionCodeNo) 변경
		System.out.println("findCodeDetailList메서드");
		System.out.println(CodeDetail);
		map = new ModelMap();
		try {
			ArrayList<CodeDetailEntity> codeLists = jpaCompInfoService.getCodeDetailList(CodeDetail);

			map.put("codeList", codeLists);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
//   @RequestMapping(value = "/codedetail/list", method = RequestMethod.GET)
//   public ModelMap findCodeDetailList( HttpServletRequest request, HttpServletResponse response) {
//      String CodeDetail  = request.getParameter("divisionCodeNo");
//      map = new ModelMap();
//      try {
//         ArrayList<CodeDetailTO> codeLists = compInfoService.getCodeDetailList(CodeDetail);
//
//         map.put("codeList", codeLists);
//         map.put("errorCode", 1);
//         map.put("errorMsg", "성공");
//      } catch (Exception e1) {
//         e1.printStackTrace();
//         map.put("errorCode", -1);
//         map.put("errorMsg", e1.getMessage());
//      }
//      return map;
//   }

	@RequestMapping(value = "/codeInfo", method = RequestMethod.POST)
	public ModelMap addCodeInFormation(HttpServletRequest request, HttpServletResponse response) {

		System.out.println("addCodeInFormation메서드");

		String newcodeInfo = request.getParameter("newCodeInfo");
		System.out.println(newcodeInfo);

		map = new ModelMap();
		try {
			ArrayList<CodeTO> CodeTOList = gson.fromJson(newcodeInfo,
					new TypeToken<ArrayList<CodeTO>>() {}.getType());

			compInfoService.addCodeInFormation(CodeTOList);

			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value = "/code/list", method = RequestMethod.GET)
	public ModelMap findCodeList(HttpServletRequest request, HttpServletResponse response) {
		map = new ModelMap();
		try {
			ArrayList<CodeTO> codeList = compInfoService.getCodeList();

			map.put("codeList", codeList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value = "/codedetail2/list", method = RequestMethod.POST)
	public ModelMap findDetailCodeList(HttpServletRequest request, HttpServletResponse response) {

		System.out.println("findDetailCodeList메서드");

		String divisionCode = request.getParameter("divisionCodeNo");
		map = new ModelMap();
		try {
			ArrayList<CodeDetailTO> detailCodeList = compInfoService.getDetailCodeList(divisionCode);

			map.put("detailCodeList", detailCodeList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

//	@RequestMapping(value = "/code/duplication", method = RequestMethod.GET)
//	public ModelMap checkCodeDuplication(HttpServletRequest request, HttpServletResponse response) {
//		String divisionCode = request.getParameter("divisionCode");
//		String newDetailCode = request.getParameter("newCode");
//		map = new ModelMap();
//		try {
//			Boolean flag = compInfoService.checkCodeDuplication(divisionCode, newDetailCode);
//
//			map.put("result", flag);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공");
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}

	@RequestMapping(value = "/code/batch", method = RequestMethod.POST)
	public ModelMap batchListProcess(@RequestBody HashMap<String, ArrayList<CodeTO>> batchList) {


		System.out.println("batchListProcess메서드@@@" + batchList);


//		String batchList = request.getParameter("batchList");
//		String tableName = request.getParameter("tableName");
		map = new ModelMap();
		try {
//			ArrayList<CodeTO> codeList = null;
//			ArrayList<CodeDetailTO> detailCodeList = null;
//			HashMap<String, Object> resultMap = null;
//			if (tableName.equals("CODE")) {
//				codeList = gson.fromJson(batchList, new TypeToken<ArrayList<CodeTO>>() {
//				}.getType());
//				resultMap = compInfoService.batchCodeListProcess(codeList);
//			} else if (tableName.equals("CODE_DETAIL")) {
//				detailCodeList = gson.fromJson(batchList, new TypeToken<ArrayList<CodeDetailTO>>() {
//				}.getType());
//				resultMap = compInfoService.batchDetailCodeListProcess(detailCodeList);
//			}
//			map.put("result", resultMap);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공");
		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
		}
		return map;
	}


	@RequestMapping(value = "/code", method = RequestMethod.PUT)
	public ModelMap changeCodeUseCheckProcess(HttpServletRequest request, HttpServletResponse response) {
		String batchList = request.getParameter("batchList");
		map = new ModelMap();
		try {
			ArrayList<CodeDetailTO> detailCodeList = null;
			HashMap<String, Object> resultMap = null;

			detailCodeList = gson.fromJson(batchList, new TypeToken<ArrayList<CodeDetailTO>>() {
			}.getType());
			resultMap = compInfoService.changeCodeUseCheckProcess(detailCodeList);

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

	//창고 위도 경도 가져오기
	@RequestMapping(value = "/code/latlng", method = RequestMethod.GET)
	public ModelMap findLatLngList(HttpServletRequest request, HttpServletResponse response) {

		String wareHouseCodeNo = request.getParameter("wareHouseCodeNo");

		map = new ModelMap();

		try {
			ArrayList<LatLngTO> detailCodeList = compInfoService.getLatLngList(wareHouseCodeNo);

			map.put("detailCodeList", detailCodeList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	//이미지 띄우기
	@RequestMapping(value = "/code/itemimage", method = RequestMethod.GET)
	public ModelMap findDetailImageList(HttpServletRequest request, HttpServletResponse response) {

		String itemGroupCodeNo = request.getParameter("itemGroupCodeNo");

		map = new ModelMap();

		try {
			ArrayList<ImageTO> detailCodeList = compInfoService.getDetailItemList(itemGroupCodeNo);

			map.put("detailCodeList", detailCodeList);
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