package kr.co.seoulit.logistics.prodcsvc.production.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.seoulit.logistics.busisvc.logisales.mapper.ContractMapper;
import kr.co.seoulit.logistics.busisvc.logisales.to.ContractDetailInMpsAvailableTO;
import kr.co.seoulit.logistics.busisvc.logisales.mapper.SalesPlanMapper;
import kr.co.seoulit.logistics.prodcsvc.production.mapper.MpsMapper;
import kr.co.seoulit.logistics.prodcsvc.production.mapper.MrpMapper;
import kr.co.seoulit.logistics.prodcsvc.production.to.MpsTO;
import kr.co.seoulit.logistics.prodcsvc.production.to.MrpGatheringTO;
import kr.co.seoulit.logistics.prodcsvc.production.to.MrpTO;
import kr.co.seoulit.logistics.prodcsvc.production.to.SalesPlanInMpsAvailableTO;
import org.json.JSONObject;


@Service
public class ProductionServiceImpl implements ProductionService {

	@Autowired
	private MpsMapper mpsMapper;
	@Autowired
	private ContractMapper contractMapper;
	@Autowired
	private SalesPlanMapper salesPlanMapper;
	@Autowired
	private MrpMapper mrpMapper;

	@Override
	public ArrayList<MpsTO> getMpsList(String startDate, String endDate, String includeMrpApply) {

		ArrayList<MpsTO> mpsTOList = null;

		HashMap<String, String> map = new HashMap<>();

		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("includeMrpApply", includeMrpApply);

		mpsTOList = mpsMapper.selectMpsList(map);

		return mpsTOList;
	}


	@Override
	public ArrayList<ContractDetailInMpsAvailableTO> getContractDetailListInMpsAvailable(String searchCondition,
																						 String startDate, String endDate) {

		ArrayList<ContractDetailInMpsAvailableTO> contractDetailInMpsAvailableList = null;

		HashMap<String, String> map = new HashMap<>();

		map.put("searchCondition", searchCondition);
		map.put("startDate", startDate);
		map.put("endDate", endDate);

		contractDetailInMpsAvailableList = contractMapper.selectContractDetailListInMpsAvailable(map);

		return contractDetailInMpsAvailableList;

	}

	public ArrayList<ContractDetailInMpsAvailableTO> getContractDetailListInProcessPlanAvailable(String searchCondition,
																								 String startDate, String endDate) {

		ArrayList<ContractDetailInMpsAvailableTO> contractDetailInProcessPlanAvailableList = null;

		HashMap<String, String> map = new HashMap<>();

		map.put("searchCondition", searchCondition);
		map.put("startDate", startDate);
		map.put("endDate", endDate);

		contractDetailInProcessPlanAvailableList = contractMapper.selectContractDetailListInProcessPlanAvailable(map);

		return contractDetailInProcessPlanAvailableList;

	}



	@Override
	public ArrayList<SalesPlanInMpsAvailableTO> getSalesPlanListInMpsAvailable(String searchCondition,
																			   String startDate, String endDate) {

		ArrayList<SalesPlanInMpsAvailableTO> salesPlanInMpsAvailableList = null;

		HashMap<String, String> map = new HashMap<>();

		map.put("searchCondition", searchCondition);
		map.put("startDate", startDate);
		map.put("endDate", endDate);

		salesPlanInMpsAvailableList = salesPlanMapper.selectSalesPlanListInMpsAvailable(map);

		return salesPlanInMpsAvailableList;

	}

	@Override
	public HashMap<String, Object> convertContractDetailToMps(
			ContractDetailInMpsAvailableTO batchList) {

		System.out.println("MPS 등록 ServiceImpl");

		HashMap<String, Object> resultMap = null;

		ArrayList<MpsTO> mpsTOList = new ArrayList<>();

		MpsTO newMpsBean = null;

		newMpsBean = new MpsTO();

		newMpsBean.setStatus("INSERT");



		newMpsBean.setMpsPlanClassification(batchList.getPlanClassification());
		newMpsBean.setContractDetailNo(batchList.getContractDetailNo());
		newMpsBean.setItemCode(batchList.getItemCode());
		newMpsBean.setItemName(batchList.getItemName());
		newMpsBean.setUnitOfMps(batchList.getUnitOfContract());
		newMpsBean.setMpsPlanDate(batchList.getMpsPlanDate());
		newMpsBean.setMpsPlanAmount(batchList.getProductionRequirement());
		newMpsBean.setDueDateOfMps(batchList.getDueDateOfContract());
		newMpsBean.setScheduledEndDate(batchList.getScheduledEndDate());
		newMpsBean.setDescription(batchList.getDescription());


		mpsTOList.add(newMpsBean);

		resultMap = batchMpsListProcess(mpsTOList); //batchMpsListProcess 메소드 호출

		System.out.println("Impl 지남");
		return resultMap;

	}

//	@Override
//	public HashMap<String, Object> convertContractDetailToMps(
//			ContractDetailInMpsAvailableTO contractDetailInMpsAvailableTO) {
//
//		System.out.println("MPS 등록 ServiceImpl");
//
//		HashMap<String, Object> resultMap = null;
//
//		ArrayList<MpsTO> mpsTOList = new ArrayList<>();
//
//		MpsTO newMpsBean = null;
//
//
//		System.out.println("convertContractDetailToMps ApplicationServiceImpl접근----------------------------"
//				+ contractDetailInMpsAvailableTO.getContractDetailNo());
//		newMpsBean = new MpsTO();
//
//		newMpsBean.setStatus("INSERT");
//
//		newMpsBean.setMpsPlanClassification(contractDetailInMpsAvailableTO.getPlanClassification());
//		newMpsBean.setContractDetailNo(contractDetailInMpsAvailableTO.getContractDetailNo());
//		newMpsBean.setItemCode(contractDetailInMpsAvailableTO.getItemCode());
//		newMpsBean.setItemName(contractDetailInMpsAvailableTO.getItemName());
//		newMpsBean.setUnitOfMps(contractDetailInMpsAvailableTO.getUnitOfContract());
//		newMpsBean.setMpsPlanDate(contractDetailInMpsAvailableTO.getMpsPlanDate());
//		newMpsBean.setMpsPlanAmount(contractDetailInMpsAvailableTO.getProductionRequirement());
//		newMpsBean.setDueDateOfMps(contractDetailInMpsAvailableTO.getDueDateOfContract());
//		newMpsBean.setScheduledEndDate(contractDetailInMpsAvailableTO.getScheduledEndDate());
//		newMpsBean.setDescription(contractDetailInMpsAvailableTO.getDescription());
//
//		mpsTOList.add(newMpsBean);
//
//
//
//		resultMap = batchMpsListProcess(mpsTOList); //batchMpsListProcess 메소드 호출
//
//		System.out.println("Impl 지남");
//		return resultMap;
//
//	}

	@Override
	public HashMap<String, Object> convertSalesPlanToMps(
			ArrayList<SalesPlanInMpsAvailableTO> salesPlanInMpsAvailableList) {

		HashMap<String, Object> resultMap = null;

		ArrayList<MpsTO> mpsTOList = new ArrayList<>();

		MpsTO newMpsBean = null;

		for (SalesPlanInMpsAvailableTO bean : salesPlanInMpsAvailableList) {

			newMpsBean = new MpsTO();

			newMpsBean.setStatus("INSERT");

			newMpsBean.setMpsPlanClassification(bean.getPlanClassification());
			newMpsBean.setSalesPlanNo(bean.getSalesPlanNo());
			newMpsBean.setItemCode(bean.getItemCode());
			newMpsBean.setItemName(bean.getItemName());
			newMpsBean.setUnitOfMps(bean.getUnitOfSales());
			newMpsBean.setMpsPlanDate(bean.getMpsPlanDate());
			newMpsBean.setMpsPlanAmount(bean.getSalesAmount());
			newMpsBean.setDueDateOfMps(bean.getDueDateOfSales());
			newMpsBean.setScheduledEndDate(bean.getScheduledEndDate());
			newMpsBean.setDescription(bean.getDescription());

			mpsTOList.add(newMpsBean);

		}

		resultMap = batchMpsListProcess(mpsTOList);

		return resultMap;

	}

	@Override
	public HashMap<String, Object> batchMpsListProcess(ArrayList<MpsTO> mpsTOList) {

		HashMap<String, Object> resultMap = null;
		resultMap = new HashMap<>();
		System.out.println("application다음으로 옮겨온곳 = " + mpsTOList);
		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		for (MpsTO bean : mpsTOList) {

			String status = bean.getStatus();

			System.out.println("bean에서 뽑아낸 status의 값은 ::::::::::" + status);

			switch (status) {

				case "INSERT":

					String newMpsNo = getNewMpsNo(bean.getMpsPlanDate());

					bean.setMpsNo(newMpsNo);

					mpsMapper.insertMps(bean);

					insertList.add(newMpsNo);

					if (bean.getContractDetailNo() != null) {

						changeMpsStatusInContractDetail(bean.getContractDetailNo(), "Y");

					} else if (bean.getSalesPlanNo() != null) {

						changeMpsStatusInSalesPlan(bean.getSalesPlanNo(), "Y");

					}

					break;

				case "UPDATE":

					mpsMapper.updateMps(bean);

					updateList.add(bean.getMpsNo());

					break;

				case "DELETE":

					mpsMapper.deleteMps(bean);

					deleteList.add(bean.getMpsNo());

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;

	}

	@Override
	public ArrayList<MrpTO> searchMrpList(String mrpGatheringStatusCondition) {

		ArrayList<MrpTO> mrpList = null;

		mrpList = mrpMapper.selectMrpList(mrpGatheringStatusCondition);

		return mrpList;

	}

	@Override
	public ArrayList<MrpTO> selectMrpListAsDate(String dateSearchCondtion, String startDate, String endDate) {  // MRP - MPS 조회 버튼 클릭시

		ArrayList<MrpTO> mrpList = null;

		HashMap<String, String> map = new HashMap<>();

		map.put("dateSearchCondtion", dateSearchCondtion);
		map.put("startDate", startDate);
		map.put("endDate", endDate);

		mrpList = mrpMapper.selectMrpListAsDate(map);

		return mrpList;
	}

	@Override
	public ArrayList<MrpTO> searchMrpListAsMrpGatheringNo(String mrpGatheringNo) {

		ArrayList<MrpTO> mrpList = null;

		mrpList = mrpMapper.selectMrpListAsMrpGatheringNo(mrpGatheringNo);

		return mrpList;
	}

	@Override
	public ArrayList<MrpGatheringTO> searchMrpGatheringList(String dateSearchCondtion, String startDate,
															String endDate) {

		ArrayList<MrpGatheringTO> mrpGatheringList = null;

		HashMap<String, String> map = new HashMap<>();

		map.put("searchDateCondition", dateSearchCondtion);
		map.put("startDate", startDate);
		map.put("endDate", endDate);

		System.out.println("map = " + map);

		System.out.println("여기오냐?");

		mrpGatheringList = mrpMapper.selectMrpGatheringList(map);
		
		for(MrpGatheringTO bean : mrpGatheringList)    {

			bean.setMrpTOList(  mrpMapper.selectMrpListAsMrpGatheringNo( bean.getMrpGatheringNo()) );

		}

		return mrpGatheringList;
	}

	@Override
	public HashMap<String, Object> openMrp(ArrayList<String> mpsNoArr) {

		String mpsNoList = mpsNoArr.get(0);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		HashMap<String, String> map = new HashMap<String, String>();

		map.put("mpsNoList", mpsNoList);

		mrpMapper.openMrp(map);

		System.out.println(map);

		resultMap.put("result", map.get("RESULT"));
		resultMap.put("errorCode",map.get("ERROR_CODE"));
		resultMap.put("errorMsg", map.get("ERROR_MSG"));

		return resultMap;
	}

	@Override
	public HashMap<String, Object> registerMrp(String mrpRegisterDate, ArrayList<String> mpsList) {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put("mrpRegisterDate", mrpRegisterDate);

		mrpMapper.insertMrpList(map);



		resultMap.put("result", map.get("RESULT"));
		resultMap.put("errorCode", map.get("ERROR_CODE"));
		resultMap.put("errorMsg", map.get("ERROR_MSG"));

		for (String jsonString : mpsList) {
			JSONObject jsonObject = new JSONObject(jsonString);
			String mpsNo = jsonObject.getString("mpsNo");
			System.out.println("mpsNoValue = " + mpsNo);
			HashMap<String, String> mpsMap = new HashMap<>();

			mpsMap.put("mpsNo", mpsNo);
			mpsMap.put("mrpStatus", "Y");

			mpsMapper.changeMrpApplyStatus(mpsMap);

		}

		return resultMap;
	}

	@Override
	public HashMap<String, Object> batchMrpListProcess(ArrayList<MrpTO> mrpTOList) {

		HashMap<String, Object> resultMap = new HashMap<>();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		for (MrpTO bean : mrpTOList) {

			String status = bean.getStatus();

			switch (status) {

				case "INSERT":

					mrpMapper.insertMrp(bean);

					insertList.add(bean.getMrpNo());

					break;

				case "UPDATE":

					mrpMapper.updateMrp(bean);

					updateList.add(bean.getMrpNo());

					break;

				case "DELETE":

					mrpMapper.deleteMrp(bean);

					deleteList.add(bean.getMrpNo());

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public ArrayList<MrpGatheringTO> getMrpGathering(ArrayList<String> mrpNoArr) {
	
		ArrayList<MrpGatheringTO> mrpGatheringList = null;
		System.out.println("mrpNoArr = " + mrpNoArr);
		String mrpNoList = mrpNoArr.toString().replace("[", "").replace("]", "");
		mrpGatheringList = mrpMapper.getMrpGathering(mrpNoList);

		return mrpGatheringList;
	}

	@Override
	public HashMap<String, Object> registerMrpGathering(String mrpGatheringRegisterDate,ArrayList<String> mrpNoArr,HashMap<String, String> mrpNoAndItemCodeMap) {

		HashMap<String, Object> resultMap = null;
		int seq=0;
		ArrayList<MrpGatheringTO> mrpGatheringList = null;
		int i=1;
		List<MrpGatheringTO> list= mrpMapper.selectMrpGatheringCount(mrpGatheringRegisterDate);

		TreeSet<Integer> intSet = new TreeSet<>();
		for(MrpGatheringTO bean : list) {
			String mrpGatheringNo = bean.getMrpGatheringNo();
			int no = Integer.parseInt(mrpGatheringNo.substring(mrpGatheringNo.length() - 2, mrpGatheringNo.length()));
			intSet.add(no);
		}
		if (!intSet.isEmpty()) {
			i=intSet.pollLast() + 1;
		}

		HashMap<String, String> itemCodeAndMrpGatheringNoMap = new HashMap<>();

		StringBuffer newMrpGatheringNo = new StringBuffer();
		newMrpGatheringNo.append("MG");
		newMrpGatheringNo.append(mrpGatheringRegisterDate.replace("-", ""));
		newMrpGatheringNo.append("-");

		System.out.println("여기까지 오나요1");
		seq=mrpMapper.getMGSeqNo();

		mrpGatheringList = getMrpGathering(mrpNoArr);

		for (MrpGatheringTO bean : mrpGatheringList) {
			bean.setMrpGatheringNo(newMrpGatheringNo.toString() + String.format("%03d", i++));
			bean.setStatus("INSERT");
			bean.setMrpGatheringSeq(seq);

			itemCodeAndMrpGatheringNoMap.put(bean.getItemCode(), bean.getMrpGatheringNo());

		}
		System.out.println("여기까지 오나요2");
		resultMap = batchMrpGatheringListProcess(mrpGatheringList);

		TreeSet<String> mrpGatheringNoSet = new TreeSet<>();

		@SuppressWarnings("unchecked")
		HashMap<String, String> mrpGatheringNoList = (HashMap<String, String>) resultMap.get("INSERT_MAP");//key(ItemCode):value(소요량취합번호)

		for (String mrpGatheringNo : mrpGatheringNoList.values()) {

			mrpGatheringNoSet.add(mrpGatheringNo);

		}

		resultMap.put("firstMrpGatheringNo", mrpGatheringNoSet.pollFirst());
		resultMap.put("lastMrpGatheringNo", mrpGatheringNoSet.pollLast());

		for (String mrpNo : mrpNoAndItemCodeMap.keySet()) {
			String itemCode = mrpNoAndItemCodeMap.get(mrpNo);
			String mrpGatheringNo = itemCodeAndMrpGatheringNoMap.get(itemCode);

			HashMap<String, String> map = new HashMap<>();

			map.put("mrpNo", mrpNo);
			map.put("mrpGatheringNo", mrpGatheringNo);
			map.put("mrpGatheringStatus", "Y");

			mrpMapper.changeMrpGatheringStatus(map);
		}

		System.out.println("여기까지오나요3");

		String mrpNoList = mrpNoArr.toString().replace("[", "").replace("]", "");

		resultMap.put("changeMrpGatheringStatus", mrpNoList);

		StringBuffer sb = new StringBuffer();

		System.out.println("mrpGatheringNoList = " + mrpGatheringNoList);

		for(String mrpGatheringNo : mrpGatheringNoList.values()) {
			sb.append(mrpGatheringNo);
			sb.append(",");
		}

		System.out.println("sb = " + sb);
		sb.delete(sb.toString().length()-1, sb.toString().length());

		HashMap<String, String> parameter = new HashMap<>();
		parameter.put("mrpGatheringNo", sb.toString());
		mrpMapper.updateMrpGatheringContract(parameter);

		return resultMap;
	}
	public String getNewMpsNo(String mpsPlanDate) {
		StringBuffer newEstimateNo = null;
		List<MpsTO> mpsTOlist = mpsMapper.selectMpsCount(mpsPlanDate);
		TreeSet<Integer> intSet = new TreeSet<>();
		for (MpsTO bean : mpsTOlist) {
			String mpsNo = bean.getMpsNo();
			// MPS 일련번호에서 마지막 2자리만 가져오기
			int no = Integer.parseInt(mpsNo.substring(mpsNo.length() - 2, mpsNo.length()));
			intSet.add(no);
		}
		int i=1;
		if (!intSet.isEmpty()) {
			i=intSet.pollLast() + 1;
		}

		newEstimateNo = new StringBuffer();
		newEstimateNo.append("PS");
		newEstimateNo.append(mpsPlanDate.replace("-", ""));
		newEstimateNo.append(String.format("%02d", i)); //PS2020042401

		return newEstimateNo.toString();
	}

	public void changeMpsStatusInContractDetail(String contractDetailNo, String mpsStatus) {

		HashMap<String, String> map = new HashMap<>();

		map.put("contractDetailNo", contractDetailNo);
		map.put("mpsStatus", mpsStatus);

		contractMapper.changeMpsStatusOfContractDetail(map);

	}

	public void changeMpsStatusInSalesPlan(String salesPlanNo, String mpsStatus) {

		HashMap<String, String> map = new HashMap<>();

		map.put("salesPlanNo", salesPlanNo);
		map.put("mpsStatus", mpsStatus);

		salesPlanMapper.changeMpsStatusOfSalesPlan(map);

	}

	public HashMap<String, Object> batchMrpGatheringListProcess(ArrayList<MrpGatheringTO> mrpGatheringTOList) {

		HashMap<String, Object> resultMap = new HashMap<>();

		HashMap<String, String> insertListMap = new HashMap<>();
		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		for (MrpGatheringTO bean : mrpGatheringTOList) {

			String status = bean.getStatus();

			switch (status) {

				case "INSERT":

					mrpMapper.insertMrpGathering(bean);

					insertList.add(bean.getMrpGatheringNo());

					insertListMap.put(bean.getItemCode(), bean.getMrpGatheringNo());

					break;

				case "UPDATE":

					mrpMapper.updateMrpGathering(bean);

					updateList.add(bean.getMrpGatheringNo());

					break;

				case "DELETE":

					mrpMapper.deleteMrpGathering(bean);

					deleteList.add(bean.getMrpGatheringNo());

					break;

			}

		}

		resultMap.put("INSERT_MAP", insertListMap); //key(ItemCode) : value(getMrpGatheringNo)
		resultMap.put("INSERT", insertList); //소요량취합번호
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}
}
