package kr.co.seoulit.logistics.logiinfosvc.compinfo.entity;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Data
@Table(name="WORKPLACE")
public class WorkplaceEntity {
    private String companyCode;
    private String workplaceName;
    private String businessLicenseNumber;
    private String corporationLicenseNumber;
    private String workplaceCeoName;
    private String workplaceBusinessConditions;
    private String workplaceBusinessItems;
    private String workplaceZipCode;
    private String workplaceBasicAddress;
    private String workplaceDetailAddress;
    private String workplaceTelNumber;
    private String workplaceFaxNumber;
    private String workplaceEstablishDate;
    private String workplaceOpenDate;
    private String workplaceCloseDate;
    private String isMainOffice;
    @Id
    private String workplaceCode;
}
