<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>소요량 전개 / 취합 조회</title>
<style>

#mrpGatheringStartDatePicker, #mrpGatheringEndDatePicker {
	display: inline;
	width: 125px;
	margin-bottom: 10px;
	transition: 0.6s;
	outline: none;
	height: 30px;
	font-size: 20px;
	text-align : center;
	
}
.l1 {
	color: #FFFFFF;
}
legend {
	color: #FFFFFF;
	}
.ui-datepicker{
	z-index: 10000 !important;
}

.ui-dialog { 
	z-index: 9999 !important ; 
	font-size:12px;
}


</style>
<script>

var lastSelected_mrpGatheringGrid_Id;   // 가장 나중에 선택한 mrpGathering grid 의 행 id 
var lastSelected_mrpGatheringGrid_RowValue;   // 가장 나중에 선택한 mrpGathering grid 의 행 값 

var lastSelected_mrpSearchGrid_Id;   // 가장 나중에 선택한 mrpSearch grid 의 행 id 
var lastSelected_mrpSearchGrid_RowValue;   // 가장 나중에 선택한 mrpSearch grid 의 행 값 

var gridRowJson;  // 모든 그리드의 통합 Json Data => 배열 형식 : [ { ... } , { ... } , { ... } , ... ]


$(document).ready(function() { 
	
	$("input[type=button], input[type=submit]").button();   // jqueryUI Button 위젯 적용
	$( "input[type=radio]" ).checkboxradio();   // jqueryUI Checkboxradio 위젯 적용
	
	$.datepicker.setDefaults({
		dateFormat : 'yy-mm-dd',
		prevText : '이전 달',
		nextText : '다음 달',
		monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월',
									'8월', '9월', '10월', '11월', '12월' ],
		monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월',
											'7월', '8월', '9월', '10월', '11월', '12월' ],
		dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
		dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
		dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
		showMonthAfterYear : true,
		yearSuffix : '년'
	}); /*한글로 달력 보이기 위해서 */


	$("#mrpGatheringStartDatePicker").datepicker({
		changeMonth : true,
		numberOfMonths : 1,
		onClose : function(selectedDate) {
			$( "#mrpGatheringEndDatePicker" ).datepicker( "option", "minDate", selectedDate );
		}
	});		
	
	$("#mrpGatheringEndDatePicker").datepicker({
		changeMonth : true,
		numberOfMonths : 1
	});		
	
	initGrid();
	initEvent();
	
});


function initGrid() {
	

	// mrpGatheringGrid 그리드 시작
	$('#mrpGatheringGrid').jqGrid({ 
		mtype : 'POST', 
		datatype : 'local', 
		colNames : [ "소요량취합번호", "구매 및 생산여부", "품목코드", "품목명","필요수량","단위", 
			"발주/작업지시기한", "발주/작업지시완료기한", "공정진행여부"], 
		colModel : [
			{ name: "mrpGatheringNo", width: "100", resizable: true, align: "center"} ,
			{ name: "orderOrProductionStatus", width: "100", resizable: true, align: "center"} ,
			{ name: "itemCode", width: "70", resizable: true, align: "center"} ,
			{ name: "itemName", width: "120", resizable: true, align: "left"} ,
			{ name: "necessaryAmount", width: "60", resizable: true, align: "center"} ,
			{ name: "unitOfMrpGathering", width: "50", resizable: true, align: "center"} ,
			{ name: "claimDate", width: "120", resizable: true, align: "center", editable: true,
				formatter: 'date',  
				formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' }
			} ,
			{ name: "dueDate", width: "120", resizable: true, align: "center", editable: true,
				formatter: 'date',  
				formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' }
			} ,
			{ name: "onGoingProcessStatus", width: "100", resizable: true, align: "center", hidden : true}
			
		], 
		caption : '소요량 취합', 
		multiselect : false, 
		multiboxonly : false,
		viewrecords : false, 
		rownumWidth : 30, 
		height : 330, 
		width : 740,
		autowidth : false, 
		shrinkToFit : false, 
		cellEdit : false,
		rowNum : 50,  
		scrollerbar: true, 
		//rowList : [ 10, 20, 30 ],
		viewrecords : true, 
		editurl : 'clientArray', 
		cellsubmit : 'clientArray',
		rownumbers : true, 
		autoencode : true, 
		resizable : true,
		loadtext : '로딩중...', 
		emptyrecords : '데이터가 없습니다.', 
		cache : false, 
		pager : '#mrpGatheringGripPager',

		onSelectRow: function(rowid) {   
	
			if( lastSelected_mrpGatheringGrid_Id != rowid ){
				lastSelected_mrpGatheringGrid_Id = rowid;
				lastSelected_mrpGatheringGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
			
			showMrpSearchGrid();
			
		},
		
		onCellSelect : function(rowid, iCol, previousCellValue, e) {

			if( lastSelected_mrpGatheringGrid_Id != rowid ){
				lastSelected_mrpGatheringGrid_Id = rowid;
				lastSelected_mrpGatheringGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
	
		}
	}); // mrpGathering 그리드 끝
	
	// mrpGathering 그리드의 페이저 생성
	$('#mrpGatheringGrid').navGrid("#mrpGatheringGripPager", {
		add : false,
		del : false,
		edit : false,
		search : true,
		refresh : true,
		view: true
	});
	
	
	
	// mrpSearchGrid 그리드 시작
	$('#mrpSearchGrid').jqGrid({ 
		mtype : 'POST', 
		datatype : 'local', 
		colNames : [ "소요량전개번호", "주생산계획번호", "소요량취합번호", "품목분류", "품목코드", 
			"품목명", "발주/작업지시기한", "발주/작업지시완료기한", "필요수량", "단위"], 
		colModel : [
			{ name: "mrpNo", width: "100", resizable: true, align: "center"} ,
			{ name: "mpsNo", width: "100", resizable: true, align: "center" } ,
			{ name: "mrpGatheringNo", width: "100", resizable: true, align: "center" } ,
			{ name: "itemClassification", width: "60", resizable: true, align: "center"} ,
			{ name: "itemCode", width: "90", resizable: true, align: "center"} ,
			{ name: "itemName", width: "120", resizable: true, align: "left"} ,
			{ name: "orderDate", width: "120", resizable: true, align: "center", editable: true,
				formatter: 'date',  
				formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' }
			} ,
			{ name: "requiredDate", width: "120", resizable: true, align: "center", editable: true,
				formatter: 'date',  
				formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' }
			} ,
			{ name: "requiredAmount", width: "60", resizable: true, align: "center"} ,
			{ name: "unitOfMrp", width: "50", resizable: true, align: "center"} 
			
		], 
		caption : '소요량 전개 (MRP) 목록', 
		//sortname : 'mpsNo',   // 여기를 지정해버리면 쿼리에서 이미 정렬한 결과와 순서 달라짐
		multiselect : false, 
		multiboxonly : false,
		viewrecords : false, 
		rownumWidth : 30, 
		height : 330, 
		width : 740,
		autowidth : false, 
		shrinkToFit : false, 
		cellEdit : false,
		rowNum : 50,  
		scrollerbar: true, 
		//rowList : [ 10, 20, 30 ],
		viewrecords : true, 
		editurl : 'clientArray', 
		cellsubmit : 'clientArray',
		rownumbers : true, 
		autoencode : true, 
		resizable : true,
		loadtext : '로딩중...', 
		emptyrecords : '데이터가 없습니다.', 
		cache : false, 
		pager : '#mrpSearchGridPager',

		onSelectRow: function(rowid) {   
	
			if( lastSelected_mrpSearchGrid_Id != rowid ){
				lastSelected_mrpSearchGrid_Id = rowid;
				lastSelected_mrpSearchGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
		},
		
		onCellSelect : function(rowid, iCol, previousCellValue, e) {

			if( lastSelected_mrpSearchGrid_Id != rowid ){
				lastSelected_mrpSearchGrid_Id = rowid;
				lastSelected_mrpSearchGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
	
		}
	}); // mrpSearch 그리드 끝
	
	// mrpSearch 그리드의 페이저 생성
	$('#mrpSearchGrid').navGrid("#mrpSearchGridPager", {
		add : false,
		del : false,
		edit : false,
		search : true,
		refresh : true,
		view: true
	});
		
}

function initEvent() {
	
	$('#mrpGatheringSearchButton').on("click", function() { 
		
		var searchDateCondition = $(':input:radio[name=searchDateCondition]:checked').val();
		var mrpStartDate = $('#mrpGatheringStartDatePicker').val();
		var mrpEndDate = $('#mrpGatheringEndDatePicker').val();

		if( searchDateCondition == null ) {
			alertError( "사용자 에러" , "소요량 취합 검색 옵션을 선택하세요" );
			return;
			
		} else if( mrpStartDate == '시작일' || mrpEndDate == ' 종료일' ){
			alertError( "사용자 에러" , "검색 시작일과 종료일을 모두 입력하세요" );
			return;
						
		}
		
		// 초기화		
		$('#mrpGatheringGrid').jqGrid('clearGridData');
		lastSelected_mrpGatheringGrid_Id = "";
		
		// ajax 시작
		$.ajax({ 
			type : 'GET',
			url : '${pageContext.request.contextPath}/production/mrp/mrpgathering/list' ,
			data : {
				method : 'searchMrpGathering', 
				mrpGatheringStartDate : $("#mrpGatheringStartDatePicker").val() ,
				mrpGatheringEndDate : $("#mrpGatheringEndDatePicker").val() ,
				searchDateCondition : $(':input:radio[name=searchDateCondition]:checked').val()
			},
			dataType : 'json', 
			cache : false, 
			success : function(dataSet) { 
				
				console.log(dataSet);
				
				if(dataSet.errorCode < 0){
					alertError('실패',dataSet.errorMsg);
					return;
				}
				
				gridRowJson = dataSet.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
				
				if( gridRowJson.length != 0 ) {
					
					// 소요량 취합 Data 넣기
					$('#mrpGatheringGrid')
						.jqGrid('setGridParam',{ datatype : 'local', data : gridRowJson })
						.trigger('reloadGrid');					
					
				} else {
					
					alertError("ㅜㅜ" , "조회된 데이터가 없습니다");
				}
				
			
		}});  // ajax 끝

	});
	
}

function showMrpSearchGrid() {
	
	$('#mrpSearchGrid').jqGrid('clearGridData');

	// mrpGathering 그리드에서 선택한 행의 소요량취합번호
	var selectedMrpGatheringNo = lastSelected_mrpGatheringGrid_RowValue. mrpGatheringNo;

	$( gridRowJson ).each( function( index, obj )   {  // gridRowJson 의 전체 데이터에 대해 반복문 시작

		// gridRowJson 배열 Data 중의 어떤 객체 ( obj ) 의 mrpGatheringNo 가 
		// 가장 최근에 선택한 codeGrid 행의 divisionCodeNo 와 같으면
		if( obj.mrpGatheringNo == selectedMrpGatheringNo ) {
			
			// obj 의 mrpTOList : 선택된 소요량취합번호에 해당하는 소요량 전개 Data 
			$('#mrpSearchGrid')
				.jqGrid('setGridParam',{ datatype : 'local', data : obj.mrpTOList })
				.trigger('reloadGrid');
			
		} 
		
	});  // 반복문 끝
	
}

</script>

</head>

<body>

	<fieldset style="display: inline;">
	    <legend>소요량취합 검색</legend>
    		<label for="radio-1">발주/작업지시 기한</label>
    		<input type="radio" name="searchDateCondition" value="claimDate" id="radio-1">
    		<label for="radio-2">발주/작업지시 완료 기한</label>
    		<input type="radio" name="searchDateCondition" value="dueDate" id="radio-2">

	</fieldset>

	<input type="text" value="시작일" id="mrpGatheringStartDatePicker" />
	<input type="text" value="종료일" id="mrpGatheringEndDatePicker" />
	<input type="button" value="소요량취합 조회" id="mrpGatheringSearchButton" />
	
<table>
	<tr>
		<td>
			
			<table id="mrpGatheringGrid"></table>
			<div id="mrpGatheringGripPager"></div>

		</td>
		<td>
		
			<table id="mrpSearchGrid"></table>
			<div id="mrpSearchGridPager"></div>
			
		</td>
	</tr>

</table>




</body>
</html>