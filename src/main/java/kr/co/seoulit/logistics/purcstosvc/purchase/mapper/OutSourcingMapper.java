package kr.co.seoulit.logistics.purcstosvc.purchase.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import kr.co.seoulit.logistics.purcstosvc.purchase.to.OutSourcingTO;

@Mapper
public interface OutSourcingMapper {

	ArrayList<OutSourcingTO> selectOutSourcingList(HashMap<String, String> map);

}
