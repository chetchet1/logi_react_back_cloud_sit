package kr.co.seoulit.logistics.logiinfosvc.compinfo.entity;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Data
@Table(name="COMPANY")
public class CompanyEntity {
    private String companyName;
    private String companyDivision;
    private String businessLicenseNumber;
    private String corporationLicenseNumber;
    private String companyCeoName;
    private String companyBusinessConditions;
    private String companyBusinessItems;
    private String companyZipCode;
    private String companyBasicAddress;
    private String companyDetailAddress;
    private String companyTelNumber;
    private String companyFaxNumber;
    private String companyEstablishmentDate;
    private String companyOpenDate;
    private String homepage;
    @Id
    private String companyCode;

}
