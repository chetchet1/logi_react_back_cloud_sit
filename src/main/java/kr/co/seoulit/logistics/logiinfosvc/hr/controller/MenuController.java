package kr.co.seoulit.logistics.logiinfosvc.hr.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.hr.service.HRService;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.MenuAuthorityTO;

@RestController
@RequestMapping("/hr/*")
public class MenuController {
	

	@Autowired
	private HRService hrService;
	
	ModelMap map = null;
	
	private static Gson gson = new GsonBuilder().serializeNulls().create();
	
	@RequestMapping(value="/menu/authority", method=RequestMethod.POST)
	public ModelMap insertMenuAuthority(HttpServletRequest request, HttpServletResponse response) {
		String authorityGroupCode = request.getParameter("authorityGroupCode");
		String insertDataList = request.getParameter("insertData");
		map = new ModelMap();
		ArrayList<MenuAuthorityTO> menuAuthorityTOList = gson.fromJson(insertDataList,
				new TypeToken<ArrayList<MenuAuthorityTO>>() {}.getType());
		try {
			hrService.insertMenuAuthority(authorityGroupCode, menuAuthorityTOList);
			
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
	
	@RequestMapping(value="/menu/authority", method=RequestMethod.GET)
	public ModelMap getMenuAuthority(HttpServletRequest request, HttpServletResponse response) {
		String authorityGroupCode = request.getParameter("authorityGroupCode");
		map = new ModelMap();
		try {
			ArrayList<MenuAuthorityTO> menuAuthorityTOList = hrService.getMenuAuthority(authorityGroupCode);
			
			map.put("gridRowJson", menuAuthorityTOList);
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
