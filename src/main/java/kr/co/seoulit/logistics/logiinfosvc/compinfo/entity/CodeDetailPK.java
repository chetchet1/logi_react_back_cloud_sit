package kr.co.seoulit.logistics.logiinfosvc.compinfo.entity;

import lombok.Data;
import java.io.Serializable;

@Data
public class CodeDetailPK implements Serializable {
    private String divisionCodeNo;
    private String detailCode;
}
