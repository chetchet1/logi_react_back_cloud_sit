package kr.co.seoulit.logistics.sys.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

@SuppressWarnings("deprecation")
public class LoginInterceptor extends HandlerInterceptorAdapter{
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();
//		String userId = (String)session.getAttribute("userId");
		String userId = "짜장면";
		System.out.print(userId+"님이 접속하였습니다.");
		if(userId == null) {
			response.sendRedirect("/logiinfo/loginForm/view");
			System.out.print("로그인이 필요함");
			return false;
		}else {
			return true;
		}
	}
}
