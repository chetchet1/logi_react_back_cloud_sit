package kr.co.seoulit.logistics.logiinfosvc.compinfo.entity;

import lombok.Data;
import java.io.Serializable;

@Data
public class DepartmentPK implements Serializable {
    private String deptCode;
    private String workplaceCode;
}
