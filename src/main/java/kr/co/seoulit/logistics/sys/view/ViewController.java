package kr.co.seoulit.logistics.sys.view;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ViewController {

	@RequestMapping(value="/{viewName}/view")
	public String view(@PathVariable String viewName) {
		System.out.println("###########################"+"/"+viewName);
		return viewName;
	}

	@RequestMapping(value="/{pack}/{viewName}/view")
	public String packView(@PathVariable String pack, @PathVariable String viewName) {
		System.out.println("##############"+pack+"################"+"/"+viewName);
		return pack+"/"+viewName;
	}

}
