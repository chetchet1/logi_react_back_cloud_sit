package kr.co.seoulit.logistics.logiinfosvc.compinfo.service;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.WorkplaceEntity;
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

public interface CompInfoService {

	public ArrayList<CodeDetailTO> getDetailCodeList(String divisionCode);

	public ArrayList<CodeTO> getCodeList();

//	public Boolean checkCodeDuplication(String divisionCode, String newDetailCode);

	public HashMap<String, Object> batchCodeListProcess(ArrayList<CodeTO> codeList);

	public HashMap<String, Object> batchDetailCodeListProcess(ArrayList<CodeDetailTO> detailCodeList);

	public HashMap<String, Object> changeCodeUseCheckProcess(ArrayList<CodeDetailTO> detailCodeList);

	public ArrayList<AddressTO> getAddressList(String sidoName, String searchAddressType, String searchValue, String mainNumber);
	
	public void addCodeInFormation(ArrayList<CodeTO>  CodeTOList);	
	
	public ArrayList<CodeDetailTO> getCodeDetailList(String divisionCode);

    public ArrayList<CustomerTO> getCustomerList(String searchCondition, String companyCode, String workplaceCode,String itemGroupCode);

    public HashMap<String, Object> batchCustomerListProcess(ArrayList<CustomerTO> customerList);

    public ArrayList<FinancialAccountAssociatesTO> getFinancialAccountAssociatesList(String searchCondition,
                                                                                     String workplaceCode);

    public HashMap<String, Object> batchFinancialAccountAssociatesListProcess(
            ArrayList<FinancialAccountAssociatesTO> financialAccountAssociatesList);

//    public ArrayList<CompanyTO> getCompanyList();

//    public ArrayList<WorkplaceEntity> getWorkplaceList(String companyCode);

    public ArrayList<DepartmentTO> getDepartmentList(String searchCondition, String companyCode,
                                                     String workplaceCode);

    public HashMap<String, Object> batchCompanyListProcess(ArrayList<CompanyTO> companyList);

    public HashMap<String, Object> batchWorkplaceListProcess(ArrayList<WorkplaceTO> workplaceList);

    public HashMap<String, Object> batchDepartmentListProcess(ArrayList<DepartmentTO> departmentList);
    
    public ArrayList<LatLngTO> getLatLngList(String wareHouseCodeNo);
    
    public ArrayList<ImageTO> getDetailItemList(String itemGroupCodeNo);
    
    public ArrayList<EstimateReportTO> getEstimateReport(String estimateNo);

    public ArrayList<ContractReportTO> getContractReport(String contractNo);
    
    //board
	public ArrayList<BoardTO> getBoardList();
	
	public void addBoard(BoardTO board);
	
	public BoardTO getBoard(int board_seq);
	
	public BoardTO getBoard(String sessionId,int board_seq);
	
	public void changeHit(int board_seq);
	
	public int getRowCount();
	
	public ArrayList<BoardTO> getBoardList(int sr, int er);
	
	public void removeBoard(int board_seq);
}
