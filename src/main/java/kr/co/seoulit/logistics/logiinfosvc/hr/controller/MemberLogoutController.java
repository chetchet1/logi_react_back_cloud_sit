package kr.co.seoulit.logistics.logiinfosvc.hr.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/hr/*")
public class MemberLogoutController {
	
	@RequestMapping(value="/logout", method=RequestMethod.GET)
    public ModelAndView LogOut(HttpServletRequest request, HttpServletResponse response) {

        HttpSession session = request.getSession();
        session.invalidate();

        return new ModelAndView("/logiinfo/loginForm");
    }
}
