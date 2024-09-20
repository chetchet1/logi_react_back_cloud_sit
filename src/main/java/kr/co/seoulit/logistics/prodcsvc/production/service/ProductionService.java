package kr.co.seoulit.logistics.prodcsvc.production.service;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.seoulit.logistics.busisvc.logisales.to.ContractDetailInMpsAvailableTO;
import kr.co.seoulit.logistics.prodcsvc.production.to.MpsTO;
import kr.co.seoulit.logistics.prodcsvc.production.to.MrpGatheringTO;
import kr.co.seoulit.logistics.prodcsvc.production.to.MrpTO;
import kr.co.seoulit.logistics.prodcsvc.production.to.SalesPlanInMpsAvailableTO;

public interface ProductionService {

	public ArrayList<MpsTO> getMpsList(String startDate, String endDate, String includeMrpApply);

	public ArrayList<ContractDetailInMpsAvailableTO>
	getContractDetailListInMpsAvailable(String searchCondition, String startDate, String endDate);

	public ArrayList<ContractDetailInMpsAvailableTO>
	getContractDetailListInProcessPlanAvailable(String searchCondition, String startDate, String endDate);

	public ArrayList<SalesPlanInMpsAvailableTO>
	getSalesPlanListInMpsAvailable(String searchCondition, String startDate, String endDate);

//	public HashMap<String, Object> convertContractDetailToMps(			//MPS 등록
//																		  ContractDetailInMpsAvailableTO ContractDetailInMpsAvailableTO);

	public HashMap<String, Object> convertContractDetailToMps(            //MPS 등록
																		  ContractDetailInMpsAvailableTO batchList);


	public HashMap<String, Object> convertSalesPlanToMps(
			ArrayList<SalesPlanInMpsAvailableTO> salesPlanInMpsAvailableList);

	public HashMap<String, Object> batchMpsListProcess(ArrayList<MpsTO> mpsTOList);

	public ArrayList<MrpTO> searchMrpList(String mrpGatheringStatusCondition);

	public ArrayList<MrpTO> selectMrpListAsDate(String dateSearchCondtion, String startDate, String endDate);  // MRP - MPS 조회 버튼 클릭시

	public ArrayList<MrpTO> searchMrpListAsMrpGatheringNo(String mrpGatheringNo);

	public ArrayList<MrpGatheringTO> searchMrpGatheringList(String dateSearchCondtion, String startDate, String endDate);

	public HashMap<String, Object> openMrp(ArrayList<String> mpsNoArr);

	public HashMap<String, Object> registerMrp(String mrpRegisterDate,
											   ArrayList<String> mpsList);

	public HashMap<String, Object> batchMrpListProcess(ArrayList<MrpTO> mrpTOList);

	public ArrayList<MrpGatheringTO> getMrpGathering(ArrayList<String> mrpNoArr);

	public HashMap<String, Object> registerMrpGathering(String mrpGatheringRegisterDate, ArrayList<String> mrpNoArr,HashMap<String, String> mrpNoAndItemCodeMap);

}

