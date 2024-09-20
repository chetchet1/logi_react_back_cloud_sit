package kr.co.seoulit.logistics.busisvc.logisales.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.seoulit.logistics.busisvc.logisales.to.SalesPlanTO;
import kr.co.seoulit.logistics.prodcsvc.production.to.SalesPlanInMpsAvailableTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SalesPlanMapper {
	public ArrayList<SalesPlanTO> selectSalesPlanList(HashMap<String, String> map);

	public int selectSalesPlanCount(String salesPlanDate);

	public ArrayList<SalesPlanInMpsAvailableTO>
		selectSalesPlanListInMpsAvailable(HashMap<String, String> map);

	public void insertSalesPlan(SalesPlanTO TO);

	public void updateSalesPlan(SalesPlanTO TO);

	public void changeMpsStatusOfSalesPlan(HashMap<String, String> map);

	public void deleteSalesPlan(String delete);

}
