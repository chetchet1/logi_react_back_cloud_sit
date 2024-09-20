package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.AddressTO;

@RestController
@RequestMapping("/compinfo/*")
public class AddressController {

	@Autowired
	private CompInfoService compInfoService;

	ModelMap map = null;
	
	@RequestMapping(value = "/address/list", method = RequestMethod.GET)
	public ModelMap searchAddressList(
			@RequestParam("sidoName") String sidoName,
			@RequestParam("searchAddressType") String searchAddressType,
			@RequestParam("searchValue") String searchValue,
			@RequestParam("mainNumber") String mainNumber
			) {

		try {
			ArrayList<AddressTO> addressList = compInfoService.getAddressList(sidoName, searchAddressType, searchValue,
					mainNumber);

			map.put("addressList", addressList);
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
