package kr.co.seoulit.logistics.logiinfosvc.compinfo.service;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.*;


import java.util.ArrayList;


public interface JpaCompInfoService {
    public ArrayList<CompanyEntity> getCompanyList();
    public ArrayList<WorkplaceEntity> getWorkplaceList(String companyCode);

    public ArrayList<DepartmentEntity> getDepartmentList(String searchCondition, String companyCode,
                                                         String workplaceCode);
    public ArrayList<CodeDetailEntity> getCodeDetailList(String divisionCode);

//    public ArrayList<CustomerEntity> getCustomerList(String searchCondition, String companyCode, String workplaceCode, String itemGroupCode);

}
