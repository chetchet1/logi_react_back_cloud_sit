package kr.co.seoulit.logistics.logiinfosvc.hr.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ShowErrorPageController {
	
	ModelAndView mav = null;
	ModelMap map = null;

	public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) {

		String viewName = "redirect:" + request.getContextPath() + "/hello3/view";

		ModelMap model = new ModelMap();

		if (request.getRequestURI().contains("accessDenied")) {
			model.put("errorCode", -1);
			model.put("errorTitle", "Access Denied");
			model.put("errorMsg", "액세스 거부되었습니다");
			viewName = "errorPage";
		}

		mav = new ModelAndView(viewName, model);

		return mav;
	}

}
