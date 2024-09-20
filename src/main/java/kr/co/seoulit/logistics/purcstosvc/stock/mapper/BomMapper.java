package kr.co.seoulit.logistics.purcstosvc.stock.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import kr.co.seoulit.logistics.purcstosvc.stock.to.BomDeployTO;
import kr.co.seoulit.logistics.purcstosvc.stock.to.BomInfoTO;
import kr.co.seoulit.logistics.purcstosvc.stock.to.BomTO;

@Mapper
public interface BomMapper {
	
	public ArrayList<BomDeployTO> selectBomDeployList(HashMap<String, String> map);
	
	public ArrayList<BomInfoTO> selectBomInfoList(String parentItemCode);
	
	public ArrayList<BomInfoTO> selectAllItemWithBomRegisterAvailable();
	
	public void insertBom(BomTO TO);
	
	public void updateBom(BomTO TO);
	
	public void deleteBom(BomTO TO);
	
}
