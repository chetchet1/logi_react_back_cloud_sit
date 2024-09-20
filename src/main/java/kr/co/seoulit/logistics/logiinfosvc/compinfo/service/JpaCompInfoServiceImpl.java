package kr.co.seoulit.logistics.logiinfosvc.compinfo.service;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.entity.*;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.repository.*;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CustomerTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

@Service
public class JpaCompInfoServiceImpl implements JpaCompInfoService{
    @Autowired
    private CompanyRepository companyRepository;
    @Autowired
    private WorkplaceRepository workplaceRepository;
    @Autowired
    private DepartmentRepository departmentRepository;
    @Autowired
    private CodeDetailRepository codeDetailRepository;


    @Override
    public ArrayList<CompanyEntity> getCompanyList() {

        ArrayList<CompanyEntity> companyList = null;

        companyList = companyRepository.findAllBy();

        return companyList;
    }

    @Override
    public ArrayList<WorkplaceEntity> getWorkplaceList(String companyCode) {

        ArrayList<WorkplaceEntity> workplaceList = null;

        workplaceList = workplaceRepository.findByCompanyCode(companyCode);

        return workplaceList;
    }

    @Override
    public ArrayList<DepartmentEntity> getDepartmentList(String searchCondition, String companyCode,
                                                         String workplaceCode) {

        ArrayList<DepartmentEntity> departmentList = null;

        switch (searchCondition) {

            case "ALL":

                departmentList = departmentRepository.findByCompanyCode(companyCode);
                break;

            case "WORKPLACE":

                departmentList = departmentRepository.findByWorkplaceCode(workplaceCode);
                break;

        }

        return departmentList;
    }

    @Override
    public ArrayList<CodeDetailEntity> getCodeDetailList(String divisionCode) {
        System.out.println("Entity로 실행됨?"+divisionCode);
        ArrayList<CodeDetailEntity> codeDetailList = null;

        codeDetailList =codeDetailRepository.findByDivisionCodeNoLike(divisionCode);

		return codeDetailList;

    }
//    @Override
//    public ArrayList<CustomerEntity> getCustomerList(String searchCondition, String companyCode, String workplaceCode, String itemGroupCode) {
//
//        ArrayList<CustomerEntity> customerList = null;
//
//        switch (searchCondition) {
//
//            case "ALL":
//
//                customerList = customerRepository.findAllBy();
//                break;
//
//            case "WORKPLACE":
//
//                customerList = customerRepository.findAllByWorkplaceCode(workplaceCode);
//                break;
//
//            case "ITEM":
//                customerList = customerRepository.findAllByItemGroupCode(itemGroupCode);
//                break;
//        }
//
//        return customerList;
//    }
}
