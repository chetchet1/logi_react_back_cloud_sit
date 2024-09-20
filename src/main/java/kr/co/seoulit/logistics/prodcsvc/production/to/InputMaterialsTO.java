package kr.co.seoulit.logistics.prodcsvc.production.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class InputMaterialsTO extends BaseTO {
	 private String inputItemNo;
	 private String productionResultNo;
	 private String description;
	 private String itemCode;
	 private String unitOfInputMaterials;
	 private String warehouseCode;
	 private String itemName;
	 private int inputAmount;
	 private String inputDate;

}