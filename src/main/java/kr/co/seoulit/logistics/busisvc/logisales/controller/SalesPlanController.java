package kr.co.seoulit.logistics.busisvc.logisales.controller;

import java.util.ArrayList;
//************************* 2020.08.27 63기 양지훈 수정 시작 *************************
//description:	HashMap, LinkedHashMap, Map, ObjectMapper, Gson, GsonBuilder  import
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.introspect.VisibilityChecker;
import kr.co.seoulit.logistics.busisvc.logisales.service.SalesService;
import kr.co.seoulit.logistics.busisvc.logisales.to.SalesPlanTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

@CrossOrigin
@RestController
@RequestMapping("/logi/sales/*")

public class SalesPlanController {

    @Autowired
    private SalesService salesService;

    private ModelMap modelMap = new ModelMap();

    @RequestMapping(value="/save" , method= RequestMethod.POST)
    public ModelMap saleSave(@RequestBody Map<String, Object> params) {
        ObjectMapper mapper = new ObjectMapper();
        mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
        mapper.setVisibilityChecker(
                VisibilityChecker.Std.defaultInstance().withFieldVisibility(JsonAutoDetect.Visibility.ANY));
        SalesPlanTO newSalesInfo = mapper.convertValue(params.get("data"), SalesPlanTO.class);
        System.out.println("params.toString() = " + params.toString());
        System.out.println(newSalesInfo);
        try {
            HashMap<String, Object> resultList = salesService.addNewSales(newSalesInfo);

            modelMap.put("result", resultList);
            modelMap.put("errorCode", 1);
            modelMap.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            modelMap.put("errorCode", -1);
            modelMap.put("errorMsg", e1.getMessage());
        }
        return modelMap;
    }


    @RequestMapping(value="/remove", method=RequestMethod.DELETE)
    public ModelMap deleteSalesInfo(
            @RequestBody Map<String, Object> params
    ) {

        modelMap = new ModelMap();
        String str = params.toString();
        String no = str.substring(13,25);
        System.out.println(  params.get("salesplanNo"));
        System.out.println(str);
        System.out.println(no);
        System.out.println("삭제!@@!@@@!@!@!@!@!@!"+params);
        try {

            HashMap<String, Object> resultList = salesService.removeSales(no);

            // modelMap.put("result", resultList);
            modelMap.put("errorCode", 1);
            modelMap.put("errorMsg", "성공");

        } catch (Exception e1) {
            e1.printStackTrace();
            modelMap.put("errorCode", -1);
            modelMap.put("errorMsg", e1.getMessage());
        }
        return modelMap;
    }


    @RequestMapping("/searchSalesPlan")
    public ModelMap searchSalesPlanInfo(@RequestParam String startDate, @RequestParam String endDate,
                                        @RequestParam String salesPlanDate) {


        System.out.println(startDate);
        System.out.println(endDate);
        System.out.println(salesPlanDate);

        try {

            ArrayList<SalesPlanTO> salesPlanTOList = salesService.getSalesPlanList(salesPlanDate, startDate, endDate);

            modelMap.put("gridRowJson", salesPlanTOList);
            modelMap.put("errorCode", 1);
            modelMap.put("errorMsg", "성공");

        } catch (Exception e2) {
            e2.printStackTrace();
            modelMap.put("errorCode", -2);
            modelMap.put("errorMsg", e2.getMessage());

        }

        return modelMap;
    }


}
