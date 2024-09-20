package kr.co.seoulit.logistics.logiinfosvc.logiinfo.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.mapper.CodeMapper;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CodeDetailTO;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.mapper.ItemMapper;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.mapper.WarehouseMapper;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.ItemGroupTO;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.ItemInfoTO;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.ItemTO;
import kr.co.seoulit.logistics.logiinfosvc.logiinfo.to.WarehouseTO;
import kr.co.seoulit.logistics.purcstosvc.stock.mapper.BomMapper;
import kr.co.seoulit.logistics.purcstosvc.stock.to.BomTO;

@Service
public class LogiInfoServiceImpl implements LogiInfoService {
	
	@Autowired
	private ItemMapper itemMapper;
	@Autowired
	private CodeMapper codeMapper;
	@Autowired
	private BomMapper bomMapper;
	@Autowired
	private WarehouseMapper warehouseMapper;
	
	@Override
	public ArrayList<ItemInfoTO> getItemInfoList(String searchCondition, String[] paramArray) {

		ArrayList<ItemInfoTO> itemInfoList = null;
		
		HashMap<String, String> map = null;

		switch (searchCondition) {

		case "ALL":

			itemInfoList = itemMapper.selectAllItemList();

			break;

		case "ITEM_CLASSIFICATION":
			
			map = new HashMap<>();
			
			map.put("itemClassification", paramArray[0]);
			
			itemInfoList = itemMapper.selectItemList(map);

			break;

		case "ITEM_GROUP_CODE":
			
			map = new HashMap<>();
			
			map.put("itemGroupCode", paramArray[0]);

			itemInfoList = itemMapper.selectItemList(map);

			break;

		case "STANDARD_UNIT_PRICE":
			
			map = new HashMap<>();
			
			map.put("minPrice", paramArray[0]);

			itemInfoList = itemMapper.selectItemList(map);

			break;

		}

		return itemInfoList;
	}

	@Override
	public ModelMap batchItemListProcess(ArrayList<ItemTO> itemTOList) {

		ModelMap resultMap = new ModelMap();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		CodeDetailTO detailCodeTO = new CodeDetailTO();
		BomTO bomTO = new BomTO();
			
		for (ItemTO TO : itemTOList) {

			String status = TO.getStatus();

			switch (status) {

			case "INSERT":

				itemMapper.insertItem(TO);
				insertList.add(TO.getItemCode());

				detailCodeTO.setDivisionCodeNo(TO.getItemClassification());
				detailCodeTO.setDetailCode(TO.getItemCode());
				detailCodeTO.setDetailCodeName(TO.getItemName());
				detailCodeTO.setDescription(TO.getDescription());

				codeMapper.insertDetailCode(detailCodeTO);

				if( TO.getItemClassification().equals("IT-CI") || TO.getItemClassification().equals("IT-SI") ) {
						
					bomTO.setNo(1);
					bomTO.setParentItemCode("NULL");
					bomTO.setItemCode( TO.getItemCode() );
					bomTO.setNetAmount(1);
						
					bomMapper.insertBom(bomTO);
				}
					
					
				break;

			case "UPDATE":

				itemMapper.updateItem(TO);

				updateList.add(TO.getItemCode());

				detailCodeTO.setDivisionCodeNo(TO.getItemClassification());
				detailCodeTO.setDetailCode(TO.getItemCode());
				detailCodeTO.setDetailCodeName(TO.getItemName());
				detailCodeTO.setDescription(TO.getDescription());

				codeMapper.updateDetailCode(detailCodeTO);

				break;

			case "DELETE":

				itemMapper.deleteItem(TO);

				deleteList.add(TO.getItemCode());

				detailCodeTO.setDivisionCodeNo(TO.getItemClassification());
				detailCodeTO.setDetailCode(TO.getItemCode());
				detailCodeTO.setDetailCodeName(TO.getItemName());
				detailCodeTO.setDescription(TO.getDescription());

				codeMapper.deleteDetailCode(detailCodeTO);

				break;

			}

		}

		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}

	@Override
	public ArrayList<WarehouseTO> getWarehouseInfoList() {

		ArrayList<WarehouseTO> warehouseInfoList = null;

		warehouseInfoList = warehouseMapper.selectWarehouseList();

		return warehouseInfoList;
	}

	/*은비 수정*/
	@Override
	public HashMap<String, Object> batchWarehouseInfo(ArrayList<WarehouseTO> warehouseTOList) {
		System.out.println(warehouseTOList);

		HashMap<String, Object> resultMap = new HashMap<>();

		ArrayList<String> insertList = new ArrayList<>();
		ArrayList<String> updateList = new ArrayList<>();
		ArrayList<String> deleteList = new ArrayList<>();

		for (WarehouseTO bean : warehouseTOList) {
			String status = bean.getStatus();
			System.out.println(status);

			switch (status) {
				case "DELETE":
					warehouseMapper.deleteWarehouse(bean);
					deleteList.add(bean.getWarehouseCode());
					break;

				case "INSERT":

					String newWarehouseCode = getNewWarehouseCode();
					System.out.println("..휴.. 이제 그만하고싶다"+ newWarehouseCode);
					bean.setWarehouseCode(newWarehouseCode);
					warehouseMapper.insertWarehouse(bean);
					insertList.add(bean.getWarehouseCode());

					break;

				case "UPDATE":
					warehouseMapper.updateWarehouse(bean);
					updateList.add(bean.getWarehouseCode());
			}
		}
		resultMap.put("INSERT", insertList);
		resultMap.put("UPDATE", updateList);
		resultMap.put("DELETE", deleteList);

		return resultMap;
	}
	/*은비 수정*/
	private String getNewWarehouseCode() {
		ArrayList<WarehouseTO> warehouseList = null;
		String newWarehouseCode = null;

		TreeSet<Integer> warehouseCodeNoSet = new TreeSet<>();

		warehouseList = warehouseMapper.selectWarehouseList();

		for ( WarehouseTO bean : warehouseList) {

			if (bean.getWarehouseCode().startsWith("WHS-")) {

				try {

					Integer no = Integer.parseInt(bean.getWarehouseCode().split("WHS-")[1]);
					warehouseCodeNoSet.add(no);

				} catch (NumberFormatException e) {

				}

			}

		}
		/*String.format("%02d") %: 명령시작 0: 채워질 문자 2:총 자리수 d: 10진수(정수)*/
		if (warehouseCodeNoSet.isEmpty()) {
			newWarehouseCode = "WHS-" + String.format("%02d", 1);
		} else {
			newWarehouseCode = "WHS-" + String.format("%02d", warehouseCodeNoSet.pollLast() + 1);
		}
		System.out.println("값 넘어왔나요? 'ㅁ' 오마이갓"+newWarehouseCode);
		return newWarehouseCode;

	}

	@Override
	public String findLastWarehouseCode() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getStandardUnitPrice(String itemCode) {

		int price = 0;

		price = itemMapper.getStandardUnitPrice(itemCode);

		return price;
		
	}
	
	@Override
	public int getStandardUnitPriceBox(String itemCode) {

		int price = 0;

		price = itemMapper.getStandardUnitPriceBox(itemCode);

		return price;
		
	}
	
	@Override
	public ArrayList<ItemInfoTO> getitemInfoList(HashMap<String, String> ableSearchConditionInfo) {

		ArrayList<ItemInfoTO> itemCodeList = null;

		itemCodeList = itemMapper.selectitemInfoList(ableSearchConditionInfo);

		return itemCodeList;

	}

	@Override
	public ArrayList<ItemGroupTO> getitemGroupList(HashMap<String, String> ableSearchConditionInfo) {

		ArrayList<ItemGroupTO> itemGroupList = null;

		itemGroupList = itemMapper.selectitemGroupList(ableSearchConditionInfo);

		return itemGroupList;
	}

	//품목그룹삭제
	@Override
	public void getdeleteitemgroup(HashMap<String, String> ableSearchConditionInfo) {
		
		itemMapper.deleteitemgroup(ableSearchConditionInfo);

	}

	//일괄처리
	@Override
	public ArrayList<ItemInfoTO> getBatchSave(ArrayList<ItemInfoTO> itemTOList) {

		for (ItemInfoTO bean : itemTOList) {
	        	 
				String status = bean.getStatus();
	             
					switch (status) {
	             
						case "DELETE":
								itemMapper.deletebatchSave(bean);
								break;
	                   
						case "INSERT":
							itemMapper.insertbatchSave(bean);
							break;
	                   
						case "UPDATE":
							itemMapper.updatebatchSave(bean);
					}
	          }
		return null;
	}

	@Override
	public ArrayList<ItemInfoTO> getOptionItemList() {
		return itemMapper.selectOptionItemList();
	}
}
