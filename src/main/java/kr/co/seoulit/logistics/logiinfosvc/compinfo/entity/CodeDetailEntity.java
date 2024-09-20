package kr.co.seoulit.logistics.logiinfosvc.compinfo.entity;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;
import java.io.Serializable;

@Entity
@Data
@Table(name="CODE_DETAIL")
@IdClass(CodeDetailPK.class)
public class CodeDetailEntity implements Serializable {
    @Id
    private String divisionCodeNo;
    @Id
    private String detailCode;
    private String detailCodeName;
    private String codeUseCheck;
    private String description;
}
