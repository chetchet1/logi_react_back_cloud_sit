package kr.co.seoulit.logistics.busisvc.logisales.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.seoulit.logistics.busisvc.logisales.to.EstimateDetailTO;
import kr.co.seoulit.logistics.busisvc.logisales.to.EstimateTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EstimateMapper {
	public ArrayList<EstimateTO> selectEstimateList(HashMap<String, String> map);

	public EstimateTO selectEstimate(String estimateNo);

	public int selectEstimateCount(String estimateDate);

	public void insertEstimate(EstimateTO TO);

	public void updateEstimate(EstimateTO TO);

	public void deleteEstimate(String estimateNo);

	public void changeContractStatusOfEstimate(HashMap<String, String> map);

	//EstimateDetail

	public ArrayList<EstimateDetailTO> selectEstimateDetailList(String estimateNo);

	public ArrayList<EstimateDetailTO> selectEstimateDetailCount(String estimateNo);

	public void insertEstimateDetail(EstimateDetailTO TO);

	public void updateEstimateDetail(EstimateDetailTO TO);

	public void deleteEstimateDetail(EstimateDetailTO TO);

	public int selectEstimateDetailSeq(String estimateDate);

	public void initDetailSeq();

	public void reArrangeEstimateDetail(HashMap<String, String> map);

}
