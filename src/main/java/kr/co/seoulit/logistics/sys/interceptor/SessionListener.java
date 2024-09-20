package kr.co.seoulit.logistics.sys.interceptor;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionListener implements HttpSessionListener{
	
	private int userCount = 0;
	
	public void sessionCreated(HttpSessionEvent se) {
		if(userCount < 0) {
			userCount = 0;
		}else {
			++userCount;
		}
		HttpSession session = se.getSession();
		session.setAttribute("userCount", userCount);
		
		System.out.println("생성된 SESSION ID : " + se.getSession().getId());
		System.out.println("===========로그인 된 사용자 수 : " + userCount);
	}
	
	public void sessionDestroyed(HttpSessionEvent se) {
		if(userCount <1) {
			userCount = 0;
		}else {
			--userCount;
		}
		
		HttpSession session = se.getSession();
		session.setAttribute("userCount", userCount);
		
		System.out.println("제거된 SESSION ID : " + se.getSession().getId());
		System.out.println("===========로그인 된 사용자 수 : " + userCount);
	}

}
