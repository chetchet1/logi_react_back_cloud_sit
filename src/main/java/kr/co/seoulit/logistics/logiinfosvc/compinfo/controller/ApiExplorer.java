package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.json.XML;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

//import com.google.gson.Gson;
//import com.google.gson.GsonBuilder;

//import com.google.gson.Gson;
//import com.google.gson.GsonBuilder;

@Controller
@RequestMapping("/compinfo/*")
public class ApiExplorer {

	@RequestMapping(value = "/openapi", method = RequestMethod.GET)
	public ModelAndView apiExplorer(HttpServletRequest request, HttpServletResponse response) {
		ModelMap map = new ModelMap();
		BufferedReader br = null;
		ModelAndView mav = null;
		String result = null;
		//Gson gson = new GsonBuilder().serializeNulls().create(); // 속성값이 null 인 속성도 json 변환
		try {
			String pageNo = request.getParameter("pageNo");
			String numOfRows = request.getParameter("numOfRows");
			String startCreateDt = request.getParameter("startCreateDt");
			String endCreateDt = request.getParameter("endCreateDt");

			  String urlstr =
			  "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19SidoInfStateJson"
			  +
			  "?ServiceKey=6zVMxmw7BgNKh8EHAoYcJoKLa7zUg%2FAh92wsksSjivt2VEvqGKG7%2BSRlFMhP7hgWU2kV238R04RoLOEAIiQizw%3D%3D"
			  + "&pageNo="+pageNo+"&numOfRows="+numOfRows+"&startCreateDt="+startCreateDt+
			  "&endCreateDt="+endCreateDt;
			 

			/*
			 * String urlstr =
			 * "http://apis.data.go.kr/1262000/SafetyNewsList/getCountrySafetyNewsList" +
			 * "?ServiceKey=6zVMxmw7BgNKh8EHAoYcJoKLa7zUg%2FAh92wsksSjivt2VEvqGKG7%2BSRlFMhP7hgWU2kV238R04RoLOEAIiQizw%3D%3D"
			 * + "&pageNo=" + pageNo + "&numOfRows=" + numOfRows + "&startCreateDt=" +
			 * startCreateDt + "&endCreateDt=" + endCreateDt;
			 */

			URL url = new URL(urlstr);

			HttpURLConnection urlconnection = (HttpURLConnection) url.openConnection();
			urlconnection.setRequestMethod("GET");
			br = new BufferedReader(new InputStreamReader(urlconnection.getInputStream(), "UTF-8"));
			result = "";
			String line;
			while ((line = br.readLine()) != null) {
				result = result + line;
			}
			JSONObject xmlJSONObj = XML.toJSONObject(result.toString());
			map.put("gridRowJson", xmlJSONObj.toString());
			map.put("error_code", 0);
			map.put("error_msg", "성공!");
			
			mav = new ModelAndView("jsonView",map);
		} catch (UnsupportedEncodingException e) {
			map.put("error-code", -1);
			map.put("error-msg", "내부서버오류");
			e.printStackTrace();
		} catch (IOException e) {
			map.put("error-code", -1);
			map.put("error-msg", "내부서버오류");
			e.printStackTrace();
		} catch (Exception e) {
			map.put("error-code", -1);
			map.put("error-msg", "내부서버오류");
			e.printStackTrace();

		} finally {
			map.put("error-code", 0);
			map.put("error-msg", "성공");

		}
		return mav;
	}

}
