<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>자재명세서 (BOM)</title>
<style>

#itemCodeSearchBox, #parentItemCodeSearchBox {
	display: inline;
	width: 160px;
	margin-bottom: 10px;
	transition: 0.6s;
	outline: none;
	height: 30px;
	font-size: 20px;
	text-align : center;
	
}

#tabs table{
	font-size:11px;
}

#tabs .ui-jqgrid .ui-widget-header {
		height: 30px;
		font-size: 1em;
}

.ui-datepicker{
	z-index: 9999 !important;
}

.ui-dialog { 
	z-index: 9999 !important ; 
	font-size:12px;
}


</style>
<script>

var lastSelected_bomDeployGrid_Id;   // 가장 나중에 선택한 bomDeploy grid 의 행 id 
var lastSelected_bomDeployGrid_RowValue;   // 가장 나중에 선택한 bomDeploy grid 의 행 값 

var lastSelected_bomInfoGrid_Id;   // 가장 나중에 선택한 bomInfo grid 의 행 id
var lastSelected_bomInfoGrid_RowValue;   // 가장 나중에 선택한 bomInfo grid 의 행 값

var lastSelected_bomRegisterAvailableGrid_Id;   // 가장 나중에 선택한 bomRegisterAvailable gird 의 행 id
var lastSelected_bomRegisterAvailableGrid_RowValue;   // 가장 나중에 선택한 bomRegisterAvailable grid 의 행 값

var previousCellValue;  // 수정 가능한 셀에서 수정 전의 셀 값 
var resultList = [];  // 최종적으로 컨트롤러로 보내는 JS 객체 배열 

var gridRowJson;  // bomDeployGrid 에 넣는 데이터  : treeGrid 사용을 위해 지정

var deployCondition;    // "정전개" 선택시 forward , "역전개" 선택시 reverse 값이 저장됨
var itemClassificationCondition;   //"완제품" , "반제품" , "원재료" 선택시 각각의 구분코드 값이 저장됨

function showModalCode(codeName,divisionCode){
    var option="width=550; height=430; left=500; top=200; titlebar=no; toolbar=no,status=no,menubar=no,resizable=yes, location=no";
    window.open("${pageContext.request.contextPath}/bom/codeModal/view?code="+codeName+"&divisionCode="+divisionCode,"newwins",option);

}

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
	
	$("#codeDialog").hide();
	
	$("#bomRegisterDialog").hide();
	
	$( "#tabs" ).tabs({
		//event: "mouseover" ,
	    collapsible: true
	      
	});
	
	initGrid();
	initEvent();
	
});

function initGrid() {

	// BOM 그리드 시작
	$('#bomDeployGrid').jqGrid({ 
		datatype : 'jsonstring',   // treeGrid 를 적용하기 위해 datatype 을 바꿈
		datastr : gridRowJson,		


		colNames : [ "BOM 번호", "BOM 레벨", "상위품목코드", "품목코드", "품목명", "단위", "정미수량",  
			"손실율", "필요수량", "리드타임", "isLeaf", "비고" ], 
		colModel : [
			{ name: "bomNo", width: "80", resizable: true, align: "center" } ,
			{ name: "bomLevel", width: "80", resizable: true, align: "center" ,  
				formatter : function (cellvalue, options, rowObj) {
					
					if( rowObj.bomLevel != 0 ) {
						return rowObj.bomLevel
					} else {
						return '';
					}
					
				}
			
			} ,
			{ name: "parentItemCode", width: "90", resizable: true, align: "center" ,
				
				formatter : function (cellvalue, options, rowObj) { 
					
					if( rowObj.parentItemCode == 'NULL' ) {
						return '';
					} else {
						return rowObj.parentItemCode;
					}
					
				}
			
			} ,
			{ name: "itemCode", width: "160", resizable: true, align: "left" , 
				formatter : function (cellvalue, options, rowObj) {
					
					var space = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
					var str = rowObj.itemCode;
					
					for( var i = 0 ; i < rowObj.bomLevel ; i++) {
						str = space + str
						
					}
					
					if( rowObj.bomLevel != '' ) {
						return str;
					} else {
						return rowObj.itemCode;
					}
					
				}
			
			} ,
			{ name: "itemName", width: "140", resizable: true, align: "center"} ,
			{ name: "unitOfStock", width: "70", resizable: true, align: "center"} ,			
			{ name: "netAmount", width: "70", resizable: true, align: "center",
				formatter:'integer',formatoptions: { defaultValue: '0', thousandsSeparator: ',' }
	        } ,
			{ name: "lossRate", width: "80", resizable: true, align: "center", 
				formatter:'integer',formatoptions: { defaultValue: '0', thousandsSeparator: ',' }
	        } ,
			{ name: "necessaryAmount", width: "70", resizable: true, align: "center", 
			        formatter:'integer',formatoptions: { defaultValue: '0', thousandsSeparator: ',' }
	        } , 
	        { name: "leadTime", width: "80", resizable: true, align: "center" } ,
			{ name: "isLeaf", width: "10", resizable: true, align: "center", hidden: true} ,
			{ name: "description", width: "120", resizable: true, align: "center"} 

		], 
		caption : 'BOM 정전개 / 역전개', 
		multiselect : false, 
		multiboxonly : false,
		viewrecords : false, 
		rownumWidth : 30, 
		height : 250, 
		width : 1000,
		autowidth : true, 
		shrinkToFit : false, 
		cellEdit : true,
		rowNum : 100,   
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
		jsonReader: {
	        repeatitems: false,
	        id : "itemCode"
	    },
	    
	    gridComplete: function() { 
	    	
	        $(this).find(".treeclick").trigger('click');   // 그리드 보일때 모든 트리 확장

	    },

	    
		beforeEditCell(rowid, cellname, value, iRow, iCol){

			if( lastSelected_bomGrid_Id != rowid ){
				lastSelected_bomGrid_Id = rowid;
				lastSelected_bomGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
			
		},
		
		onSelectRow: function(rowid) {   
	
			if( lastSelected_bomGrid_Id != rowid ){
				lastSelected_bomGrid_Id = rowid;
				lastSelected_bomGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
			
		},
		
		onCellSelect : function(rowid, iCol, previousCellValue, e) {
			
			if( lastSelected_bomGrid_Id != rowid ){
				lastSelected_bomGrid_Id = rowid;
				lastSelected_bomGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
		}
	}); // bomDeploy 그리드 끝
	
	

	// bomInfo 그리드 시작
	$('#bomInfoGrid').jqGrid({ 
		mtype : 'POST', 
		datatype : 'local',
		colNames : [ "삭제", "출력순서 지정", "품목구분",  "품목코드", "품목명", "정미수량", "설명", 
			"status", "itemClassification", "parentItemCode", "beforeStatus", "deleteStatus"], 
		colModel : [ 
			{ name: "bomDeleteCheck", width: "50", resizable: true, align: "center" ,
				formatter : function (cellvalue, options, rowObj) {
					
					var chk = "";
					
					if( rowObj.no != 1 ) {
						chk = "<input type='checkbox' name='bomDeleteCheck'  value=" +
							JSON.stringify(options.rowId) +" />";
						return chk
					} else {
						return " ";
					}
					
				}
			},
			{ name: "no", width: "100", resizable: true, align: "center", editable : true  } ,
			{ name: "itemClassificationName", width: "90", resizable: true, align: "center"} ,
			{ name: "itemCode", width: "90", resizable: true, align: "center"} ,
			{ name: "itemName", width: "150", resizable: true, align: "center"} ,
			{ name: "netAmount", width: "100", resizable: true, align: "center", editable : true } ,
			{ name: "description", width: "120", resizable: true, align: "center", editable : true } ,
			{ name: "status", width: "80", resizable: true, align: "center"} ,
			{ name: "itemClassification", width: "50", resizable: true, align: "center" , hidden : true } ,
			{ name: "parentItemCode", width: "50", resizable: true, align: "center", hidden : true } ,
			{ name: "beforeStatus", width: "10", resizable: true, align: "center", hidden: true },
			{ name: "deleteStatus", width: "80", resizable: true, align: "center" , hidden : true  }


		], 
		caption : 'BOM 등록/수정', 
		sortname : 'no', 
		multiselect : false, 
		multiboxonly : false,
		viewrecords : false, 
		rownumWidth : 30, 
		height : 180, 
		width : 1150,
		autowidth : false, 
		shrinkToFit : false, 
		cellEdit : true,
		rowNum : 50,   // -1 : 모든 로우 한번에 표시, 그런데 잘 안먹히는 경우 많음
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
		pager : '#bomInfoGridPager',

		onSelectRow: function(rowid) {   
			
			if( lastSelected_bomInfoGrid_Id != rowid ){
				lastSelected_bomInfoGrid_Id = rowid;
				lastSelected_bomInfoGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
		},
		
		beforeSelectRow : function( rowid, event ) {
			
        	var beforeStatus = $(this).getCell(rowid,"beforeStatus");
        	var currentStatus = $(this).getCell(rowid,"status");

        	if($(event.target).is(":checkbox")) {
            	
                if($(event.target).is(":checked")) {
        			$(this).setCell(rowid,"status", "DELETE");
        			$(this).setCell(rowid,"beforeStatus", currentStatus);
                } else {
        			$(this).setCell(rowid,"status", beforeStatus);
                }
                
            }
		},
		
		beforeEditCell(rowid, cellname, value, iRow, iCol){

			if( lastSelected_bomInfoGrid_Id != rowid ){
				lastSelected_bomInfoGrid_Id = rowid;
				lastSelected_bomInfoGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
			
        	if(value == null || value == "" ) {
        		previousCellValue = " ";	
        	} else {
        		previousCellValue = value;
        	}
			
		},
		
		afterSaveCell(rowid, cellname, value, iRow, iCol){

			var status = $(this).getCell(rowid,"status");
        	var no = $(this).getCell(rowid,"no");
        	
        	if( no == 1 && iCol == 2 && value == 1 ) {
        		
        		alertError("사용자 에러", "출력순서 1은 모품목에만 적용 가능합니다 <br> 2부터 입력하세요");
    			$(this).setCell(rowid,cellname, previousCellValue);	
        		
        	} else if( no == 1 && iCol == 6 ) {
        		
        		alertError("사용자 에러", "BOM 에서 모품목의 정미수량은 항상 1 입니다 ^^");
    			$(this).setCell(rowid,cellname, 1);	        		
        		
        	} else if(status == 'DELETE') {
        	
        		alertError("사용자 에러", "삭제 예정인 행이었습니다 ^^ </br> 원래 값으로 돌릴께요");
    			$(this).setCell(rowid,cellname, previousCellValue);	

        	}  else if(status == 'NORMAL') {
        		
        		if( previousCellValue != value ) {
    				$(this).setCell(rowid,"status", "UPDATE");
        		}
        		
        	}
        	
		},
		
		onCellSelect : function(rowid, iCol, previousCellValue, e) {

			if( lastSelected_bomInfoGrid_Id != rowid ){
				lastSelected_bomInfoGrid_Id = rowid;
				lastSelected_bomInfoGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
				
			var status = $(this).getCell(rowid,"status");
			var itemClassification = $(this).getCell(rowid,"itemClassification");
						
			if(status == "NORMAL" ){

                if( iCol == 2 && rowid != 1 ) {  // 품목구분 cell 클릭
                	
                	showCodeDialog(this ,rowid , iCol , "IT","품목구분 검색");
                
                } else if (iCol == 3 && rowid != 1 ) {  // 품목코드 cell 클릭
                	
            		showCodeDialog(this ,rowid , iCol , itemClassification,"품목 검색");	

                } 

            } else if ( status == "INSERT" || status == "UPDATE" ) {

                if( iCol == 3  && rowid != 1 ) {  // 품목구분 cell 클릭
                	
                	showCodeDialog(this ,rowid , iCol , "IT","품목구분 검색");
                
                } else if ( iCol == 4 && rowid != 1 ) {  // 품목코드 cell 클릭
                	
                	if(itemClassification != '') {
                		
                		showCodeDialog(this ,rowid , iCol , itemClassification,"품목 검색");
                		
                	} else {
                		
                		alertError('사용자 에러' , '선택한 행에서 품목 구분을 먼저 선택하세요');
                		
                	}
                	
                } 
                
            } 
			
		}
	}); // bomInfo 그리드 끝
	
	// bomInfo 그리드의 페이저 생성
	$('#bomInfoGrid').navGrid("#bomInfoGridPager", {
		add : false,
		del : false,
		edit : false,
		search : true,
		refresh : true,
		view: true
	});
	
	
	
}

function initEvent() {
	
	$('#searchBomDeployButton').on("click", function() {

		itemClassificationCondition = $('input[type=radio][name=itemClassificationCondition]:checked').val();
		
		deployCondition = $(':input:radio[name=deployCondition]:checked').val();
		
		if( itemClassificationCondition == 'IT-MA' && deployCondition == 'forward' ) {   // 원재료 선택 후 정전개시
			alertError("^^" , "원재료를 굳이 정전개할 필요는 없을 것 같아서 막아놈");
			return;
		}
		
		showBomGrid();
		
	});

	$('#itemCodeSearchBox').on("click", function() {
		
		itemClassificationCondition = $('input[type=radio][name=itemClassificationCondition]:checked').val();
		
		deployCondition = $(':input:radio[name=deployCondition]:checked').val();

		if( itemClassificationCondition == null ) {
			alertError("사용자 에러", "폼목 분류를 먼저 선택하세요");
			return;
		} else if ( deployCondition == null ) {
			alertError("사용자 에러", "BOM 검색 조건을 먼저 선택하세요");
			return;
		} 
		showModalCode("itemCodeSearchBox",itemClassificationCondition);
		//showCodeDialogForInput(this, itemClassificationCondition, '품목 검색');
		
	});
	
	
	$('#parentItemCodeSearchBox').on("click", function() {

		itemClassificationCondition2 = $('input[type=radio][name=itemClassificationCondition2]:checked').val();
		
		if( itemClassificationCondition2 == null ) {
			alertError("사용자 에러", "폼목 분류를 먼저 선택하세요");
			return;
		}
		showModalCode("parentItemCodeSearchBox",itemClassificationCondition2);
		//showCodeDialogForInput(this, itemClassificationCondition2, '품목 검색');		
		
	});
	
	
	$('#searchBomInfoButton').on("click", function() { 
		
		showBomInfoGrid();
		
	});
	
	
	$('#bomInsertButton').on("click", function() {
		
		var ids = $('#bomInfoGrid').getRowData();

		var noArr = []; 
		
		$(ids).each(function(index, obj) {
			
			noArr.push(obj.no);
					
		});
		
		var newRowNum = $('#bomInfoGrid').jqGrid('getDataIDs').length+1;  // 새로운 행 넘버
		
		$('#bomInfoGrid').addRowData(
				newRowNum, 
				{ "no" : Math.max.apply(null, noArr) + 1 , // ( no 중 최댓값 ) + 1 을 새로운 no 로 지정
					"parentItemCode" : $('#parentItemCodeSearchBox').val() ,   // bom 에서는 모품목 바로 아래 레벨 품목만 등록
					"status" : "INSERT", 
					"deleteStatus" : "LOCAL 삭제" } );
		
	});

	
	$('#batchSaveButton').on("click", function() {
		
		var rowIdList =  $('#bomInfoGrid').jqGrid('getDataIDs'); 
		
		var insertCount = 0;
		var updateCount = 0;
		var deleteCount = 0;

		$(rowIdList).each(function(index, rowId) {   // 전체 행에 대해 반복문 시작
			
			var rowObject = $('#bomInfoGrid').getRowData(rowId); // 행의 row 값 정보 객체
			var status = rowObject.status;
			
			if(status == 'INSERT' ) {
				
				if( rowObject.itemClassification == '' ) {
					alertError("사용자 에러", "품목분류를 입력하지 않은 행이 있습니다 </br> 저장 목록에서 제외합니다");
				} else if(rowObject.itemCode == '' ) {
					alertError("사용자 에러", "품목코드를 입력하지 않은 행이 있습니다 </br> 저장 목록에서 제외합니다");
				} else if(rowObject.netAmount == '' ){
					alertError("사용자 에러", "정미수량을 입력하지 않은 행이 있습니다 </br> 저장 목록에서 제외합니다");
				} else {
					resultList.push(rowObject);	
					insertCount++;
				}

			} else if (status == 'UPDATE') {
				
				resultList.push(rowObject);
				updateCount++;
				
			} else if (status == 'DELETE') {
				
				if(rowObject.deleteStatus != 'LOCAL 삭제' ) {
					resultList.push(rowObject);
					deleteCount++;
				} else {
					$('#bomInfoGrid').delRowData(rowId);
				}
				
			}
		});
		
		//alert(JSON.stringify(resultList));
		var confirmMsg = 
			( ( insertCount != 0 ) ? insertCount + "개의 항목 추가 \n" : "" )+
			( ( updateCount != 0 ) ? updateCount + "개의 항목 수정 \n" : "" ) +
			( ( deleteCount != 0 ) ? deleteCount + "개의 항목 삭제 \n" : ""  )+
			"\r위와 같이 작업합니다. 계속하시겠습니까?"

		var confirmStatus = "";
		
		if(resultList.length != 0) {
			confirmStatus = confirm(confirmMsg);
				
		}
					
		
		if(resultList.length != 0 && confirmStatus) {
			
			$.ajax({ 
				type : 'POST',
				url : '${pageContext.request.contextPath}/stock/bom/batch' ,
				async :false,
				data : {
					method : 'batchBomListProcess', 
					batchList : JSON.stringify(resultList)
				},
				dataType : 'json', 
				cache : false, 
				success : function(dataSet) {

					console.log(dataSet);
					var resultMsg = 
						"< BOM 수정 작업 내역 >   <br/><br/>"
						+ "추가 : "
						+ ( ( dataSet.result.INSERT.length != 0 ) ? dataSet.result.INSERT + " 개" : "없음" ) + "</br></br>"
						+ "수정 : " 
						+ ( ( dataSet.result.UPDATE.length != 0 ) ? dataSet.result.UPDATE + " 개" : "없음" ) + "</br></br>"
						+ "삭제 : " 
						+ ( ( dataSet.result.DELETE.length != 0 ) ? dataSet.result.DELETE + " 개" : "없음" ) + "</br></br>"
						+ "위와 같이 작업이 처리되었습니다";
						
					alertError("성공", resultMsg);
					showBomInfoGrid();  // bomInfo 그리드 새로 고침
				}
			});  
			
		} else if(resultList.length != 0 && !confirmStatus) {
			
			alertError("^^", "취소되었습니다");
			
		} else if(resultList.length == 0) {
			
			alertError("^^", "추가/수정/삭제할 항목이 없습니다");
		}

		resultList = [];   // 초기화
		

	});
	
}

function showBomGrid() {
	
	$('#bomDeployGrid').jqGrid('clearGridData');
	
	// ajax 시작
	$.ajax({ 
		type : 'GET',
		url : '${pageContext.request.contextPath}/stock/bom/deploy' ,
		data : {
			method : 'searchBomDeploy', 
			itemCode : $("#itemCodeSearchBox").val() ,
			deployCondition : $(':input:radio[name=deployCondition]:checked').val() ,
			itemClassificationCondition : $(':input:radio[name=itemClassificationCondition]:checked').val() 
		},
		dataType : 'json', 
		cache : false, 
		async : false,
		success : function(dataSet) { 
			console.log(dataSet);
			gridRowJson = dataSet.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
			
			// BOM 전개 Data 넣기
			$('#bomDeployGrid')
				.jqGrid('setGridParam',{ datatype : 'jsonstring', datastr : gridRowJson })
				.trigger('reloadGrid');
		
	}});  // ajax 끝
	
}

function showBomInfoGrid() {
	
	itemClassificationCondition2 = $('input[type=radio][name=itemClassificationCondition2]:checked').val();

	if( itemClassificationCondition2 == null ) {
		alertError("사용자 에러", "폼목 분류를 먼저 선택하세요");
		return;
		
	} else if ( $('#itemCodeSearchBox2').val == '품목코드 검색' ) {
		alertError("사용자 에러", "폼목 코드를 먼저 검색하세요");
		return;
		
	};  
	

	$('#bomInfoGrid').jqGrid('clearGridData');
	
	// ajax 시작
	$.ajax({ 
		type : 'GET',
		url : '${pageContext.request.contextPath}/stock/bom/info' ,
		data : {
			method : 'searchBomInfo', 
			parentItemCode : $("#parentItemCodeSearchBox").val() 
		},
		dataType : 'json', 
		cache : false, 
		async : false,
		success : function(dataSet) { 
			console.log(dataSet);
			gridRowJson = dataSet.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
			
			// BOM 구성 Data 넣기
			$('#bomInfoGrid')
				.jqGrid('setGridParam',{ datatype : 'local', data : gridRowJson })
				.trigger('reloadGrid');
		
	}});  // ajax 끝
	
}

/* 
function showCodeDialogForInput(source, devisionCodeNo, detailCodeName){
	
	$("#codeDialog").dialog({
		title : '코드 검색' ,
		width:500,
		height:500,
		modal : true   // 폼 외부 클릭 못하게
	});
	
	$.jgrid.gridUnload("#codeGrid");
	
	$("#codeGrid").jqGrid({
		
            url:"${pageContext.request.contextPath}/base/codeList.do",
            datatype: "json",
            jsonReader: { root: "detailCodeList" },
            postData: { 
            		method: "findDetailCodeList" ,
            		divisionCode: devisionCodeNo   
            	},
			colNames:[ '상세코드번호' , '상세코드이름' , '사용여부' ],
			colModel:[
				{ name : 'detailCode', width:100, align : "center",editable:false},
				{ name : 'detailCodeName', width:100, align : "center", editable:false},
				{ name : 'codeUseCheck', width:100, align : "center",editable:false},
			],
			width: 450,
			height: 300,
			caption: detailCodeName,
			align: "center",
			viewrecords:true,
			rownumbers: true,
			onSelectRow: function(id) {
				
				var detailCode=$("#codeGrid").getCell(id, 1);
				var detailName=$("#codeGrid").getCell(id, 2);
				var codeUseCheck=$("#codeGrid").getCell(id, 3);
				
				if(codeUseCheck != 'n' || codeUseCheck != 'N') {
					
					$(source).val(detailCode);
					
					$("#codeDialog").dialog("close");			

				} else {
					alertError("사용자 에러", "사용 가능한 코드가 아닙니다");
				}
			}
		});

}

 */
function showCodeDialog(grid, rowid, iCol, divisionCodeNo, title){
	
	$("#codeDialog").dialog({
		title : '코드 검색' ,
		width:500,
		height:500,
		modal : true   // 폼 외부 클릭 못하게
	});
	
	$.jgrid.gridUnload("#codeGrid");
	
	$("#codeGrid").jqGrid({
		
            url:"${pageContext.request.contextPath}/compinfo/codeList.do",
            datatype: "json",
            jsonReader: { root: "detailCodeList" },
            postData: { 
            		method: "findDetailCodeList" ,
            		divisionCode: divisionCodeNo   
            },
			colNames:[ '상세코드번호' , '상세코드이름' , '사용여부' ],
			colModel:[
				{ name : 'detailCode', width:100, align : "center",editable:false},
				{ name : 'detailCodeName', width:100, align : "center", editable:false},
				{ name : 'codeUseCheck', width:100, align : "center",editable:false},
			],
			width: 450,
			height: 300,
			caption: title,
			align: "center",
			viewrecords:true,
			rownumbers: true,
			onSelectRow: function(id) {
				
				var detailCode=$("#codeGrid").getCell(id, 1);
				var detailName=$("#codeGrid").getCell(id, 2);
				var codeUseCheck=$("#codeGrid").getCell(id, 3);

				if(codeUseCheck !='N' && codeUseCheck !='n' ) {
					
					if(iCol == 4 || iCol == 5) {  // 품목코드, 품목명 cell 클릭
						var ids = $(grid).getRowData();
						var errorStatus = false;
						
						$(ids).each(function(index, obj) {
							
							var itemCodeInList = obj.itemCode;
							
							if( detailCode == $('#parentItemCodeSearchBox').val() ) {
								alertError("사용자 에러","BOM 구성에 자기 자신인 품목을 등록할 수 없습니다");
								errorStatus = true;
								return;

							} else if( detailCode == itemCodeInList ) {
								alertError("사용자 에러","BOM 구성에 이미 있는 품목입니다");
								errorStatus = true;
								return;
								
							}
							
						});
						
						if(!errorStatus) {
							$(grid).setCell(rowid, "itemCode", detailCode);					
							$(grid).setCell(rowid, "itemName", detailName);	
						}
						
					} else if(iCol == 3) {  // 품목구분 cell 클릭
						$(grid).setCell(rowid, "itemClassificationName", detailName);
						$(grid).setCell(rowid, "itemClassification", detailCode);

					}
					

					$("#codeDialog").dialog("close");
					checkRowChanged(lastSelected_bomInfoGrid_RowValue, grid, rowid);					

				} else {
					alertError("사용자 에러", "사용 가능한 코드가 아닙니다");
				}
			}
		});

}


function checkRowChanged(previousRowValue, grid, rowid) {

	var nextRowValue = $(grid).jqGrid('getRowData', rowid);
	var edited = false;
	
	if(nextRowValue.status == 'NORMAL') {
		for(var key in previousRowValue) {
			if(nextRowValue[key] != previousRowValue[key]) {
				edited = true;
			}
		}		
	}
	
	if(edited) {
		$(grid).setCell(rowid, "status", "UPDATE");
	}

}

</script>
</head>
<body>


<div id="tabs">
	<ul>
    	<li><a href="#tabs-1">BOM 정전개 / 역전개</a></li>
    	<li><a href="#tabs-2" id="tab2">BOM 등록/수정</a></li>
    	
  </ul>

	<div id="tabs-1">
	
		<fieldset style="display: inline;">
	    	<legend>품목 분류</legend>
    			<label for="itemClassification-1">완제품</label>
 	   			<input type="radio" name="itemClassificationCondition" value="IT-CI" id="itemClassification-1">
    			<label for="itemClassification-2">반제품</label>
    			<input type="radio" name="itemClassificationCondition" value="IT-SI" id="itemClassification-2">
    			<label for="itemClassification-3">원재료</label>
    			<input type="radio" name="itemClassificationCondition" value="IT-MA" id="itemClassification-3">
		</fieldset>

		<fieldset style="display: inline;">
		    <legend>BOM 검색조건</legend>
    			<label for="radio-1">정전개</label>
   		 		<input type="radio" name="deployCondition" value="forward" id="radio-1">
    			<label for="radio-2">역전개</label>
    			<input type="radio" name="deployCondition" value="reverse" id="radio-2">
		</fieldset>
		&nbsp;&nbsp;
		
		<input type="text" value="품목코드 검색" id="itemCodeSearchBox" />
		<input type="button" value="BOM 조회" id="searchBomDeployButton" />
		&nbsp;&nbsp;

		<table id="bomDeployGrid" ></table>

	</div>

	<div id="tabs-2">
		<fieldset style="display: inline;">
	    	<legend>품목 분류</legend>
    			<label for="itemClassification2-1">완제품</label>
 	   			<input type="radio" name="itemClassificationCondition2" value="IT-CI" id="itemClassification2-1">
    			<label for="itemClassification2-2">반제품</label>
    			<input type="radio" name="itemClassificationCondition2" value="IT-SI" id="itemClassification2-2">
		</fieldset>
			&nbsp;
			
			<input type="text" value="품목코드 검색" id="parentItemCodeSearchBox" />
			<input type="button" value="BOM 조회" id="searchBomInfoButton" />
			&nbsp;
			
		<fieldset style="display: inline;">
		    <legend>BOM 수정/삭제/저장</legend>
			 	<input type="button" value="새로운 항목 추가" id="bomInsertButton" />
  				<input type="button" value="일괄저장" id="batchSaveButton" />
  			
 		</fieldset>
		

		<table id="bomInfoGrid" ></table>
		<div id="bomInfoGridPager"></div>
		
	</div>

</div>


<div id="bomRegisterDialog">
	<table id="bomRegisterAvailableGrid"></table>
</div>

<div id="codeDialog">
	<table id="codeGrid"></table>
</div>

</body>
</html>