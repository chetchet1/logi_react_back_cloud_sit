<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>거래처 정보</title>
<style>

#searchDetailCodeName1, #searchDetailCodeName2 {
	display: inline;
	width: 240px;
	transition: 0.6s;
	outline: none;
	height: 30px;
	font-size: 10x;
	text-align: center;
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






var previousCellValue;  // 수정 가능한 셀에서 수정 전의 셀 값 
var resultList = [];  // 최종적으로 컨트롤러로 보내는 JS 객체 배열 

var searchConditionValue; // 거래처 검색 조건 => "ALL" : 전체 , "WORKPLACE" : 사업장

var chkcell = { cellId : undefined, chkval : undefined }; // addressGrid 에서 cnt 컬럼의 cell rowspan 중복 체크



//문서가 완료되면불릴 함수
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

//------------------------------------------------일반거래처 검색 조건-------------------------------------------//	
//일반거래처 검색 조건에있는 셀렉트	
	$("#searchConditionBox1").selectmenu({

		width : 120,

		change : function(event, data) {

			searchConditionValue = data.item.value;

			switch (searchConditionValue) {

			case 'ALL':

				$('#searchDetailCodeName1').hide();

				break;

			case 'WORKPLACE':

				$('#searchDetailCodeName1').val('사업장 조회');

				$('#searchDetailCodeName1').show();

				break;

			}

			$('#customerGrid').jqGrid('clearGridData');

			lastSelected_customerGrid_Id = ""; // 초기화
			lastSelected_customerGrid_RowValue = ""; // 초기화
			
		}
	});
	var lastSelected_customerGrid_Id;   // 가장 나중에 선택한 일반거래처 grid 의 행 id 
	var lastSelected_customerGrid_RowValue;   // 가장 나중에 선택한 일반거래처 grid 의 행 값 
	//------------------------------------------------일반거래처 조회 버튼-------------------------------------------//		
	//일반거래처 조회 버튼 클릭시
	$('#customerListSearchButton').on("click" , function() { 
		
		if( $('#searchDetailCodeName1') == '사업장 조회' ) {
			
			alertError("사용자 에러" , "사업장을 선택하세요");
			return;
		}
		
		showCustomerGrid();
		
	});	
	
	
	function showCustomerGrid() {
		
		$('#custoemrGrid').jqGrid('clearGridData');

		$.ajax({ 
			type : 'GET',
			url : '${pageContext.request.contextPath}/compinfo/customer/list' ,
			async :false,
			data : {
				method : 'searchCustomerList' ,
				searchCondition : searchConditionValue ,
				workplaceCode : ( ( searchConditionValue == 'WORKPLACE' ) ? $('#searchDetailCode1').val() : '' ) ,
			},
			dataType : 'json', 
			cache : false, 
			success : function(dataSet) {

				console.log(dataSet);

				var gridRowJson = dataSet.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
				
				// 일반거래처 Data 넣기
				$('#customerGrid')
					.jqGrid('setGridParam',{ datatype : 'local', data : gridRowJson })
					.trigger('reloadGrid');
			}
			
		});  
		
	}	
	
	
	//------------------------------------------------일반거래처 검색 조건-------------------------------------------//		
	
	// 
	
	$("#searchConditionBox2").selectmenu({

		width : 120,

		change : function(event, data) {

			searchConditionValue = data.item.value;

			switch (searchConditionValue) {

			case 'ALL':

				$('#searchDetailCodeName2').hide();

				break;

			case 'WORKPLACE':

				$('#searchDetailCodeName2').val('사업장 조회');

				$('#searchDetailCodeName2').show();

				break;

			}

			$('#customerGrid').jqGrid('clearGridData');

			lastSelected_financialAccountGrid_Id = ""; // 초기화
			lastSelected_financialAccountGrid_RowValue = ""; // 초기화
			
		}
	});
	var lastSelected_financialAccountGrid_Id;   // 가장 나중에 선택한 금융거래처 grid 의 행 id 
	var lastSelected_financialAccountGrid_RowValue;   // 가장 나중에 선택한 금융거래처 grid 의 행 값 
	
	
	
	//------------------------------------------------일반거래처 일괄저장-------------------------------------------//		
	
		$('#batchSaveButton1').on("click" , function() {

		var grid = $('#customerGrid');
		
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
				
				if(rowObject.workplaceCode == '' ) {
					errorMsg += ( rowId + "행 : 사업장코드 미입력 \r" );

				} else if(rowObject.customerName == '' ) {
					errorMsg += ( rowId + "행 : 거래처명 미입력 \r" );

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
			( ( insertCount != 0 ) ? insertCount + "개의 일반 거래처 정보 추가 \n" : "" ) +
			( ( updateCount != 0 ) ? updateCount + "개의 일반 거래처 정보 수정 \n" : "" ) +
			( ( deleteCount != 0 ) ? deleteCount + "개의 일반 거래처 정보 삭제 \n" : ""  ) +
			"\r위와 같이 작업합니다. 계속하시겠습니까?"

		var confirmStatus = "";
		
		if(resultList.length != 0) {
			confirmStatus = confirm(confirmMsg);

		}
		
		if(resultList.length != 0 && confirmStatus) {
			
			$.ajax({ 
				type : 'POST',
				url : '${pageContext.request.contextPath}/compinfo/customer/batch' ,
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
						"< 일반 거래처 정보 작업 내역 >   <br/><br/>"
						+ "추가된 일반 거래처 코드 : "
						+ ( ( dataSet.result.INSERT.length != 0 ) ? dataSet.result.INSERT : "없음" ) + "</br></br>"
						+ "수정된 일반 거래처 코드 : " 
						+ ( ( dataSet.result.UPDATE.length != 0 ) ? dataSet.result.UPDATE : "없음" ) + "</br></br>"
						+ "삭제된 일반 거래처 코드 :  : " 
						+ ( ( dataSet.result.DELETE.length != 0 ) ? dataSet.result.DELETE : "없음" ) + "</br></br>"
						+ "위와 같이 작업이 처리되었습니다";
						
					alertError("성공", resultMsg);
					
					
					showCustomerGrid();  // 일반거래처 그리드 새로고침
				}
			});  
			
		} else if(resultList.length != 0 && !confirmStatus) {
			
			alertError("^^", "취소되었습니다");
			
		} else if(resultList.length == 0) {
			
			alertError("^^", "추가/수정/삭제할 일반거래처 정보가 없습니다");
		}

		resultList = [];   // 초기화
		
	});
	
	
	
	
	
		//------------------------------------------------금융거래처정보추가-------------------------------------------//		
	
	
//금융거래처정보추가
	$('#financialAccountInsertButton').on("click" , function() {
		
		var grid = $('#financialAccountGrid');/


		var newRowNum = grid.jqGrid('getDataIDs').length+1;  // 새로운 행 넘버
		
		grid.addRowData(
				newRowNum, 
				{ "accountAssociatesCode":"저장시 지정됨", "status":"INSERT" , "deleteStatus" : "LOCAL 삭제" } );

	});
		
		
	//------------------------------------------------금융거래처 조회버튼-------------------------------------------//		
		
		
		
	$('#financialAccountListSearchButton').on("click" , function() { 
		
		if( $('#searchDetailCodeName2') == '사업장 조회' ) {
			
			alertError("사용자 에러" , "사업장을 선택하세요");
			return;
		}
		
		showFinancialAccountGrid();
		
	});		
		
	function showFinancialAccountGrid() {
		

		$('#financialAccountGrid').jqGrid('clearGridData');

		$.ajax({ 
			type : 'GET',
			url : '${pageContext.request.contextPath}/compinfo/financialaccountassociates/list' ,
			async :false,
			data : {
				method : 'searchFinancialAccountAssociatesList' ,
				searchCondition : searchConditionValue ,
				workplaceCode : ( ( searchConditionValue == 'WORKPLACE' ) ? $('#searchDetailCode2').val() : '' ) ,
			},
			dataType : 'json', 
			cache : false, 
			success : function(dataSet) {

				console.log(dataSet);

				var gridRowJson = dataSet.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
				
				// 일반거래처 Data 넣기
				$('#financialAccountGrid')
					.jqGrid('setGridParam',{ datatype : 'local', data : gridRowJson })
					.trigger('reloadGrid');
			}
			
		});  
		
	}	

	//--------------------------------------------금융거래처 일괄저장-----------------------------------------------------//
	
	$('#batchSaveButton2').on("click" , function() {

		var grid = $('#financialAccountGrid');
		
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
				
				if(rowObject.workplaceCode == '' ) {
					errorMsg += ( rowId + "행 : 사업장코드 미입력 \r" );

				} else if(rowObject.accountAssociatesName == '' ) {
					errorMsg += ( rowId + "행 : 거래처명 미입력 \r" );

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
			( ( insertCount != 0 ) ? insertCount + "개의 금융 거래처 정보 추가 \n" : "" ) +
			( ( updateCount != 0 ) ? updateCount + "개의 금융 거래처 정보 수정 \n" : "" ) +
			( ( deleteCount != 0 ) ? deleteCount + "개의 금융 거래처 정보 삭제 \n" : ""  ) +
			"\r위와 같이 작업합니다. 계속하시겠습니까?"

		var confirmStatus = "";
		
		if(resultList.length != 0) {
			confirmStatus = confirm(confirmMsg);

		}
		
		if(resultList.length != 0 && confirmStatus) {
			
			$.ajax({ 
				type : 'POST',
				url : '${pageContext.request.contextPath}/compinfo/financialaccountassociates/batch' ,
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
						"< 일반 거래처 정보 작업 내역 >   <br/><br/>"
						+ "추가된 금융 거래처 코드 : "
						+ ( ( dataSet.result.INSERT.length != 0 ) ? dataSet.result.INSERT : "없음" ) + "</br></br>"
						+ "수정된 금융 거래처 코드 : " 
						+ ( ( dataSet.result.UPDATE.length != 0 ) ? dataSet.result.UPDATE : "없음" ) + "</br></br>"
						+ "삭제된 금융 거래처 코드 :  : " 
						+ ( ( dataSet.result.DELETE.length != 0 ) ? dataSet.result.DELETE : "없음" ) + "</br></br>"
						+ "위와 같이 작업이 처리되었습니다";
						
					alertError("성공", resultMsg);
					
					
					showFinancialAccountGrid();  // 금융거래처 그리드 새로고침
				}
			});  
			
		} else if(resultList.length != 0 && !confirmStatus) {
			
			alertError("^^", "취소되었습니다");
			
		} else if(resultList.length == 0) {
			
			alertError("^^", "추가/수정/삭제할 금융거래처 정보가 없습니다");
		}

		resultList = [];   // 초기화
		
	});
	
	

//--------------------------------------------도로명주소-----------------------------------------------------//
	
	
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
	
	//--------------------------------------------주소조회-----------------------------------------------------//	
	

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
	
	
//--------------------------------------------도로명 , 동읍리-----------------------------------------------------//	
			
			
			
			function showAddressDialog(grid, gridName, rowid, iCol){
				
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

						if(gridName == 'customerGrid') {
							
							$(grid).setCell(rowid, "customerZipCode", zipCode);
							$(grid).setCell(rowid, "customerBasicAddress", address);
							
							$('#addressGrid').jqGrid('clearGridData');
							$("#addressDialog").dialog("close");
							checkRowChanged(lastSelected_customerGrid_RowValue, grid, rowid);									
							
						} else if(gridName == 'financialAccountGrid') {				
						
							// financialAccountGrid 에는 주소 컬럼이 없지만 그냥 넣어둠
							
						}
						
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
						
				

				
					}
				});

				$("#addressDialog").dialog("open");
				
			}			
			//--------------------------------------------도로명 , 동읍리-----------------------------------------------------//				
	$( "#tabs" ).tabs({
		//event: "mouseover" ,
	    collapsible: true
	      
	});
	
	$('#searchDetailCodeName1').hide();
	$('#searchDetailCodeName2').hide();
	$('#addressDialog').hide();
	
	searchConditionValue = 'ALL'; // 최초 페이지 로딩시 전체 조회가 가능하도록 설정

	
	initGrid();
	initEvent();
	
	showCustomerGrid();
	showFinancialAccountGrid();

	
});

function initGrid() {

	// 일반거래처 그리드 시작
	$('#customerGrid').jqGrid({ 
		mtype : 'POST', 
		datatype : 'local',
		colNames : [ "삭제", "일반거래처 코드", "사업장코드", "거래처명" , "거래처유형" , "대표자" , "사업자등록번호" ,
			"개인거래처 주민등록번호" , "업태" , "종목" , "거래처 우편번호" , "거래처 기본주소" , "거래처 세부주소" , 
			"거래처 전화번호" , "거래처 팩스번호", "비고" , "status", "beforeStatus" , "deleteStatus" ] ,
			colModel : [ 		
			{ name: "customerDeleteCheck", width: "40", resizable: true, align: "center" ,
				formatter : function (cellvalue, options, rowObj) {
					
					var chk = "<input type='checkbox' name='customerDeleteCheck' value=" +
		     		JSON.stringify(options.rowId) + " />";			
				     
					return chk;
					
				}
			},
			{ name: "customerCode", width: "100", resizable: true, align: "center"} ,
			{ name: "workplaceCode", width: "80", resizable: true, align: "center"} ,
			{ name: "customerName", width: "120", resizable: true, align: "center", editable : true } ,
			{ name: "customerType", width: "80", resizable: true, align: "center", editable : true } ,
			{ name: "customerCeo", width: "80", resizable: true, align: "center", editable : true } ,
			{ name: "businessLicenseNumber", width: "120", resizable: true, align: "center" , editable : true } ,
			{ name: "socialSecurityNumber", width: "150", resizable: true, align: "center" , editable : true } ,
			{ name: "customerBusinessConditions", width: "100", resizable: true, align: "center" , editable : true } ,
			{ name: "customerBusinessItems", width: "100", resizable: true, align: "center" , editable : true } ,
			{ name: "customerZipCode", width: "100", resizable: true, align: "center" } ,
			{ name: "customerBasicAddress", width: "300", resizable: true, align: "center" } ,
			{ name: "customerDetailAddress", width: "200", resizable: true, align: "center" , editable : true } ,
			{ name: "customerTelNumber", width: "120", resizable: true, align: "center" , editable : true } ,
			{ name: "customerFaxNumber", width: "120", resizable: true, align: "center" , editable : true } ,
			{ name: "customerNote", width: "120", resizable: true, align: "center" , editable : true } ,		
			{ name: "status", width: "80", resizable: true, align: "center" } ,
			{ name: "beforeStatus", width: "10", resizable: true, align: "center" , hidden: true } ,
			{ name: "deleteStatus", width: "10", resizable: true, align: "center" , hidden: true } 

		], 
		caption : '일반 거래처 정보', 
		sortname : 'customerCode', 
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
		pager : '#customerGridPager',
		
		beforeEditCell(rowid, cellname, value, iRow, iCol){

        	if(value == null || value == "" ) {
        		previousCellValue = null;
        	} else {
        		previousCellValue = value;
        	}
		},
		
		afterSaveCell(rowid, cellname, value, iRow, iCol){
			
        	var status = $(this).getCell(rowid,"status");

        	if(  status == 'DELETE' ) {
        		
        		alertError("사용자 에러", "삭제 예정인 행이었습니다 ^^ </br> 원래 값으로 돌릴께요");
    			$(this).setCell(rowid,cellname, previousCellValue);	

        	} else if(status == 'NORMAL' ) {
        		
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
	    		
	    			case 'customerDeleteCheck' :
                    	
	        			$(this).setCell(rowid,"status", "DELETE");
	        			$(this).setCell(rowid,"beforeStatus", currentStatus);
	    				
	    				break;
	    
	    		}
	        	
	    	} else if( $target.is(":checkbox") && !$target.is(":checked") ) {  // 체크 해제시
	    		
	    		switch(chekedColumn) {
	    		
	    			case 'customerDeleteCheck' :

	    				$(this).setCell(rowid,"status", beforeStatus);
	    				break;
	    		
	    		}
	    		
	    	}
	    	
		},
		
		onSelectRow: function(rowid) {   
	
			if( lastSelected_customerGrid_Id != rowid ){
				lastSelected_customerGrid_Id = rowid;
				lastSelected_customerGrid_RowValue = $(this).jqGrid('getRowData', rowid);
			}
			
		},
		
		onCellSelect : function(rowid, iCol, previousCellValue, e) {

			if( lastSelected_customerGrid_Id != rowid ){
				lastSelected_customerGrid_Id = rowid;
				lastSelected_customerGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
		
			var status = $(this).getCell(rowid,"status");
			
			if( status == "NORMAL" ||  status == "UPDATE" ){

                if( iCol == 11 || iCol == 12 ) {  // 거래처 우편번호, 거래처 기본주소 cell 클릭
                	
                	showAddressDialog(this, 'customerGrid', rowid, iCol);
                		
                }

            } else if( status == "INSERT" ){

                if( iCol == 3 ) {  // 사업장코드 cell 클릭
                	
                	showCodeDialog(this ,rowid , iCol , "CO-02","사업장 검색");
                		
                }

            }
		}
	});   // 일반거래처 정보 그리드 끝
	
	// 일반거래처 정보 그리드 페이저
	$('#customerGrid').navGrid("#customerGridPager", {
		add : false,
		del : false,
		edit : false,
		search : true,
		refresh : true,
		view: true
	});
	
	
	// 금융거래처 그리드 시작
	$('#financialAccountGrid').jqGrid({ 
		mtype : 'POST', 
		datatype : 'local',
		colNames : [ "삭제", "금융거래처 코드", "사업장코드", "금융거래처명" , "금융거래처타입" , "계좌번호" , "계좌개설점" , "카드번호" , "카드구분" ,
			"카드회원명" , "카드가맹점번호" , "사업자등록번호" , "금융기관코드" , "금융기관명" , "비고" , "status", "beforeStatus" , "deleteStatus" ] ,
			colModel : [ 		
			{ name: "financialAccountDeleteCheck", width: "40", resizable: true, align: "center" ,
				formatter : function (cellvalue, options, rowObj) {
					
					var chk = "<input type='checkbox' name='financialAccountDeleteCheck' value=" +
		     		JSON.stringify(options.rowId) + " />";			
				     
					return chk;
					
				}
			},
			{ name: "accountAssociatesCode", width: "100", resizable: true, align: "center" } ,
			{ name: "workplaceCode", width: "80", resizable: true, align: "center" } ,
			{ name: "accountAssociatesName", width: "160", resizable: true, align: "center", editable : true } ,
			{ name: "accountAssociatesType", width: "100", resizable: true, align: "center", editable : true } ,
			{ name: "accountNumber", width: "160", resizable: true, align: "center", editable : true } ,
			{ name: "accountOpenPlace", width: "120", resizable: true, align: "center", editable : true } ,
			{ name: "cardNumber", width: "160", resizable: true, align: "center", editable : true } ,
			{ name: "cardType", width: "80", resizable: true, align: "center", editable : true } ,
			{ name: "cardMemberName", width: "120", resizable: true, align: "center", editable : true } ,
			{ name: "cardOpenPlace", width: "120", resizable: true, align: "center", editable : true } ,
			{ name: "businessLicenseNumber", width: "120", resizable: true, align: "center" , editable : true } ,
			{ name: "financialInstituteCode", width: "120", resizable: true, align: "center" , editable : true } ,
			{ name: "financialInstituteName", width: "120", resizable: true, align: "center" , editable : true } ,
			{ name: "financialInstituteNote", width: "120", resizable: true, align: "center" , editable : true } ,
			{ name: "status", width: "80", resizable: true, align: "center" } ,
			{ name: "beforeStatus", width: "10", resizable: true, align: "center" , hidden: true } ,
			{ name: "deleteStatus", width: "10", resizable: true, align: "center" , hidden: true } 

		], 
		caption : '금융 거래처 정보', 
		sortname : 'acountAssociatesCode', 
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
		pager : '#financialAccountGridPager',
		
		beforeEditCell(rowid, cellname, value, iRow, iCol){

        	if(value == null || value == "" ) {
        		previousCellValue = null;
        	} else {
        		previousCellValue = value;
        	}
		},
		
		afterSaveCell(rowid, cellname, value, iRow, iCol){
			
        	var status = $(this).getCell(rowid,"status");

        	if(  status == 'DELETE' ) {
        		
        		alertError("사용자 에러", "삭제 예정인 행이었습니다 ^^ </br> 원래 값으로 돌릴께요");
    			$(this).setCell(rowid,cellname, previousCellValue);	

        	} else if(status == 'NORMAL' ) {
        		
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
	    		
	    			case 'financialAccountDeleteCheck' :
                    	
	        			$(this).setCell(rowid,"status", "DELETE");
	        			$(this).setCell(rowid,"beforeStatus", currentStatus);
	    				
	    				break;
	    
	    		}
	        	
	    	} else if( $target.is(":checkbox") && !$target.is(":checked") ) {  // 체크 해제시
	    		
	    		switch(chekedColumn) {
	    		
	    			case 'financialAccountDeleteCheck' :

	    				$(this).setCell(rowid,"status", beforeStatus);
	    				break;
	    		
	    		}
	    		
	    	}
	    	
		},
		
		onSelectRow: function(rowid) {   
	
			if( lastSelected_financialAccountGrid_Id != rowid ){
				lastSelected_financialAccountGrid_Id = rowid;
				lastSelected_financialAccountGrid_RowValue = $(this).jqGrid('getRowData', rowid);
			}
			
		},
		
		onCellSelect : function(rowid, iCol, previousCellValue, e) {

			if( lastSelected_financialAccountGrid_Id != rowid ){
				lastSelected_financialAccountGrid_Id = rowid;
				lastSelected_financialAccountGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
			}
		
			var status = $(this).getCell(rowid,"status");
			
			if( status == "INSERT" ){

                if( iCol == 3 ) {  // 사업장코드cell 클릭
                	
                	showCodeDialog(this ,rowid , iCol , "CO-02","사업장 검색");
                		
                }

            }
		}
	});   // 금융거래처 정보 그리드 끝
	
	// 금융거래처 정보 그리드 페이저
	$('#financialAccountGrid').navGrid("#financialAccountGridPager", {
		add : false,
		del : false,
		edit : false,
		search : true,
		refresh : true,
		view: true
	});

}

function initEvent() {
	
	$('#searchDetailCodeName1, #searchDetailCodeName2 ').on("click" , function() { 
		
    	showCodeDialog(null ,null , null , "CO-02","사업장 검색");
		
	});
	
	$('#customerInsertButton').on("click" , function() {
		
		var grid = $('#customerGrid');
		
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
				{ "customerCode":"저장시 지정됨", "status":"INSERT" , "deleteStatus" : "LOCAL 삭제" } );

	});
	
	
	

	
	
	

	

	
	
}







function showCodeDialog(grid, rowid, iCol, divisionCodeNo, title) {

	$("#codeDialog").dialog({
		title : '코드 검색',
		width : 440,
		height : 450,
		modal : true
	// 폼 외부 클릭 못하게
	});

	$.jgrid.gridUnload("#codeGrid");

	$("#codeGrid").jqGrid({
		method:"GET",
		url : "${pageContext.request.contextPath}/compinfo/codedetail2/list",
		datatype : "json",
		jsonReader : {
			root : "detailCodeList"
		},
		postData : {
			method : "findDetailCodeList",
			divisionCode : divisionCodeNo
		},
		colNames : [ '상세코드번호', '상세코드이름', '사용여부' ],
		colModel : [ 
			{ name : 'detailCode', width : 80, align : "center", editable : false}, 
			{ name : 'detailCodeName', width : 120, align : "center", editable : false }, 
			{ name : 'codeUseCheck', width : 70, align : "center", editable : false} 
		],
		width : 410,
		height : 300,
		caption : title,
		align : "center",
		viewrecords : true,
		rownumbers : true,
		onSelectRow : function(id) {

			var detailCode = $("#codeGrid").getCell(id, 1);
			var detailName = $("#codeGrid").getCell(id, 2);
			var codeUseCheck = $("#codeGrid").getCell(id, 3);

			if (codeUseCheck != 'n' && codeUseCheck != 'N') {

				if (grid != null) {

					$(grid).setCell(rowid, iCol, detailCode);
					

				} else {

					$('#searchDetailCodeName1').val(detailName);
					$('#searchDetailCode1').val(detailCode);

					$('#searchDetailCodeName2').val(detailName);
					$('#searchDetailCode2').val(detailCode);
					
				}

				$("#codeDialog").dialog("close");

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
    	<li><a href="#tabs-1">일반 거래처</a></li>
    	<li><a href="#tabs-2">금융 거래처</a></li>
    	
  </ul>


	<div id="tabs-1">
		<fieldset style="display: inline;">
			<legend>일반거래처 검색 조건</legend>
			<select name="searchCondition1" id="searchConditionBox1">
				<option value="ALL">전체</option>
				<option value="WORKPLACE">사업장</option>
			</select> 
			
			<input type="text" id="searchDetailCodeName1" /> 
			<input type="button" value="일반거래처 조회" id="customerListSearchButton" /> 
			<input type="hidden" id="searchDetailCode1" />

		</fieldset>

		<fieldset style="display: inline;">
		    <legend>일반거래처 정보 관리</legend>
			 	<input type="button" value="새로운 일반거래처 정보 추가" id="customerInsertButton" />
  				<input type="button" value="일괄저장" id="batchSaveButton1" />
  			
	 	</fieldset>
	
	<table id="customerGrid" ></table>
	<div id="customerGridPager"></div>
	
	</div>

	<div id="tabs-2">
		<fieldset style="display: inline;">
			<legend>금융거래처 검색 조건</legend>
			<select name="searchCondition2" id="searchConditionBox2">
				<option value="ALL">전체</option>
				<option value="WORKPLACE">사업장</option>
			</select> 
			
			<input type="text" id="searchDetailCodeName2" /> 
			<input type="button" value="금융거래처 조회" id="financialAccountListSearchButton" /> 
			<input type="hidden" id="searchDetailCode2" />

		</fieldset>

		<fieldset style="display: inline;">
		    <legend>금융거래처 정보 관리</legend>
			 	<input type="button" value="새로운 금융거래처 정보 추가" id="financialAccountInsertButton" />
  				<input type="button" value="일괄저장" id="batchSaveButton2" />
  			
	 	</fieldset>
	
	<table id="financialAccountGrid" ></table>
	<div id="financialAccountGridPager"></div>
	
	</div>

</div>


<div id="codeDialog">
	<table id="codeGrid"></table>
</div>

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