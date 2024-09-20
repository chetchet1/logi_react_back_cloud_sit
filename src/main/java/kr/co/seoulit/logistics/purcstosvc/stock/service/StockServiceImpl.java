package kr.co.seoulit.logistics.purcstosvc.stock.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import kr.co.seoulit.logistics.purcstosvc.stock.mapper.BomMapper;
import kr.co.seoulit.logistics.purcstosvc.stock.mapper.StockMapper;
import kr.co.seoulit.logistics.purcstosvc.stock.to.BomDeployTO;
import kr.co.seoulit.logistics.purcstosvc.stock.to.BomInfoTO;
import kr.co.seoulit.logistics.purcstosvc.stock.to.BomTO;
import kr.co.seoulit.logistics.purcstosvc.stock.to.StockChartTO;
import kr.co.seoulit.logistics.purcstosvc.stock.to.StockLogTO;
import kr.co.seoulit.logistics.purcstosvc.stock.to.StockTO;

@Service
public class StockServiceImpl implements StockService {

    @Autowired
    private BomMapper bomMapper;
    @Autowired
    private StockMapper stockMapper;

    @Override
    public ArrayList<BomDeployTO> getBomDeployList(String deployCondition, String itemCode,
                                                   String itemClassificationCondition) {


        HashMap<String, String> map = new HashMap<>();

        map.put("deployCondition", deployCondition);
        map.put("itemCode", itemCode);
        map.put("itemClassificationCondition", itemClassificationCondition);
        System.out.println(
                "!@###!@#@!#@!#@!#@!#!@#!@" + deployCondition + ":" + itemCode + ":" + itemClassificationCondition);
        return bomMapper.selectBomDeployList(map);

    }

    @Override
    public ArrayList<BomInfoTO> getBomInfoList(String parentItemCode) {

        ArrayList<BomInfoTO> bomInfoList = null;

        bomInfoList = bomMapper.selectBomInfoList(parentItemCode);

        return bomInfoList;
    }


    @Override
    public ArrayList<BomInfoTO> getAllItemWithBomRegisterAvailable() {

        ArrayList<BomInfoTO> allItemWithBomRegisterAvailable = null;

        allItemWithBomRegisterAvailable = bomMapper.selectAllItemWithBomRegisterAvailable();

        return allItemWithBomRegisterAvailable;
    }


    @Override
    public HashMap<String, Object> batchBomListProcess(ArrayList<BomTO> batchBomList) {

        HashMap<String, Object> resultMap = new HashMap<>();

        int insertCount = 0;
        int updateCount = 0;
        int deleteCount = 0;

        for (BomTO TO : batchBomList) {

            String status = TO.getStatus();

            switch (status) {

                case "INSERT":

                    bomMapper.insertBom(TO);

                    insertCount++;

                    break;

                case "UPDATE":

                    bomMapper.updateBom(TO);

                    updateCount++;

                    break;

                case "DELETE":

                    bomMapper.deleteBom(TO);

                    deleteCount++;

                    break;

            }

        }

        resultMap.put("INSERT", insertCount);
        resultMap.put("UPDATE", updateCount);
        resultMap.put("DELETE", deleteCount);

        return resultMap;

    }



    @Override
    public ArrayList<StockTO> getStockList() {

        ArrayList<StockTO> stockList = null;

        stockList = stockMapper.selectStockList();

        return stockList;
    }

    @Override
    public ArrayList<StockLogTO> getStockLogList(String startDate, String endDate) {

        ArrayList<StockLogTO> stockLogList = null;

        HashMap<String, String> map = new HashMap<>();

        map.put("startDate", startDate);
        map.put("endDate", endDate);

        stockLogList = stockMapper.selectStockLogList(map);

        return stockLogList;
    }


    @Override
    public HashMap<String, Object> warehousing(ArrayList<String> orderNoArr) {

        HashMap<String, Object> resultMap = new HashMap<>();

        String orderNoList = orderNoArr.toString().replace("[", "").replace("]", "");
        resultMap.put("orderNoList", orderNoList);
        stockMapper.warehousing(resultMap);

        return resultMap;

    }


    @Override
    public ModelMap changeSafetyAllowanceAmount(String itemCode, String itemName,
                                                String safetyAllowanceAmount) {

        ModelMap resultMap = null;

        HashMap<String, String> map = new HashMap<>();

        map.put("itemCode", itemCode);
        map.put("itemName", itemName);
        map.put("safetyAllowanceAmount", safetyAllowanceAmount);

        resultMap = stockMapper.updatesafetyAllowance(map);

        return resultMap;
    }


    @Override
    public ArrayList<StockChartTO> getStockChart() {

        ArrayList<StockChartTO> stockChart = null;

        stockChart = stockMapper.selectStockChart();

        return stockChart;

    }

    @Override
    public ArrayList<StockTO> getWarehouseStockList(String warehouseCode) {

        ArrayList<StockTO> stockList = null;

        stockList = stockMapper.selectWarehouseStockList(warehouseCode);

        return stockList;
    }

    @Override
    public void batchStockProcess(ArrayList<StockTO> stockTOList) {

        for (StockTO bean : stockTOList) {

            String status = bean.getStatus();

            switch (status) {

                case "DELETE":
                    stockMapper.deleteStock(bean);
                    break;

                case "INSERT":
                    stockMapper.insertStock(bean);
                    break;

                case "UPDATE":
                    stockMapper.updateStock(bean);
            }

        }

    }

    // 원재료 검사 추가
    @Override
    public void inspection(String orderNoList) {

        HashMap<String, String> param = new HashMap<>();
        param.put("orderNoList", orderNoList);

        stockMapper.inspection(param);
    }

}
