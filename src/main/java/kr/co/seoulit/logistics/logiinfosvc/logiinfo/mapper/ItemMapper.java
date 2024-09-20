package kr.co.seoulit.logistics.logiinfosvc.logiinfo.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.ItemGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.ItemInfoTO;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.ItemTO;

@Mapper
public interface ItemMapper {

	public ArrayList<ItemInfoTO> selectAllItemList();
	
	public ArrayList<ItemInfoTO> selectItemList(HashMap<String, String> map);
	
	public void insertItem(ItemTO TO);
	
	public void updateItem(ItemTO TO);
	
	public void deleteItem(ItemTO TO);
	
	public int getStandardUnitPrice(String itemCode);
	
	public int getStandardUnitPriceBox(String itemCode);
	
	/* #################################################################### */
	/* #################################################################### */

	//품목상세 조회
	public ArrayList<ItemInfoTO> selectitemInfoList(HashMap<String, String> ableSearchConditionInfo);

	//품목 그룹 조회
	public ArrayList<ItemGroupTO> selectitemGroupList(HashMap<String, String> ableSearchConditionInfo);

	//품목 그룹 삭제
	public void deleteitemgroup(HashMap<String, String> ableSearchConditionInfo);

	//일괄저장 (저장)
	public void deletebatchSave(ItemInfoTO bean);

	//일괄저장 (삭제)
	public void insertbatchSave(ItemInfoTO bean);

	//일괄저장 (수정)
	public void updatebatchSave(ItemInfoTO bean);

	public ArrayList<ItemInfoTO> selectOptionItemList();
}
