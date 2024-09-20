package kr.co.seoulit.logistics.logiinfosvc.compinfo.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.mapper.CodeMapper;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.mapper.CompInfoMapper;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.AddressTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BoardTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CodeDetailTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CodeTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CompanyTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.ContractReportTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CustomerTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.DepartmentTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.EstimateReportTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.FinancialAccountAssociatesTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.ImageTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.LatLngTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.WorkplaceTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.util.BoardFile;

@Service
public class CompInfoServiceImpl implements CompInfoService {

	@Autowired
	private CodeMapper codeMapper;
	@Autowired
	private CompInfoMapper compInfoMapper;

	@Override
	public ArrayList<CodeDetailTO> getDetailCodeList(String divisionCode) {

		ArrayList<CodeDetailTO> codeDetailList = null;

		codeDetailList = codeMapper.selectDetailCodeList(divisionCode);

		return codeDetailList;
	}

	@Override
	public ArrayList<CodeTO> getCodeList() {

		ArrayList<CodeTO> codeList = null;

		codeList = codeMapper.selectCodeList();

		return codeList;
	}

//   @Override
//   public Boolean checkCodeDuplication(String divisionCode, String newDetailCode) {
//
//      Boolean flag = false;
//      ArrayList<CodeDetailTO> detailCodeList = null;
//
//      detailCodeList = codeMapper.selectDetailCodeList(divisionCode);
//
//      for (CodeDetailTO bean : detailCodeList) {
//
//         if (bean.getDetailCode().equals(newDetailCode)) {
//
//            flag = true;
//         }
//
//      }
//
//      return flag;
//   }

	@Override
	public HashMap<String, Object> batchCodeListProcess(ArrayList<CodeTO> codeList) {

		HashMap<String, Object> resultMap = new HashMap<>();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		for (CodeTO bean : codeList) {

			String status = bean.getStatus();

			switch (status) {

				case "INSERT":

					codeMapper.insertCode(bean);

					insertList.add(bean.getDivisionCodeNo());

					break;

				case "UPDATE":

					codeMapper.updateCode(bean);

					updateList.add(bean.getDivisionCodeNo());

					break;

				case "DELETE":

					codeMapper.deleteCode(bean);

					deleteList.add(bean.getDivisionCodeNo());

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public HashMap<String, Object> batchDetailCodeListProcess(ArrayList<CodeDetailTO> detailCodeList) {

		HashMap<String, Object> resultMap = new HashMap<>();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		for (CodeDetailTO bean : detailCodeList) {

			String status = bean.getStatus();

			switch (status) {

				case "INSERT":

					codeMapper.insertDetailCode(bean);

					insertList.add(bean.getDivisionCodeNo() + " / " + bean.getDetailCode());

					break;

				case "UPDATE":

					codeMapper.updateDetailCode(bean);

					updateList.add(bean.getDivisionCodeNo() + " / " + bean.getDetailCode());

					break;

				case "DELETE":

					codeMapper.deleteDetailCode(bean);

					deleteList.add(bean.getDivisionCodeNo() + " / " + bean.getDetailCode());

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public HashMap<String, Object> changeCodeUseCheckProcess(ArrayList<CodeDetailTO> detailCodeList) {

		HashMap<String, Object> resultMap = new HashMap<>();
		HashMap<String, String> map = new HashMap<>();
		ArrayList<String> codeUseList = new ArrayList<>();
		ArrayList<String> codeNotUseList = new ArrayList<>();

		String divisionCodeNo = null;
		String detailCode = null;

		for (CodeDetailTO bean : detailCodeList) {

			String codeUseCheck = ((bean.getCodeUseCheck() == null) ? "" : bean.getCodeUseCheck().toUpperCase());

			switch (codeUseCheck) {

				case "N":

					divisionCodeNo = bean.getDivisionCodeNo();
					detailCode = bean.getDetailCode();
					map.put("divisionCodeNo", divisionCodeNo);
					map.put("detailCode", detailCode);
					map.put("codeUseCheck", codeUseCheck);

					codeMapper.changeCodeUseCheck(map);

					codeNotUseList.add(bean.getDivisionCodeNo() + " / " + bean.getDetailCode());

					break;

				default:

					divisionCodeNo = bean.getDivisionCodeNo();
					detailCode = bean.getDetailCode();
					map.put("divisionCodeNo", divisionCodeNo);
					map.put("detailCode", detailCode);
					map.put("codeUseCheck", codeUseCheck);

					codeMapper.changeCodeUseCheck(map);

					codeUseList.add(bean.getDivisionCodeNo() + " / " + bean.getDetailCode());

					break;

			}

		}

		resultMap.put("USE", codeUseList);
		resultMap.put("NOT_USE", codeNotUseList);

		return resultMap;
	}

	@Override
	public ArrayList<AddressTO> getAddressList(String sidoName, String searchAddressType, String searchValue, String mainNumber) {

		ArrayList<AddressTO> addressList = null;

		HashMap<String, String> map = new HashMap<>();

		String sidoCode = compInfoMapper.selectSidoCode(sidoName);

		switch (searchAddressType) {

			case "roadNameAddress":

				String buildingMainNumber = mainNumber;

				map.put("buildingMainNumber", buildingMainNumber);
				map.put("searchValue", searchValue);
				map.put("sidoCode", sidoCode);

				addressList = compInfoMapper.selectRoadNameAddressList(map);

				break;

			case "jibunAddress":

				String jibunMainAddress = mainNumber;

				map.put("jibunMainAddress", jibunMainAddress);
				map.put("searchValue", searchValue);
				map.put("sidoCode", sidoCode);

				addressList = compInfoMapper.selectJibunAddressList(map);

				break;

		}

		return addressList;
	}

	@Override
	public ArrayList<CodeDetailTO> getCodeDetailList(String divisionCode) {

		return codeMapper.selectDetailCodeList(divisionCode);

	}

	@Override
	public void addCodeInFormation(ArrayList<CodeTO>  CodeTOList) {

		for (CodeTO bean : CodeTOList) {
			String status = bean.getStatus();
			switch (status) {
				case "DELETE":
					codeMapper.deleteCode(bean);
					break;
				case "INSERT":
					codeMapper.insertCode(bean);
					break;
				case "UPDATE":
					codeMapper.updateCode(bean);
			}
			for (CodeDetailTO detailbean : bean.getCodeDetailTOList()) {
				String status1 = detailbean.getStatus();
				switch (status1) {
					case "INSERT":
						codeMapper.insertDetailCode(detailbean);
						break;
					case "UPDATE":
						codeMapper.updateDetailCode(detailbean);
						break;
					case "DELETE":
						codeMapper.deleteDetailCode(detailbean);
						break;
				}
			}
		}
	}

	@Override
	public ArrayList<CustomerTO> getCustomerList(String searchCondition, String companyCode, String workplaceCode,String itemGroupCode) {

		ArrayList<CustomerTO> customerList = null;

		switch (searchCondition) {

			case "ALL":

				customerList = compInfoMapper.selectCustomerListByCompany(workplaceCode);
				break;

			case "WORKPLACE":

				customerList = compInfoMapper.selectCustomerListByWorkplace(workplaceCode);
				break;

			case "ITEM":
				customerList = compInfoMapper.selectCustomerListByItem(itemGroupCode);
				break;
		}

		return customerList;
	}

	@Override
	public HashMap<String, Object> batchCustomerListProcess(ArrayList<CustomerTO> customerList) {

		System.out.println("임플인데예"+customerList);
		HashMap<String, Object> resultMap = new HashMap<>();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		CodeDetailTO detailCodeBean = new CodeDetailTO();

		for (CustomerTO bean : customerList) {

			String status = bean.getStatus();

			switch (status) {

				case "INSERT":

					String newCustomerCode = getNewCustomerCode(bean.getWorkplaceCode());
					System.out.println("here"+newCustomerCode);
					bean.setCustomerCode(newCustomerCode);

					compInfoMapper.insertCustomer(bean);
					insertList.add(bean.getCustomerCode());

					detailCodeBean.setDivisionCodeNo("CL-01");
					detailCodeBean.setDetailCode(bean.getCustomerCode());
					detailCodeBean.setDetailCodeName(bean.getCustomerName());

					codeMapper.insertDetailCode(detailCodeBean);

					break;

				case "UPDATE":

					compInfoMapper.updateCustomer(bean);
					updateList.add(bean.getCustomerCode());

					detailCodeBean.setDivisionCodeNo("CL-01");
					detailCodeBean.setDetailCode(bean.getCustomerCode());
					detailCodeBean.setDetailCodeName(bean.getCustomerName());

					codeMapper.updateDetailCode(detailCodeBean);

					break;

				case "DELETE":

					compInfoMapper.deleteCustomer(bean);
					deleteList.add(bean.getCustomerCode());

					detailCodeBean.setDivisionCodeNo("CL-01");
					detailCodeBean.setDetailCode(bean.getCustomerCode());
					detailCodeBean.setDetailCodeName(bean.getCustomerName());

					codeMapper.deleteDetailCode(detailCodeBean);

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);
		System.out.println("여기서 막힌 것 같음...왜 안 들어와 값이 ~"+insertList+updateList+deleteList);

		return resultMap;

	}

	@Override
	public ArrayList<FinancialAccountAssociatesTO> getFinancialAccountAssociatesList(String searchCondition,
																					 String workplaceCode) {

		ArrayList<FinancialAccountAssociatesTO> financialAccountAssociatesList = null;

		switch (searchCondition) {

			case "ALL":

				financialAccountAssociatesList = compInfoMapper.selectFinancialAccountAssociatesListByCompany();
				break;

			case "WORKPLACE":

				financialAccountAssociatesList = compInfoMapper
						.selectFinancialAccountAssociatesListByWorkplace(workplaceCode);
				break;

		}

		return financialAccountAssociatesList;

	}

	@Override
	public HashMap<String, Object> batchFinancialAccountAssociatesListProcess(
			ArrayList<FinancialAccountAssociatesTO> financialAccountAssociatesList) {

		HashMap<String, Object> resultMap = new HashMap<>();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		CodeDetailTO detailCodeBean = new CodeDetailTO();

		for (FinancialAccountAssociatesTO bean : financialAccountAssociatesList) {

			String status = bean.getStatus();

			switch (status) {

				case "INSERT":

					String newFinancialAccountAssociatesCode = getNewFinancialAccountAssociatesCode();
					bean.setAccountAssociatesCode(newFinancialAccountAssociatesCode);

					compInfoMapper.insertFinancialAccountAssociates(bean);
					insertList.add(bean.getAccountAssociatesCode());

					detailCodeBean.setDivisionCodeNo("CL-02");
					detailCodeBean.setDetailCode(bean.getAccountAssociatesCode());
					detailCodeBean.setDetailCodeName(bean.getAccountAssociatesName());

					codeMapper.insertDetailCode(detailCodeBean);

					break;

				case "UPDATE":

					compInfoMapper.updateFinancialAccountAssociates(bean);
					updateList.add(bean.getAccountAssociatesCode());

					detailCodeBean.setDivisionCodeNo("CL-02");
					detailCodeBean.setDetailCode(bean.getAccountAssociatesCode());
					detailCodeBean.setDetailCodeName(bean.getAccountAssociatesName());

					codeMapper.updateDetailCode(detailCodeBean);

					break;

				case "DELETE":

					compInfoMapper.deleteFinancialAccountAssociates(bean);
					deleteList.add(bean.getAccountAssociatesCode());

					detailCodeBean.setDivisionCodeNo("CL-02");
					detailCodeBean.setDetailCode(bean.getAccountAssociatesCode());
					detailCodeBean.setDetailCodeName(bean.getAccountAssociatesName());

					codeMapper.deleteDetailCode(detailCodeBean);

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}
//       @Override
//      public ArrayList<CompanyTO> getCompanyList() {
//
//         ArrayList<CompanyTO> companyList = null;
//
//         companyList = compInfoMapper.selectCompanyList();
//
//         return companyList;
//      }

//      @Override
//      public ArrayList<WorkplaceEntity> getWorkplaceList(String companyCode) {
//
//         ArrayList<WorkplaceTO> workplaceList = null;
//
//         workplaceList = compInfoMapper.selectWorkplaceList(companyCode);
//
//         return workplaceList;
//      }

	@Override
	public ArrayList<DepartmentTO> getDepartmentList(String searchCondition, String companyCode,
													 String workplaceCode) {

		ArrayList<DepartmentTO> departmentList = null;

		switch (searchCondition) {

			case "ALL":

				departmentList = compInfoMapper.selectDepartmentListByCompany(companyCode);
				break;

			case "WORKPLACE":

				departmentList = compInfoMapper.selectDepartmentListByWorkplace(workplaceCode);
				break;

		}

		return departmentList;
	}

	@Override
	public HashMap<String, Object> batchCompanyListProcess(ArrayList<CompanyTO> companyList) {

		HashMap<String, Object> resultMap = new HashMap<>();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		CodeDetailTO detailCodeBean = new CodeDetailTO();

		for (CompanyTO bean : companyList) {

			String status = bean.getStatus();

			switch (status) {

				case "INSERT":

					String newCompanyCode = getNewCompanyCode();
					bean.setCompanyCode(newCompanyCode);

					compInfoMapper.insertCompany(bean);
					insertList.add(bean.getCompanyCode());

					detailCodeBean.setDivisionCodeNo("CO-01");
					detailCodeBean.setDetailCode(bean.getCompanyCode());
					detailCodeBean.setDetailCodeName(bean.getCompanyName());

					codeMapper.insertDetailCode(detailCodeBean);

					break;

			}

		}

		for (CompanyTO bean : companyList) {    // 2차 반복 : UPDATE , DELETE 만 실행

			String status = bean.getStatus();

			switch (status) {

				case "UPDATE":

					compInfoMapper.updateCompany(bean);
					updateList.add(bean.getCompanyCode());

					detailCodeBean.setDivisionCodeNo("CO-01");
					detailCodeBean.setDetailCode(bean.getCompanyCode());
					detailCodeBean.setDetailCodeName(bean.getCompanyName());

					codeMapper.updateDetailCode(detailCodeBean);

					break;

				case "DELETE":

					compInfoMapper.deleteCompany(bean);
					deleteList.add(bean.getCompanyCode());

					detailCodeBean.setDivisionCodeNo("CO-01");
					detailCodeBean.setDetailCode(bean.getCompanyCode());
					detailCodeBean.setDetailCodeName(bean.getCompanyName());

					codeMapper.deleteDetailCode(detailCodeBean);

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public HashMap<String, Object> batchWorkplaceListProcess(ArrayList<WorkplaceTO> workplaceList) {

		HashMap<String, Object> resultMap = new HashMap<>();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		CodeDetailTO detailCodeBean = new CodeDetailTO();

		for (WorkplaceTO bean : workplaceList) {

			String status = bean.getStatus();

			switch (status) {

				case "INSERT":

					String newWorkplaceCode = getNewWorkplaceCode(bean.getCompanyCode());
					bean.setWorkplaceCode(newWorkplaceCode);

					compInfoMapper.insertWorkplace(bean);
					insertList.add(bean.getWorkplaceCode());

					detailCodeBean.setDivisionCodeNo("CO-02");
					detailCodeBean.setDetailCode(bean.getWorkplaceCode());
					detailCodeBean.setDetailCodeName(bean.getWorkplaceName());

					codeMapper.insertDetailCode(detailCodeBean);

					break;

				case "UPDATE":

					compInfoMapper.updateWorkplace(bean);
					updateList.add(bean.getWorkplaceCode());

					detailCodeBean.setDivisionCodeNo("CO-02");
					detailCodeBean.setDetailCode(bean.getWorkplaceCode());
					detailCodeBean.setDetailCodeName(bean.getWorkplaceName());

					codeMapper.updateDetailCode(detailCodeBean);

					break;

				case "DELETE":

					compInfoMapper.deleteWorkplace(bean);
					deleteList.add(bean.getWorkplaceCode());

					detailCodeBean.setDivisionCodeNo("CO-02");
					detailCodeBean.setDetailCode(bean.getWorkplaceCode());
					detailCodeBean.setDetailCodeName(bean.getWorkplaceName());

					codeMapper.deleteDetailCode(detailCodeBean);

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public HashMap<String, Object> batchDepartmentListProcess(ArrayList<DepartmentTO> departmentList) {

		HashMap<String, Object> resultMap = new HashMap<>();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		CodeDetailTO detailCodeBean = new CodeDetailTO();

		for (DepartmentTO bean : departmentList) {

			String status = bean.getStatus();
			System.out.println(status+"@@@@@@@@@");
			switch (status) {

				case "INSERT":

					String newDepartmentCode = getNewDepartmentCode(bean.getCompanyCode());
					bean.setDeptCode(newDepartmentCode);

					compInfoMapper.insertDepartment(bean);
					insertList.add(bean.getDeptCode());

					detailCodeBean.setDivisionCodeNo("CO-03");
					detailCodeBean.setDetailCode(bean.getDeptCode());
					detailCodeBean.setDetailCodeName(bean.getDeptName());

					codeMapper.insertDetailCode(detailCodeBean);

					break;

				case "UPDATE":

					compInfoMapper.updateDepartment(bean);
					updateList.add(bean.getDeptCode());

					detailCodeBean.setDivisionCodeNo("CO-03");
					detailCodeBean.setDetailCode(bean.getDeptCode());
					detailCodeBean.setDetailCodeName(bean.getDeptName());

					codeMapper.updateDetailCode(detailCodeBean);

					break;

				case "DELETE":

					compInfoMapper.deleteDepartment(bean);
					deleteList.add(bean.getDeptCode());

					detailCodeBean.setDivisionCodeNo("CO-03");
					detailCodeBean.setDetailCode(bean.getDeptCode());
					detailCodeBean.setDetailCodeName(bean.getDeptName());

					codeMapper.deleteDetailCode(detailCodeBean);

					break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	public String getNewCustomerCode(String workplaceCode) {
//         System.out.println("넘어왔나?"+workplaceCode);
		ArrayList<CustomerTO> customerList = null;
		String newCustomerCode = null;

		customerList = compInfoMapper.selectCustomerListByCompany(workplaceCode);

		TreeSet<Integer> customerCodeNoSet = new TreeSet<>();

		for (CustomerTO bean : customerList) {

			if (bean.getCustomerCode().startsWith("PTN-")) {

				try {

					Integer no = Integer.parseInt(bean.getCustomerCode().split("PTN-")[1]);
					customerCodeNoSet.add(no);

				} catch (NumberFormatException e) {

				}

			}

		}
		/*String.format("%02d") %: 명령시작 0: 채워질 문자 2:총 자리수 d: 10진수(정수)*/
		if (customerCodeNoSet.isEmpty()) {
			newCustomerCode = "PTN-" + String.format("%02d", 1); //출력결과 PTN-01
		} else {
			newCustomerCode = "PTN-" + String.format("%02d", customerCodeNoSet.pollLast() + 1);
		}
		System.out.println("값 넘어왔나요? 'ㅁ' 오마이갓"+newCustomerCode);
		return newCustomerCode;
	}

	public String getNewFinancialAccountAssociatesCode() {

		ArrayList<FinancialAccountAssociatesTO> financialAccountAssociatesList = null;
		String newFinancialAccountAssociatesCode = null;

		financialAccountAssociatesList = compInfoMapper
				.selectFinancialAccountAssociatesListByCompany();

		TreeSet<Integer> financialAccountAssociatesCodeNoSet = new TreeSet<>();

		for (FinancialAccountAssociatesTO bean : financialAccountAssociatesList) {

			if (bean.getAccountAssociatesCode().startsWith("FPT-")) {

				try {

					Integer no = Integer.parseInt(bean.getAccountAssociatesCode().split("FPT-")[1]);
					financialAccountAssociatesCodeNoSet.add(no);

				} catch (NumberFormatException e) {

				}

			}

		}

		if (financialAccountAssociatesCodeNoSet.isEmpty()) {
			newFinancialAccountAssociatesCode = "FPT-" + String.format("%02d", 1);
		} else {
			newFinancialAccountAssociatesCode = "FPT-"
					+ String.format("%02d", financialAccountAssociatesCodeNoSet.pollLast() + 1);
		}

		return newFinancialAccountAssociatesCode;
	}

	public String getNewCompanyCode() {

		ArrayList<CompanyTO> companyList = null;
		String newCompanyCode = null;

		companyList = compInfoMapper.selectCompanyList();

		TreeSet<Integer> companyCodeNoSet = new TreeSet<>();

		for (CompanyTO bean : companyList) {

			if (bean.getCompanyCode().startsWith("COM-")) {

				try {

					Integer no = Integer.parseInt(bean.getCompanyCode().split("COM-")[1]);
					companyCodeNoSet.add(no);

				} catch (NumberFormatException e) {

				}

			}

		}

		if (companyCodeNoSet.isEmpty()) {
			newCompanyCode = "COM-" + String.format("%02d", 1);
		} else {
			newCompanyCode = "COM-" + String.format("%02d", companyCodeNoSet.pollLast() + 1);
		}

		return newCompanyCode;
	}

	public String getNewWorkplaceCode(String companyCode) {

		ArrayList<WorkplaceTO> workplaceList = null;
		String newWorkplaceCode = null;

		workplaceList = compInfoMapper.selectWorkplaceList(companyCode);

		TreeSet<Integer> workplaceCodeNoSet = new TreeSet<>();

		for (WorkplaceTO bean : workplaceList) {

			if (bean.getWorkplaceCode().startsWith("BRC-")) {

				try {

					Integer no = Integer.parseInt(bean.getWorkplaceCode().split("BRC-")[1]);
					workplaceCodeNoSet.add(no);

				} catch (NumberFormatException e) {

				}

			}

		}

		if (workplaceCodeNoSet.isEmpty()) {
			newWorkplaceCode = "BRC-" + String.format("%02d", 1);
		} else {
			newWorkplaceCode = "BRC-" + String.format("%02d", workplaceCodeNoSet.pollLast() + 1);
		}

		return newWorkplaceCode;
	}

	public String getNewDepartmentCode(String companyCode) {

		ArrayList<DepartmentTO> departmentList = null;
		String newDepartmentCode = null;

		departmentList = compInfoMapper.selectDepartmentListByCompany(companyCode);

		TreeSet<Integer> departmentCodeNoSet = new TreeSet<>();

		for (DepartmentTO bean : departmentList) {

			if (bean.getDeptCode().startsWith("DPT-")) {

				try {

					Integer no = Integer.parseInt(bean.getDeptCode().split("DPT-")[1]);
					departmentCodeNoSet.add(no);

				} catch (NumberFormatException e) {

				}

			}

		}

		if (departmentCodeNoSet.isEmpty()) {
			newDepartmentCode = "DPT-" + String.format("%02d", 1);
		} else {
			newDepartmentCode = "DPT-" + String.format("%02d", departmentCodeNoSet.pollLast() + 1);
		}

		return newDepartmentCode;
	}

	@Override
	public ArrayList<LatLngTO> getLatLngList(String wareHouseCodeNo) {

		ArrayList<LatLngTO> codeDetailList = null;

		codeDetailList = codeMapper.selectLatLngList(wareHouseCodeNo);

		return codeDetailList;
	}

	@Override
	public ArrayList<ImageTO> getDetailItemList(String itemGroupCodeNo) {

		ArrayList<ImageTO> codeDetailList = null;

		codeDetailList = codeMapper.selectDetailItemList(itemGroupCodeNo);

		return codeDetailList;
	}
	@Override
	public ArrayList<EstimateReportTO> getEstimateReport(String estimateNo) {
		return compInfoMapper.selectEstimateReport(estimateNo);

	}

	@Override
	public ArrayList<ContractReportTO> getContractReport(String contractNo) {
		return compInfoMapper.selectContractReport(contractNo);
	}

	//board
	@Override
	public ArrayList<BoardTO> getBoardList() {

		ArrayList<BoardTO> list=null;
		list = compInfoMapper.selectBoardList();
		return list;

	}

	@Override
	public void addBoard(BoardTO board) {

		if (board.getReply_seq() == 0) {
			compInfoMapper.insertBoard(board);
		} else {
			compInfoMapper.insertReplyBoard(board);
		}
		List<BoardFile> files = board.getBoardFiles();
		for (BoardFile file : files) {
			compInfoMapper.insertBoardFile(file);
		}

	}

	@Override
	public BoardTO getBoard(int board_seq) {

		BoardTO board=null;
		board = compInfoMapper.selectBoard(board_seq);
		return board;

	}

	@Override
	public void changeHit(int board_seq) {

		compInfoMapper.updateHit(board_seq);

	}

	@Override
	public BoardTO getBoard(String sessionId, int board_seq) {

		BoardTO board = null;
		board = compInfoMapper.selectBoard(board_seq);
		if (!sessionId.equals(board.getName())) { // 조회수 1증가
			changeHit(board_seq);
		}

		ArrayList<BoardFile> fileList = compInfoMapper.selectBoardFile(board_seq);

		for (BoardFile file : fileList) {
			board.addBoardFile(file);
		}

		return board;
	}

	@Override
	public int getRowCount() {

		int dbCount=0;
		dbCount = compInfoMapper.selectRowCount();
		return dbCount;

	}

	@Override
	public ArrayList<BoardTO> getBoardList(int sr, int er) {

		ArrayList<BoardTO> list=null;
		list = compInfoMapper.selectBoardList(sr, er);
		return list;

	}

	public void removeBoard(int board_seq) {

		compInfoMapper.deleteBoard(board_seq);

	}
}