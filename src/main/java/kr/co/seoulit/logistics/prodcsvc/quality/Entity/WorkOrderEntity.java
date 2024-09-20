package kr.co.seoulit.logistics.prodcsvc.quality.Entity;

import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Data
@Table(name = "WORK_ORDER_INFO")
public class WorkOrderEntity implements Serializable {

    @Id
    private String workOrderNo;
    private String mrpGatheringNo;
    private String itemClassification;
    private String itemCode;
    private String itemName;
    private String unitOfMrp;
    private String requiredAmount;
    private String workSiteCode;
    private String workSiteName;
    private String productionProcessCode;
    private String productionProcessName;
    private String inspectionStatus;
    private String productionStatus;
    private String completionStatus;

    @Column(name="OPERATION_COMPLETED")
    private String operaionCompleted;

    @Column(name="MRP_NO")
    private String mrpNo;
}
