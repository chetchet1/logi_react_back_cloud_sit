package kr.co.seoulit.logistics.logiinfosvc.hr.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import kr.co.seoulit.logistics.logiinfosvc.hr.exception.IdNotFoundException;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.PwMissMatchException;
import kr.co.seoulit.logistics.logiinfosvc.hr.exception.PwNotFoundException;
import kr.co.seoulit.logistics.logiinfosvc.hr.service.HRService;
import kr.co.seoulit.logistics.logiinfosvc.hr.to.EmpInfoTO;

@RestController
@RequestMapping("/hr/*")
public class MemberLogInController {
    
	@Autowired
	private HRService hrService;
	
	ModelMap map = null;

	@RequestMapping(value="/login", method=RequestMethod.GET)
    public ModelMap LogInCheck(HttpServletRequest request, HttpServletResponse response) {
      //  String viewName = null;
		map = new ModelMap();
        
        try {
            HttpSession session = request.getSession();
            String companyCode = request.getParameter("companyCode");
            String workplaceCode = request.getParameter("workplaceCode");
            String userId = request.getParameter("userId");
            String userPassword = request.getParameter("userPassword");

            EmpInfoTO TO = hrService.accessToAuthority(companyCode, workplaceCode, userId, userPassword);
            
            System.out.println("로그인한사람 정보"+TO);
            
            if (TO != null) {       
                session.setAttribute("sessionID", session.getId());
                session.setAttribute("userId", TO.getUserId());
                session.setAttribute("empCode", TO.getEmpCode());
                session.setAttribute("empName", TO.getEmpName());
                session.setAttribute("deptCode", TO.getDeptCode());
                session.setAttribute("deptName", TO.getDeptName());
                session.setAttribute("positionCode", TO.getPositionCode());
                session.setAttribute("positionName", TO.getPositionName());
                session.setAttribute("companyCode", TO.getCompanyCode());
                session.setAttribute("workplaceCode", workplaceCode);
                session.setAttribute("workplaceName", TO.getWorkplaceName());
                session.setAttribute("image", TO.getImage());
                session.setAttribute("authorityGroupCode", TO.getUserAuthorityGroupList());    
                session.setAttribute("authorityGroupMenuList", TO.getUserAuthorityGroupMenuList());
                session.setAttribute("authorityGroupCode", TO.getAuthorityGroupList());    
                session.setAttribute("authorityGroupMenuList", TO.getAuthorityGroupMenuList());

                String[] allMenuList = hrService.getAllMenuList();
                session.setAttribute("allMenuList", allMenuList[0]);
                session.setAttribute("navMenuList", allMenuList[1]);
                session.setAttribute("allMenuList_b", allMenuList[2]);
            }

        } catch (IdNotFoundException e1) {   
            e1.printStackTrace();
            map.put("errorCode", -2);
            map.put("errorMsg", e1.getMessage());
        } catch (PwNotFoundException e2) {
            e2.printStackTrace();
            map.put("errorCode", -3);
            map.put("errorMsg", e2.getMessage());
        } catch (PwMissMatchException e3) {
            e3.printStackTrace();
            map.put("errorCode", -4);
            map.put("errorMsg", e3.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            map.put("errorCode", -5);
            map.put("errorMsg", e.getMessage());
        }

        return map;
    }
}
