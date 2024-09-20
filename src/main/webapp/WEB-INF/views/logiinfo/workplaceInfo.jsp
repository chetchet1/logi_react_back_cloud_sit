<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사업장 정보</title>
<style>
legend {
	color: #FFFFFF;
}
.ui-datepicker{
	z-index: 9999 !important;
}

.ui-dialog { 
	z-index: 9999 !important ; 
	font-size:12px;
}

#searchAddressValueInputBox, #searchAddressMainNumberInputBox {

	display: inline;
	width: 140px;
	transition: 0.6s;
	outline: none;
	height: 25px;
	font-size: 15x;
	text-align: center;
	margin-top: 10px;
	margin-bottom: 10px;
		
}

.guidanceMsg {

	font-size: 16px;
	margin-top: 10px;
	margin-bottom: 10px;
	
}

.searchAddressLabel {

	font-size: 16px;
	margin-top: 10px;
	margin-bottom: 10px;
}

</style>
<script>

var lastSelected_workplaceGrid_Id;   // 가장 나중에 선택한 사업장 grid 의 행 id 
var lastSelected_workplaceGrid_RowValue;   // 가장 나중에 선택한 사업장 grid 의 행 값 

var previousCellValue;  // 수정 가능한 셀에서 수정 전의 셀 값 
var resultList = [];  // 최종적으로 컨트롤러로 보내는 JS 객체 배열 

var chkcell = { cellId : undefined, chkval : undefined }; // addressGrid 에서 cnt 컬럼의 cell rowspan 중복 체크

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

	initGrid();
	initEvent();
	
	$('#addressDialog').hide();
	
	showWorkplaceGrid();
});

function initGrid() {

	// 사업장 그리드 시작
	$('#workplaceGrid').jqGrid({ 
		mtype : 'POST', 
		datatype : 'local',
		colNames : [ "삭제", "사업장코드", "사업장명" , "사업자등록번호" , "법인등록번호" , "대표자명" , "업태" , "종목" , 
			"사업장우편번호" , "사업장기본주소" , "사업장세부주소", "사업장전화번호", "사업장팩스번호", "사업장 개업년월일", "사업장 설립년월일", 
			"사업장 폐업년월일", "본점여부" , "status", "companyCode" , "beforeStatus" , "deleteStatus"] ,
		colModel : [ 		
			{ name: "workplaceDeleteCheck", width: "40", resizable: true, align: "center" , hidden : true  , // 삭제 기능은 숨겨둠
				formatter : function (cellvalue, options, rowObj) {
					
					var chk = "<input type='checkbox' name='workplaceDeleteCheck' value=" +
		     		JSON.stringify(options.rowId) + " />";			
				     
					return chk;
					
				}
			},
			{ name: "workplaceCode", width: "80", resizable: true, align: "center"} ,
			{ name: "workplaceName", width: "140", resizable: true, align: "center" , editable : true } ,
			{ name: "businessLicenseNumber", width: "120", resizable: true, align: "center" , editable : true } ,
			{ name: "corporationLicenseNumber", width: "120", resizable: true, align: "center" , editable : true } ,
			{ name: "workplaceCeoName", width: "80", resizable: true, align: "center" , editable : true } ,
			{ name: "workplaceBusinessConditions", width: "100", resizable: true, align: "center" , editable : true } ,
			{ name: "workplaceBusinessItems", width: "100", resizable: true, align: "center" , editable : true } ,
			{ name: "workplaceZipCode", width: "100", resizable: true, align: "center" } ,
			{ name: "workplaceBasicAddress", width: "300", resizable: true, align: "center" } ,
			{ name: "workplaceDetailAddress", width: "150", resizable: true, align: "center" , editable : true } ,
			{ name: "workplaceTelNumber", width: "100", resizable: true, align: "center" , editable : true } ,
			{ name: "workplaceFaxNumber", width: "100", resizable: true, align: "center" , editable : true } ,
			{ name: "workplaceEstablishDate", width: "100", resizable: true, align: "center", editable: true,
//				  formatter: 'date',   => 주석 처리 : 여기 지정되면 사용자가 값을 미입력시 걸러주지 못함
//				  formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' },  
				  edittype: 'text', 
		          editoptions: { size: 12, maxlengh: 12, 
						dataInit: function (element) { 
							$(element).datepicker({ 
								changeMonth: true, 
								numberOfMonths: 1, 
								onClose: function(dateText, datepicker) {
									$(this).editCell( lastSelected_companyGrid_Id,15, false); 
								}
		                  })}
		          }, 
		          editrules: { date: true } 
			} ,
			{ name: "workplaceOpenDate", width: "100", resizable: true, align: "center", editable: true,
//				  formatter: 'date',   => 주석 처리 : 여기 지정되면 사용자가 값을 미입력시 걸러주지 못함
//				  formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' },  
				  edittype: 'text', 
		          editoptions: { size: 12, maxlengh: 12, 
						dataInit: function (element) { 
							$(element).datepicker({ 
								changeMonth: true, 
								numberOfMonths: 1, 
								onClose: function(dateText, datepicker) {
									$(this).editCell(lastSelected_companyGrid_Id, 16 ,false); 
								}
		                  })}
		          }, 
		          editrules: { date: true } 
			} ,
			{ name: "workplaceCloseDate", width: "100", resizable: true, align: "center", editable: true,
//				  formatter: 'date',   => 주석 처리 : 여기 지정되면 사용자가 값을 미입력시 걸러주지 못함
//				  formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' },  
				  edittype: 'text', 
		          editoptions: { size: 12, maxlengh: 12, 
						dataInit: function (element) { 
							$(element).datepicker({ 
								changeMonth: true, 
								numberOfMonths: 1, 
								onClose: function(dateText, datepicker) {
									$(this).editCell(lastSelected_companyGrid_Id, 16 ,false); 
								}
		                  })}
		          }, 
		          editrules: { date: true } 
			} ,
			{ name: "isMainOffice", width: "50", resizable: true, align: "center", editable : true } ,
			{ name: "status", width: "80", resizable: true, align: "center" } ,
			{ name: "companyCode", width: "80", resizable: true, align: "center" , hidden: true} ,
			{ name: "beforeStatus", width: "10", resizable: true, align: "center" , hidden: true} ,
			{ name: "deleteStatus", width: "10", resizable: true, align: "center" , hidden: true} 

		], 
		caption : '사업장 정보', 
		sortname : 'workplaceCode', 
		multiselect : false, 
		multiboxonly : false,
		viewrecords : false, 
		rownumWidth : 30, 
		height : 200, 
		width : 1000,
		autowidth : true, 
		shrinkToFit : false, 
		cellEdit : true,
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
		pager : '#workplaceGridPager',
		
		beforeEditCell(rowid, cellname, value, iRow, iCol){

        	if(value == null || value == "" ) {
        		previousCellValue = null;
        	} else {
        		previousCellValue = value;
        	}
		},
		
		afterSaveCell(rowid, cellname, value, iRow, iCol){

        	var status = $(this).getCell(rowid,"status");

        	if(status == 'DELETE') {
        	
        		alertError("사용자 에러", "삭제 예정인 행이었습니다 ^^ </br> 원래 값으로 돌릴께요");
    			$(this).setCell(rowid,cellname, previousCellValue);	

        	} else if(status == 'NORMAL') {
        		
        		if( previousCellValue != value ) {
    				$(this).setCell(rowid,"status", "UPDATE");
        		}
        		
        	}
		},
		
		
		beforeSelectRow : function( rowid, event ) {
			
			var $target = $(event.target);
		    var $td = $target.closest("td");
	        var iCol = $.jgrid.getCellIndex($td[0]);
	        var colModel = $(this).jqGrid("getGridParam", "colModel");
		    var chekedColumn = colModel[iCol].name;    // jqGrid colModel 에 등록된 name
		    
	        var beforeStatus = $(this).getCell(rowid,"beforeStatus");
        	var currentStatus = $(this).getCell(rowid,"status");

	    	if ( $target.is(":checkbox") && $target.is(":checked") ) {  // 체크시

	    		switch(chekedColumn) { 
	    		
	    			case 'workplaceDeleteCheck' :
                    	
	        			$(this).setCell(rowid,"status", "DELETE");
	        			$(this).setCell(rowid,"beforeStatus", currentStatus);
	    				
	    				break;
	    
	    		}
	        	
	    	} else if( $target.is(":checkbox") && !$target.is(":checked") ) {  // 체크 해제시
	    		
	    		switch(chekedColumn) {
	    		
	    			case 'workplaceDeleteCheck' :

	    				$(this).setCell(rowid,"status", beforeStatus);
	    				break;
	    		
	    		}
	    		
	    	}
	    	
		},
		
		onSelectRow: function(rowid) {   
	
			if( lastSelected_workplaceGrid_Id != rowid ){
				lastSelected_workplaceGrid_Id = rowid;
				lastSelected_workplaceGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
			

		},
		
		onCellSelect : function(rowid, iCol, previousCellValue, e) {
						
			if( lastSelected_workplaceGrid_Id != rowid ){
				lastSelected_workplaceGrid_Id = rowid;
				lastSelected_workplaceGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
					
			var status = $(this).getCell(rowid,"status");
			
			if( status == "NORMAL" ){

				if(iCol == 9 || iCol == 10) {  // 사업장 우편번호, 사업장 기본주소 cell 클릭
                	
					showAddressDialog(this, rowid, iCol);
                
                }
				
            } else if ( status == "INSERT" || status == "UPDATE" ) {

				if(iCol == 9 || iCol == 10) {  // 사업장 우편번호, 사업장 기본주소 cell 클릭
                	
					showAddressDialog(this, rowid, iCol);
                
                }
                
            } 
		}
	});   // 사업장정보 그리드 끝
	
	// 사업장정보 그리드 페이저
	$('#workplaceGrid').navGrid("#workplaceGridPager", {
		add : false,
		del : false,
		edit : false,
		search : true,
		refresh : true,
		view: true
	});
	
}

function initEvent() {
	
	$('#workplaceInsertButton').on("click" , function() {
		
		var grid = $('#workplaceGrid');
		
		/*    
		// 한번에 하나의 Inset 만 하고 싶다면 다음 코드를 추가하면 됨
		
		var allRowList = grid.getRowData(); 
		var edited = false;
		
		$(allRowList).each ( function() { 
			
			if(this.status == 'INSERT') {
				
				edited = true;
			}
			
		});
	
		if(edited == true) {
			alertError("사용자 에러" , "작업 중인 세부정보를 먼저 저장하세요");
			return;
			
		}
	
		*/
		

		var newRowNum = grid.jqGrid('getDataIDs').length+1;  // 새로운 행 넘버
		
		grid.addRowData(
				newRowNum, 
				{ "workplaceCode":"저장시 지정됨", "companyCode" : "${sessionScope.companyCode}" ,
					"status":"INSERT" , "deleteStatus" : "LOCAL 삭제" } );

	});
	
	$('#batchSaveButton').on("click" , function() {

		var grid = $('#workplaceGrid');
		
		var rowIdList =  grid.jqGrid('getDataIDs');   // 그리드의 전체 행 ID 배열
				
		var insertCount = 0;
		var updateCount = 0;
		var deleteCount = 0;

		var errorMsg = "< 제외 목록 > \r";  
		
		$(rowIdList).each( function(index, rowId) {   // 전체 행에 대해 반복문 시작
			
			var rowObject = grid.getRowData(rowId); // 행의 row 값 정보 객체

			var status = rowObject.status;
			
			// 사용자 유효성 검사
			if(status == 'INSERT' ) {
				
				if(rowObject.workplaceName == '' ) {
					errorMsg += ( rowId + "행 : 사업장명 미입력 \r" );

				}else if(rowObject.businessLicenseNumber == '' ) {
					errorMsg += ( rowId + "행 : 사업자 등록번호 미입력 \r" );

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
					grid.delRowData(rowId);
				}
				
			}
		});

		var confirmMsg = 
			( ( errorMsg == "< 제외 목록 > \r" ) ? "" : errorMsg + "\r" ) + 
			"< 가능한 작업 목록 > \r" +
			( ( insertCount != 0 ) ? insertCount + "개의 사업장 정보 추가 \n" : "" ) +
			( ( updateCount != 0 ) ? updateCount + "개의 사업장 정보 수정 \n" : "" ) +
			( ( deleteCount != 0 ) ? deleteCount + "개의 사업장 정보 삭제 \n" : ""  ) +
			"\r위와 같이 작업합니다. 계속하시겠습니까?"

		var confirmStatus = "";
		
		if(resultList.length != 0) {
			confirmStatus = confirm(confirmMsg);

		}
		
		if(resultList.length != 0 && confirmStatus) {
			
			$.ajax({ 
				type : 'POST',
				url : '${pageContext.request.contextPath}/compinfo/workplace/batch' ,
				async :false,
				data : {
					method : 'batchListProcess', 
					batchList : JSON.stringify(resultList)
				},
				dataType : 'json', 
				cache : false, 
				success : function(dataSet) {

					console.log(dataSet);
					var resultMsg = 
						"< 사업장 정보 작업 내역 >   <br/><br/>"
						+ "추가된 사업장 코드 : "
						+ ( ( dataSet.result.INSERT.length != 0 ) ? dataSet.result.INSERT : "없음" ) + "</br></br>"
						+ "수정된 사업장 코드 : " 
						+ ( ( dataSet.result.UPDATE.length != 0 ) ? dataSet.result.UPDATE : "없음" ) + "</br></br>"
						+ "삭제된 사업장 코드 :  : " 
						+ ( ( dataSet.result.DELETE.length != 0 ) ? dataSet.result.DELETE : "없음" ) + "</br></br>"
						+ "위와 같이 작업이 처리되었습니다";
						
					alertError("성공", resultMsg);
					
					
					showWorkplaceGrid();  // 사업장 그리드 새로고침
				}
			});  
			
		} else if(resultList.length != 0 && !confirmStatus) {
			
			alertError("^^", "취소되었습니다");
			
		} else if(resultList.length == 0) {
			
			alertError("^^", "추가/수정/삭제할 사업장 정보가 없습니다");
		}

		resultList = [];   // 초기화
		
	});
	
}

function showWorkplaceGrid() {
	
	$('#workplaceGrid').jqGrid('clearGridData');

	$.ajax({ 
		type : 'GET',
		url : '${pageContext.request.contextPath}/compinfo/workplace/list' ,
		async :false,
		data : {
			method : 'searchWorkplaceList' ,
			companyCode : '${sessionScope.companyCode}'  // 자신의 회사에 속한 사업장만 검색
		},
		dataType : 'json', 
		cache : false, 
		success : function(dataSet) {

			console.log(dataSet);

			var gridRowJson = dataSet.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
			
			// 코드 Data 넣기
			$('#workplaceGrid')
				.jqGrid('setGridParam',{ datatype : 'local', data : gridRowJson })
				.trigger('reloadGrid');
		}
		
	});  
	
}

function showAddressDialog(grid, rowid, iCol){
		
	$('#roadNameGuidanceMsg').show();
	$('#jibunGuidanceMsg').hide();
	
	$('#searchAddressValueInputBox').val("");   // 초기화
	$('#searchAddressMainNumberInputBox').val("");   // 초기화
	
	$('#searchAddressValueLabel').html('도로명/건물명');
	$('#searchAddressMainNumberLabel').html('(선택) 건물번호')
	
	// 주소 그리드 시작
	$("#addressGrid").jqGrid({
		
		mtype : 'POST', 
		datatype : 'local',
		colNames:[ '' , '우편번호' , '주소' , 'addressType' , 'addressNo' ],
		colModel:[
			{ name : 'cnt', width : 20, align : "center" , 

				cellattr : function(rowid, val, rowObject, cm, rdata) {

			        var result = "";
			         
			        if(chkcell.chkval != val){ //check 값이랑 비교값이 다른 경우
			            var cellId = this.id + '_row_'+rowid+'-'+cm.name;
			            result = ' rowspan="1" id ="'+cellId+'" + name="cellRowspan"';
			            chkcell = {cellId:cellId, chkval:val};
			        } else {
			            result = 'style="display:none" rowspanid="'+chkcell.cellId+'"'; //같을 경우 display none 처리
			        }
			        return result;

				}
			},
			{ name : 'zipCode', width:40, align : "center" },
			{ name : 'address', width:200 },
			{ name : 'addressType', width :100, align : "center", hidden : true },
			{ name : 'addressNo', width :100, align : "center", hidden : true },

		],
		width: 600,
		height: 280,
		rowNum : 100, 
		align: "center",
		viewrecords : true,
		cache : false, 
		loadonce: true,
		pager : '#addressGridPager',
		onSelectRow: function(id) {
			
			var zipCode = $("#addressGrid").getCell(id, 1);
			var address = $("#addressGrid").getCell(id, 2);

			$(grid).setCell(rowid, "workplaceZipCode", zipCode);
			$(grid).setCell(rowid, "workplaceBasicAddress", address);
			
			$('#addressGrid').jqGrid('clearGridData');
			$("#addressDialog").dialog("close");
			checkRowChanged(lastSelected_workplaceGrid_RowValue, grid, rowid);					
	
		},
		
		 gridComplete: function() {  /** 데이터 로딩시 함수 **/
                var grid = this;
                 
                $('td[name="cellRowspan"]', grid).each(function() {
                    var spans = $('td[rowspanid="'+this.id+'"]',grid).length+1;
                    if(spans>1){
                     $(this).attr('rowspan',spans);
                    }
                });    

		 }
		
	}); // 주소 그리드 끝

	// 주소 그리드 페이저 설정
	$('#addressGrid').navGrid("#addressGridPager", {
		add : false,
		del : false,
		edit : false,
		search : true,
		refresh : true,
		view: true
	});
	
	
	// 주소 dialog 설정 시작
	$("#addressDialog").dialog({
		title : '주소 검색',
		autoOpen : false, 
		width : 630,
		height : 550,
		modal : true,   // 폼 외부 클릭 못하게
		position : {    // 폼 열릴 때 위치
			my : "center center",  
			at : "center-80 center-120"   // 폼 열릴 때, 대강 화면 중앙에 오도록
		},
		open : function(event, ui) {

			// 주소 dialog 내 요소들에 이벤트 등록
			
			$("#searchSidoNameBox").selectmenu({

				width : 140,
				
				change : function(event, data) {

					$('#searchAddressValueInputBox').val("");   // 초기화
					$('#searchAddressMainNumberInputBox').val("");   // 초기화
					
				}

			});
			
			$('#roadNameAddressRadio, #jibunAddressRadio').on( "click", function() {
				
				var searchAddressType = $(':input:radio[name=searchAddressTypeCondition]:checked').val();
				
				if( searchAddressType == 'roadNameAddress' ) {
					
					$('#roadNameGuidanceMsg').show();
					$('#jibunGuidanceMsg').hide();
					
					$('#searchAddressValueLabel').html('도로명/건물명');
					$('#searchAddressMainNumberLabel').html('(선택) 건물번호')
					
				} else if (searchAddressType == 'jibunAddress' ) { 
					
					$('#roadNameGuidanceMsg').hide();
					$('#jibunGuidanceMsg').show();

					$('#searchAddressValueLabel').html('지번/건물명');
					$('#searchAddressMainNumberLabel').html('(선택) 지번본번')

				}
				
				
			});

			$('#addressSearchButton').on( "click" , function() {	
				
				if( $(':input:radio[name=searchAddressTypeCondition]:checked').val() == null ) {
					
					alertError('사용자 에러', '주소 유형을 먼저 선택하세요');
					return;

				} else if ( $('#searchAddressValueInputBox').val() == '' ) {

					alertError('사용자 에러', '검색할 주소를 먼저 입력하세요');
					return;
					
				}
				
				
				$.ajax({ 
					type : 'GET',
					url : '${pageContext.request.contextPath}/compinfo/address/list' ,
					data : {
						method : 'searchAddressList' ,
						sidoName : $("#searchSidoNameBox").val(),  // 주소 검색시 시도 선택값
						searchAddressType : $(':input:radio[name=searchAddressTypeCondition]:checked').val(),
						searchValue : $('#searchAddressValueInputBox').val(),
						mainNumber : $('#searchAddressMainNumberInputBox').val()
					},
					dataType : 'json', 
					cache : false, 
					success : function(dataSet) { 

						console.log(dataSet);
						var addressList = dataSet.addressList;

						if(addressList.length == 0 ) {
							alertError("ㅜㅜ", "검색된 데이터가 없습니다");
							
						} else {
						
							$('#addressGrid').jqGrid('clearGridData'); // 초기화

							chkcell = { cellId : undefined, chkval : undefined }; // 초기화
							
							// 주소 Data 넣기
							$('#addressGrid')
								.jqGrid('setGridParam',{ datatype : 'local', data : addressList })
								.trigger('reloadGrid');
														
						}
					}		
				});	
				
			});
			
		}
	
	});


	$("#addressDialog").dialog("open");
	
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
	<fieldset style="display: inline;">
	    <legend>사업장 정보 관리</legend>
		 	<input type="button" value="새로운 사업장 정보 추가" id="workplaceInsertButton" />
  			<input type="button" value="일괄저장" id="batchSaveButton" />
  			
 	</fieldset>

<table id="workplaceGrid" ></table>
<div id="workplaceGridPager"></div>

<div id="addressDialog">
	<fieldset id="searchSidoNameFieldset" style="display: inline;">
			<legend>시도</legend>
			
			<select id="searchSidoNameBox">
				<option value="시도 선택">시도 선택</option>
				<option value="서울특별시">서울특별시</option>
				<option value="부산광역시">부산광역시</option>
				<option value="대구광역시">대구광역시</option>
				<option value="인천광역시">인천광역시</option>
				<option value="광주광역시">광주광역시</option>
				<option value="대전광역시">대전광역시</option>
				<option value="울산광역시">울산광역시</option>
				<option value="세종특별자치시">세종특별자치시</option>
				<option value="경기도">경기도</option>
				<option value="강원도">강원도</option>
				<option value="충청북도">충청북도</option>
				<option value="충청남도">충청남도</option>
				<option value="전라북도">전라북도</option>
				<option value="전라남도">전라남도</option>
				<option value="경상북도">경상북도</option>
				<option value="경상남도">경상남도</option>
				<option value="제주특별자치도">제주특별자치도</option>
								
			</select> 
	</fieldset>
	
	<fieldset id="searchAddressTypeFieldset" style="display: inline;">
		<legend>주소 유형</legend>
		
		<label for="roadNameAddressRadio">도로명 주소</label> <input type="radio"
			name="searchAddressTypeCondition" value="roadNameAddress" id="roadNameAddressRadio">
		<label for="jibunAddressRadio">지번 주소</label> <input type="radio"
			name="searchAddressTypeCondition" value="jibunAddress" id="jibunAddressRadio">
		
	</fieldset>
	&nbsp;
	<input type="button" value="주소 조회" id="addressSearchButton" style="font-size: 20px"/> 
	
	<div class = "guidanceMsg" id="roadNameGuidanceMsg">도로명 또는 건물명을 입력하세요. &nbsp;예) 중앙로, 불정로432번길, 혜람빌딩</div>
	<div class = "guidanceMsg" id="jibunGuidanceMsg">동/읍/면/리 이름 또는 건물명을 입력하세요. &nbsp;예) 역삼동, 화도읍, 둔내면, 혜람빌딩</div>
		
	<label for="searchAddressValueInput" id="searchAddressValueLabel" class ="searchAddressLabel" ></label> &nbsp; 
	<input type="text" id="searchAddressValueInputBox"  /> &nbsp; &nbsp; 
	<label for="searchAddressMainNumberInputBox" id="searchAddressMainNumberLabel" class ="searchAddressLabel"></label> &nbsp;
	<input type="text" id="searchAddressMainNumberInputBox"  /> &nbsp; 
	
	<table id="addressGrid"></table>
	<div id="addressGridPager"></div>
	
</div>  <!-- addressDialog 끝 -->

</body>
</html>