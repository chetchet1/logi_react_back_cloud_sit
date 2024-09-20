<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사원 조회</title>
<style>
.empBasicInfoFieldset {
    color: #FFFFFF;
	display: inline;
	width: 90px;
	margin-bottom: 15px;
	transition: 5s;
	outline: none;
	height: 30px;
	font-size: 15px;
	text-align: center;
}

input[disabled], input[disabled]:hover { 
	background-color: #F2F2F2; ; 
	border:none; 
}

.l1 {
	color: #FFFFFF;
}
legend {
	color: #FFFFFF;
#searchDetailCodeName {
	display: inline;
	width: 135px;
	transition: 0.6s;
	outline: none;
	height: 30px;
	font-size: 12x;
	text-align: center;
}

#userIdInputBox {
	display: inline;
	width: 150px;
	transition: 0.6s;
	outline: none;
	height: 30px;
	font-size: 20px;
	text-align : center;
}

#tabs{
	font-size:15px;
}

#tabs table{
	font-size:11px;
}


#tabs .ui-jqgrid .ui-widget-header {
	height: 25px;
	font-size: 1.1em;
}

.ui-datepicker {
	z-index: 9999 !important;
}

.ui-dialog {
	z-index: 9999 !important;
	font-size: 12px;
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

#error-dialog {
	z-index: 10002 !important;
	display: none;
	font-size: 1.1em;
	color: black;
}

</style>
<script>
	var lastSelected_empListGrid_Id; // 가장 나중에 선택한 사원 목록 grid 의 행 id 
	var lastSelected_empListGrid_RowValue; // 가장 나중에 선택한 사원 목록 grid 의 행 값 

	var lastSelected_empDetailInfoGrid_Id; // 가장 나중에 선택한 사원 세부정보 grid 의 행 id 
	var lastSelected_empDetailInfoGrid_RowValue; // 가장 나중에 선택한 사원 세부정보 grid 의 행 값 
	
	var lastSelected_empSecretInfoGrid_Id; // 가장 나중에 선택한 사원 기밀정보 grid 의 행 id 
	var lastSelected_empSecretInfoGrid_RowValue; // 가장 나중에 선택한 사원 기밀정보 grid 의 행 값 

	var gridRowJson;  // 모든 그리드의 통합 Json Data => 배열 형식 : [ { ... } , { ... } , { ... } , ... ]
	
	var previousCellValue; // 수정 가능한 셀에서 수정 전의 셀 값 
	var searchConditionValue; // 사원 검색 조건 => "ALL" : 전체 , "WORKPLACE" : 사업장 , 
												//"DEPT" : 부서, "RETIREMENT" : 퇴직
	var resultList = []; // 최종적으로 컨트롤러로 보내는 JS 객체 배열 

	var checkUserIdDuplicationStatus;  // id 중복체크 여부	
	
	var chkcell = { cellId : undefined, chkval : undefined }; // addressGrid 에서 cnt 컬럼의 cell rowspan 중복 체크

	
	$(document).ready(function() {

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
		
			
		$('.empBasicInfoFieldset').attr('disabled' , true );
		
		searchConditionValue = 'ALL'; // 최초 페이지 로딩시 전체 조회가 가능하도록 설정

		$("input[type=button], input[type=submit]").button(); // jqueryUI Button 위젯 적용
		$( "input[type=radio]" ).checkboxradio();   // jqueryUI Checkboxradio 위젯 적용

		$("#searchConditionBox").selectmenu({

			width : 120,

			change : function(event, data) {

				searchConditionValue = data.item.value;

				switch (searchConditionValue) {

				case 'ALL':

					$('#searchDetailCodeName').hide();

					break;

				case 'WORKPLACE':

					$('#searchDetailCodeName').val('사업장 조회');

					$('#searchDetailCodeName').show();

					break;

				case 'DEPT':

					$('#searchDetailCodeName').val('부서 조회');

					$('#searchDetailCodeName').show();

					break;

				case 'RETIREMENT':

					$('#searchDetailCodeName').hide();

					break;

				}

				$('#empListGrid').jqGrid('clearGridData');
				$('#empDetailInfoGrid').jqGrid('clearGridData');
				$('#empSecretInfoGrid').jqGrid('clearGridData');

				lastSelected_empListGrid_Id = ""; // 초기화
				lastSelected_empListGrid_RowValue = "";  // 초기화 
				
				
			}
		});


		$( "#tabs" ).tabs({
			//event: "mouseover" ,
		    collapsible: true
		      
		});
		
		$('#searchDetailCodeName').hide();
		$('#checkUserIdDialog').hide();
		$('#addressDialog').hide();

		initGrid();
		initEvent();

	});

	function initGrid() {

		// 사원목록 그리드 시작
		$('#empListGrid').jqGrid({
			mtype : 'POST',
			datatype : 'local',
			colNames : [ "사원ID", "이름", "부서", "직급", "empCode", "companyCode", 
				"deptCode", "positionCode", "userOrNot", "image" ],
			colModel : [ 
				{ name : "userId", width : "70", resizable : true, align : "center" ,
					
					formatter : function (cellvalue, options, rowObj) {
						
						if( rowObj.userId == '' || rowObj.userId == null ) {
							
							return '계정정지';
							
						} else {
							
							return rowObj.userId;
							
						}					 	
					}
					
				}, 
				{ name : "empName", width : "70", resizable : true, align : "center" }, 
				{ name : "deptName", width : "70", resizable : true, align : "center" }, 
				{ name : "positionName", width : "70", resizable : true, align : "center" }, 
				{ name : "empCode", width : "50", resizable : true, align : "center", hidden : true }, 
				{ name : "companyCode", width : "50", resizable : true, align : "center", hidden : true }, 
				{ name : "deptCode", width : "50", resizable : true, align : "center", hidden : true }, 
				{ name : "positionCode", width : "50", resizable : true, align : "center", hidden : true }, 
				{ name : "userOrNot", width : "50", resizable : true, align : "center", hidden : true }, 
				{ name : "image", width : "50", resizable : true, align : "center", hidden : true }

			],
			caption : '사원 목록',
			sortname : 'positionCode',
			multiselect : false,
			multiboxonly : false,
			viewrecords : false,
			rownumWidth : 30,
			height : 285,
			width : 415,
			autowidth : false,
			shrinkToFit : false,
			cellEdit : false,
			rowNum : 50,
			scrollerbar : true,
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
			pager : '#empListGridPager',

			onSelectRow : function(rowid) {

				if (lastSelected_empListGrid_Id != rowid) {
					
					lastSelected_empListGrid_Id = rowid;
					lastSelected_empListGrid_RowValue = $(this).jqGrid('getRowData', rowid);

				}
				
				showEmpBasicInfo();
				showEmpDetailGrid();
				showEmpSecretGrid();

				var imagePath = "${pageContext.request.contextPath}" + lastSelected_empListGrid_RowValue.image;
						
				$('#empPhoto').attr('src', imagePath);
				
			}
		}); // 사원 목록 그리드 끝

		// 사원 목록 그리드 페이저
		$('#empListGrid').navGrid("#empListGridPager", {
			add : false,
			del : false,
			edit : false,
			search : true,
			refresh : true,
			view : true
		});


		// 사원 세부정보 그리드 시작
		$('#empDetailInfoGrid').jqGrid({ 
			mtype : 'POST', 
			datatype : 'local',
			colNames : [ "순번", "변경내역", "변경일자", "사업장코드", "부서코드", "직급코드",
				"사용자ID", "전화번호", "email", "우편번호", "기본주소", "상세주소", 
				"최종학력", "새로운 사진 업로드", "image" ,"status" , "companyCode", "empCode"], 
			colModel : [
				{ name: "seq", width: "50", resizable: true, align: "center"} ,
				{ name: "updateHistory", width: "70", resizable: true, align: "center", editable : true } ,
				{ name: "updateDate", width: "70", resizable: true, align: "center", editable: true,
//					  formatter: 'date',   => 주석 처리 : 여기 지정되면 사용자가 값을 미입력시 걸러주지 못함
//					  formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' },  
					  edittype: 'text', 
			          editoptions: { size: 12, maxlengh: 12, 
							dataInit: function (element) { 
								$(element).datepicker({ 
									changeMonth: true, 
									numberOfMonths: 1, 
									onClose: function(dateText, datepicker) {
										$('#empDetailInfoGrid').editCell(lastSelected_empDetailInfoGrid_Id, 2, false); 
									}
			                  })}
			          }, 
			          editrules: { date: true } 
				} ,
				{ name: "workplaceCode", width: "70", resizable: true, align: "center" }, 	
				{ name: "deptCode", width: "70", resizable: true, align: "center" },
				{ name: "positionCode", width: "70", resizable: true, align: "center" },
				{ name: "userId", width: "70", resizable: true, align: "center" },
				{ name: "phoneNumber", width: "70", resizable: true, align: "center", editable : true },
				{ name: "email", width: "70", resizable: true, align: "center", editable : true },
				{ name: "zipCode", width: "70", resizable: true, align: "center" },
				{ name: "basicAddress", width: "70", resizable: true, align: "center" },
				{ name: "detailAddress", width: "70", resizable: true, align: "center" },
				{ name: "levelOfEducation", width: "70", resizable: true, align: "center", editable : true },
				{ name: "imageUpload", width: "160", resizable: true, align: "center" ,
					
					formatter : function (cellvalue, options, rowObj) {
						
						if( rowObj.status == 'INSERT' ) {
							
							var str = 
								"<form name='imgFileUploadForm' id='imgFileUploadForm' method='POST' enctype='multipart/form-data'>"
						    	+ "<input type='file' name='uploadImgFile' id='uploadImgFile'>"
								+ "</form>";
							
							return str;
							
						} else {
							
							return '';
							
						}					 	
					}

				},
				{ name: "image", width: "70", resizable: true, align: "center" , hidden: true },
				{ name: "status", width: "80", resizable: true, align: "center" },
				{ name: "companyCode", width: "80", resizable: true, align: "center", hidden: true },
				{ name: "empCode", width: "80", resizable: true, align: "center" , hidden: true }

			], 
			sortname : 'seq', 
			multiselect : false, 
			multiboxonly : false,
			viewrecords : false,  
			height : 100, 
			width : 680,
			autowidth : false, 
			shrinkToFit : false, 
			cellEdit : true,
			rowNum : 100,  
			scrollerbar: true, 
			//rowList : [ 10, 20, 30 ],
			viewrecords : true, 
			editurl : 'clientArray', 
			cellsubmit : 'clientArray',
			autoencode : true, 
			resizable : true,
			loadtext : '로딩중...', 
			emptyrecords : '데이터가 없습니다.', 
			cache : false, 
			pager : '#empDetailInfoGridPager',
			beforeEditCell(rowid, cellname, value, iRow, iCol){

				if( lastSelected_empDetailInfoGrid_Id != rowid ){
					lastSelected_empDetailInfoGrid_Id = rowid;
					lastSelected_empDetailInfoGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
				}
				
	        	if(value == null || value == "" ) {
	        		previousCellValue = " ";	
	        	} else {
	        		previousCellValue = value;
	        	}
			}, 


			afterSaveCell(rowid, cellname, value, iRow, iCol){

	        	var status = $(this).getCell(rowid,"status");
	        	
	        	if(status == 'NORMAL') {
	        	
	        		alertError("사용자 에러", "기존 정보는 수정할 수 없습니다 ^^ </br> 원래 값으로 돌릴께요");
	    			$(this).setCell(rowid,cellname, previousCellValue);	

	        	} 
	        	
			},
			
			
			onSelectRow: function(rowid) {   
		
				if( lastSelected_empDetailInfoGrid_Id != rowid ){
					lastSelected_empDetailInfoGrid_Id = rowid;
					lastSelected_empDetailInfoGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
				}
				
			},
			
			onCellSelect : function(rowid, iCol, previousCellValue, e) {
				
				if( lastSelected_empDetailInfoGrid_Id != rowid ){
					lastSelected_empDetailInfoGrid_Id = rowid;
					lastSelected_empDetailInfoGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
				}

				var status = $(this).getCell(rowid,"status");
							
				if(status == "INSERT" ){

	                if(iCol == 3) {  // 사업장 cell 클릭
	                	
	                	showCodeDialog(this ,rowid , iCol , "CO-02","사업장 검색");
	                
	                } else if (iCol == 4) {  // 부서 cell 클릭
	                	
	                	showCodeDialog(this ,rowid , iCol , "CO-03","부서 검색");

	                } else if( iCol == 5 ) {  // 직급 cell 클릭
	                	
	                	showCodeDialog(this ,rowid , iCol , "HR-01","직급 검색");
	                	
	                } else if( iCol == 6 ) {  // 사용자 ID cell 클릭
	                	
	                	checkUserIdDuplication(this, rowid, iCol);

	                } else if( iCol == 9 || iCol == 10 ) {  // 우편번호, 기본주서 cell 클릭
	                	
	                	showAddressDialog(this, rowid, iCol);

	                } 
	            } 
			}
		}); // 사원 세부정보 그리드 끝
		
		// 사원 세부정보 그리드 페이저
		$('#empDetailInfoGrid').navGrid("#empDetailInfoGridPager", {
			add : false,
			del : false,
			edit : false,
			search : true,
			refresh : true,
			view : true
		});
		
		
		// 사원 기밀정보 그리드 시작
		$('#empSecretInfoGrid').jqGrid({ 
			mtype : 'POST', 
			datatype : 'local',
			colNames : [ "순번", "비밀번호", "status", "companyCode" , "empCode"], 
			colModel : [ 		
				{ name: "seq", width: "50", resizable: true, align: "center"} ,
				{ name: "userPassword", width: "70", resizable: true, align: "center" , editable : true } ,
				{ name: "status", width: "80", resizable: true, align: "center" } ,
				{ name: "companyCode", width: "80", resizable: true, align: "center", hidden : true } ,
				{ name: "empCode", width: "80", resizable: true, align: "center", hidden : true }
				
			], 
			sortname : 'seq', 
			multiselect : false, 
			multiboxonly : false,
			viewrecords : false,  
			height : 100, 
			width : 600,
			autowidth : false, 
			shrinkToFit : false, 
			cellEdit : true,
			rowNum : 50,  
			scrollerbar: true, 
			//rowList : [ 10, 20, 30 ],
			viewrecords : true, 
			editurl : 'clientArray', 
			cellsubmit : 'clientArray',
			autoencode : true, 
			resizable : true,
			loadtext : '로딩중...', 
			emptyrecords : '데이터가 없습니다.', 
			cache : false, 
			pager : '#empSecretInfoGridPager',

			beforeEditCell(rowid, cellname, value, iRow, iCol){

	        	if(value == null || value == "" ) {
	        		previousCellValue = null;	
	        	} else {
	        		previousCellValue = value;
	        	}
	        	
			},

			afterSaveCell(rowid, cellname, value, iRow, iCol){

				var secretList = $(this).getRowData(); 
				var lastSeq = secretList.length;
				var lastStatus = $(this).getRowData(lastSeq).status;
				
				var duplicated = false;
				
				if( lastStatus == 'NORMAL' ) {
					
	        		alertError("사용자 에러", "기존 데이터는 수정할 수 없습니다. ^^ </br> 원래 값으로 돌릴께요");
	    			$(this).setCell(rowid,cellname, previousCellValue);
	    			return;
	    			
				} else if ( lastStatus == 'INSERT' ) {

					// 기존 비밀번호와 중복되는지 검사하는 반복문
					$( secretList ).each ( function(index, obj) {

						// obj.seq != lastSeq => 마지막 행에 사용자가 입력한 비밀번호는 중복 검사에서 제외
						if(obj.status == 'NORMAL' && obj.userPassword == value && obj.seq != lastSeq ) {
							
							duplicated = true;
						
						}					
						
					});
				
					if(duplicated == true) {
						alertError("사용자 에러" , "기존에 사용한 비밀번호는 등록할 수 없습니다");
						$(this).setCell(rowid, iCol, previousCellValue);
						return;
						
					}
				}
			},

			onCellSelect : function(rowid, iCol, previousCellValue, e) {
				
				if( lastSelected_empSecretInfoGrid_Id != rowid ){
					lastSelected_empSecretInfoGrid_Id = rowid;
					lastSelected_empSecretInfoGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
				}

				var status = $(this).getCell(rowid,"status");
			
				if(status == "INSERT" ){

	                if(iCol == 3 || iCol == 4) {  // 품목코드, 품목명 cell 클릭
	                	
	                	showCodeDialog(this ,rowid , iCol , "IT-_I","완제품 및 반제품 검색");
	                
	                } else if (iCol == 5) {  // 단위 cell 클릭
	                	
	                	showCodeDialog(this ,rowid , iCol , "UT","단위 검색");

	                } else if( iCol == 7 || iCol == 8 || iCol == 9 ) {  
	                	
	                	showInputDialog(this ,rowid);
	                	
	                } 

	            } 
			}
		}); // 사원 기밀정보 그리드 끝
		 
		// 사원 기밀정보 그리드 페이저
		$('#empSecretInfoGrid').navGrid("#empSecretInfoGridPager", {
			add : false,
			del : false,
			edit : false,
			search : true,
			refresh : true,
			view : true
		});

	}

	function initEvent() {

		$('#empListSearchButton').on("click", function() {

			showEmpListGrid();
			showEmpBasicInfo();
			showEmpDetailGrid();
			showEmpSecretGrid()
			
		});

		$('#searchDetailCodeName').on("click", function() {

			var searchCode, title;

			switch (searchConditionValue) {

			case 'WORKPLACE':

				searchCode = 'CO-02';

				title = "사업장 검색";

				break;

			case 'DEPT':

				searchCode = 'CO-03';

				title = "부서 검색";

				break;

			}

			showCodeDialog(null, null, null, searchCode, title);

		});

		$('#insertNewEmpDetailInfoButton').on("click", function() { 
			
			var detailList = $('#empDetailInfoGrid').getRowData(); 
			var edited = false;
			
			$(detailList).each ( function() { 
				
				if(this.status == 'INSERT') {
					
					edited = true;
				}
				
			});
		
			if(edited == true) {
				alertError("사용자 에러" , "작업 중인 세부정보를 먼저 저장하세요");
				return;
				
			}
			
			// 가장 최근의 사원 세부 정보
			var addRowValue = $('#empDetailInfoGrid').getRowData( detailList.length );
			
			addRowValue.status = 'INSERT';
			addRowValue.updateHistory = '';
			addRowValue.updateDate = '';
			addRowValue.seq = detailList.length + 1;
			
			$('#empDetailInfoGrid').addRowData ( detailList.length + 1 , addRowValue );
				
		});

		
		
		$('#insertNewEmpSecretInfoButton').on("click", function() { 
			
			var secretList = $('#empSecretInfoGrid').getRowData(); 
			var edited = false;
			
			$(secretList).each ( function() { 
				
				if(this.status == 'INSERT') {
					
					edited = true;
				}
				
			});
		
			if(edited == true) {
				alertError("사용자 에러" , "작업 중인 기밀정보를 먼저 저장하세요");
				return;
				
			}
			
			
			if( lastSelected_empListGrid_RowValue.userOrNot == 'N' ) {
				alertError("사용자 에러" , "계정 정지중인 사원입니다. ");
				return;

			}
			

			$('#empSecretInfoGrid').addRowData ( 
					secretList.length + 1 , 
				{ companyCode : lastSelected_empListGrid_RowValue.companyCode ,
					empCode : lastSelected_empListGrid_RowValue.empCode ,
					seq : secretList.length + 1 , status : "INSERT" }
			);

		
		});
		
		
		$('#checkUserIdDuplicationButton').on("click", function() { 
			
			checkUserIdDuplicationStatus = false;
			
			var newUserIdValue = $('#userIdInputBox').val().trim();
			var duplicated;
			
			if( newUserIdValue == ''  ) {
				
				alertError("사용자 에러" , "검사할 ID 를 입력하세요");
				return;
				
			}
			
			// ajax 시작
			$.ajax({ 
				type : 'GET',
				url : '${pageContext.request.contextPath}/hr/emp/userid-duplication' ,
				data : {
					method : 'checkUserIdDuplication' ,
					companyCode : '${sessionScope.companyCode}',
					newUseId : newUserIdValue
				},
				dataType : 'json', 
				cache : false, 
				success : function(dataSet) { 
					console.log(dataSet);
					
					duplicated = dataSet.result;
					
					if( duplicated == true ) {
						
						alertError("ㅜㅜ" , "중복된 ID 입니다"); 
					
						checkUserIdDuplicationStatus = false;
						
					} else if( duplicated == false ) {
						
						alertError("^^" , "사용 가능한 ID 입니다");
						
						checkUserIdDuplicationStatus = true;
						
					}
					
			}});  // ajax 끝
		});
		
		
		
		$('#batchEmpDetailSaveButton').on("click", function() {
					
			// 사원세부정보 그리드의 전체 행 배열의 원소 개수 = 마지막 행 rowId
			var lastRowId =  $('#empDetailInfoGrid').jqGrid('getDataIDs').length;  

			// 사원세부정보 그리드의 마지막 행 값
			var newEmpDetailInfoValue = $('#empDetailInfoGrid').getRowData(lastRowId);
			
			// 사용자 유효성 검사
			if(newEmpDetailInfoValue.status == 'NORMAL') {
				
				alertError("사용자 에러" , "새로운 세부정보를 먼저 추가해 주세요");
				return;
				
			} else if(newEmpDetailInfoValue.updateHistory == ''  ) {
				
				alertError("사용자 에러" , "변경 내역을 입력하세요");
				return;
				
			} else if(newEmpDetailInfoValue.updateDate == ''  ) {
				
				alertError("사용자 에러" , "변경 일자를 입력하세요");
				return;
				
			}
			
			confirmMsg = "새로운 사원 세부정보를 추가합니다 \r\n 계속하시겠습니까?";
			
			var confirmStatus = confirm(confirmMsg);

			if( confirmStatus == true ) {
				
				var imgUploadUrl;
				
				if( $('#uploadImgFile').val() != '' ) {

					var form = $('#imgFileUploadForm')[0];
				  	var formData = new FormData(form);
				  	
					$.ajax({
						method:"POST",
						url: '${pageContext.request.contextPath}/compinfo/imgfileupload?method=imgFileUpload',
			            //enctype: 'multipart/form-data' ,
						processData: false,
						contentType: false,
						data: formData,
						type: 'POST',
						async : false,
						success: function(dataSet){
			                        
							imgUploadUrl = dataSet.ImgUrl;

						}
					});	
				}
				
				newEmpDetailInfoValue.image = imgUploadUrl;
				resultList.push(newEmpDetailInfoValue);
				
				$.ajax({ 
					type : 'POST',
					url : '${pageContext.request.contextPath}/hr/emp/batch' ,
					async :false,
					data : {
						method : 'batchListProcess', 
						tableName : 'DETAIL',
						batchList : JSON.stringify(resultList)
					},
					dataType : 'json', 
					cache : false, 
					success : function(dataSet) {

						console.log(dataSet);
						showEmpListGrid();
						
						if( $('#uploadImgFile').val() != '' ){
							
							var imagePath = "${pageContext.request.contextPath}" + imgUploadUrl;
							
							$('#empPhoto').attr('src', imagePath);
							
						}
						 
					}
				});  
				
				
			} else {
				
				alertError("^^" , "취소되었습니다");
				
			}
			
			showEmpDetailGrid();
			showEmpSecretGrid();
			
			resultList = [];  // 초기화
			
		});
		
		$('#cancleEmpAccountButton').on("click", function() { 
			
			var detailList = $('#empDetailInfoGrid').getRowData(); 
			var edited = false;
			var accountCancled = false;
			
			$(detailList).each ( function() { 
				
				if(this.status == 'INSERT') {
					
					edited = true;
					
				} else if (this.updateHistory == '계정 정지') {
					
					accountCancled = true;
					
				}
				
			});
		
			if(edited == true) {
				alertError("사용자 에러" , "작업 중인 세부정보를 먼저 저장하세요");
				return;
				
			} else if (accountCancled == true) {
				alertError("사용자 에러" , "이미 정지된 계정입니다.");
				return;
				
			}
			

			// 사원세부정보 그리드의 마지막 행 값
			var addRowValue = $('#empDetailInfoGrid').getRowData( detailList.length );
			
			var confirmMsg = '오늘 일자로 현 사원의 계정을 정지하는 새로운 데이터를 입력합니다. 계속하시겠습니까?';
			
			var confirmStatus = confirm(confirmMsg);
			
			if( confirmStatus == true ) {
				
				// 오늘 일자 문자열 생성 : '2018-01-01' 형식
				var now = new Date();
				var today = now.getFullYear() + "-" +('0' + (now.getMonth() +1 )).slice(-2) + "-" + ('0' + now.getDate()).slice(-2);

				addRowValue.status = 'INSERT';
				addRowValue.updateHistory = '계정 정지';
				addRowValue.updateDate = today;
				addRowValue.seq = detailList.length + 1;
				addRowValue.deptCode = '';
				addRowValue.positionCode = '';
				addRowValue.userId = '';
				
				
				$('#empDetailInfoGrid').addRowData ( detailList.length + 1 , addRowValue );

				alertError( '^^' , '세부 정보를 다시 한번 확인하세요. </br> 저장 버튼을 누르면 계정이 정지됩니다' );
				return;
				
			} else {
				
				alertError( '^^' , '취소되었습니다' );
				return;
				
			}
			
		});
		
		
		$('#batchEmpSecretSaveButton').on("click", function() {
			
			// 사원기밀정보 그리드의 전체 행 배열의 원소 개수 = 마지막 행 rowId
			var lastRowId =  $('#empSecretInfoGrid').jqGrid('getDataIDs').length;  

			// 사원기밀정보 그리드의 마지막 행 값
			var newEmpSecretInfoValue = $('#empSecretInfoGrid').getRowData(lastRowId);
			
			// 사용자 유효성 검사
			if(newEmpSecretInfoValue.status == 'NORMAL') {
				
				alertError("사용자 에러" , "새로운 기밀정보를 먼저 추가해 주세요");
				return;
				
			} else if(newEmpSecretInfoValue.userPassword == ''  ) {
				
				alertError("사용자 에러" , "새로운 비밀번호를 입력하세요");
				return;
				
			}
			
			confirmMsg = "새로운 사원 기밀정보를 추가합니다 \r\n 계속하시겠습니까?";
			
			var confirmStatus = confirm(confirmMsg);
			
			if( confirmStatus == true ) {

				resultList.push(newEmpSecretInfoValue);
				
				$.ajax({ 
					type : 'POST',
					url : '${pageContext.request.contextPath}/hr/emp/batch' ,
					async :false,
					data : {
						method : 'batchListProcess', 
						tableName : 'SECRET',
						batchList : JSON.stringify(resultList)
					},
					dataType : 'json', 
					cache : false, 
					success : function(dataSet) {

						console.log(dataSet);
						showEmpListGrid();
						
					}
				});  
				
				
			} else {
				
				alertError("^^" , "취소되었습니다");
				
			}
			
			showEmpSecretGrid();
			resultList = [];  // 초기화
			
		});
	
	}

	
	function showEmpListGrid() {
			
		switch(searchConditionValue) {
		
			case 'ALL' :
		
				break;
		
			case 'WORKPLACE' :
			
				if( $('#searchDetailCodeName').val() == '사업장 조회'  ) {
					
					alertError( "사용자 에러" , "사업장을 먼저 선택하세요" ) ;
					return;

				} 
				
				break;
			
			case 'DEPT' :
			
				if ( $('#searchDetailCodeName').val() == '부서 조회' ) {
					
					alertError( "사용자 에러" , "부서를 먼저 선택하세요" ) ;
					return;

				}
				
				break;

		}
		
		// ajax 시작
		$.ajax({ 
			type : 'GET',
			url : '${pageContext.request.contextPath}/hr/emp/alllist' ,
			data : {
				method : 'searchAllEmpList' ,
				searchCondition : searchConditionValue ,
				companyCode : "${sessionScope.companyCode}",
				workplaceCode : 
					( ( searchConditionValue == 'WORKPLACE' ) ? $('#searchDetailCode').val() : '' ) ,
				deptCode : 
					( ( searchConditionValue == 'DEPT' ) ? $('#searchDetailCode').val() : '' )					
			},
			dataType : 'json', 
			async : false,
			cache : false, 
			success : function(dataSet) {
				
				console.log(dataSet);
				gridRowJson = dataSet.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
				
				$('#empListGrid').jqGrid('clearGridData');

				// 사원 목록 Data 넣기
				$('#empListGrid')
					.jqGrid('setGridParam',{ datatype : 'local', data : gridRowJson })
					.trigger('reloadGrid');

		}});  // ajax 끝
		
	}

	function showEmpBasicInfo() {
		
		$( gridRowJson ).each( function( index, obj )   {  // gridRowJson 의 전체 데이터에 대해 반복문 시작

			// gridRowJson 배열 Data 중의 어떤 객체 ( obj ) 의 companyCode, empCode 가 
			// 가장 최근에 선택한 codeGrid 행의 divisionCodeNo 와 같으면
			if( obj.companyCode == lastSelected_empListGrid_RowValue.companyCode &&
					obj.empCode == lastSelected_empListGrid_RowValue.empCode) {

				$('#empCodeInputBox').val( obj.empCode );
				$('#empNameInputBox').val( obj.empName );
				$('#empEngNameInputBox').val( obj.empEngname );
				$('#socialSecurityNumberBox').val( obj.socialSecurityNumber );
				$('#hireDateInputBox').val( obj.hireDate );
				$('#retirementDateInputBox').val( obj.retirementDate );
				$('#UserOrNotInputBox').val( obj.userOrNot );
				$('#birthDateInputBox').val( obj.birthDate );
				$('#genderInputBox').val( obj.gender );
				
			} 
			
		});  // 반복문 끝
		
		
		
		
		/*
		
		// empList 그리드를 클릭할 때마다 세부정보, 기밀정보 Data 를 따로 불러오는 경우의 ajax
		
		// ajax 시작
		$.ajax({ 
			type : 'GET',
			url : '${pageContext.request.contextPath}/hr/emp/list' ,
			data : {
				method : 'searchEmpInfo' ,
				companyCode : lastSelected_empListGrid_RowValue.companyCode,
				empCode : lastSelected_empListGrid_RowValue.empCode
			},
			dataType : 'json', 
			cache : false, 
			success : function(dataSet) { 
				console.log(dataSet);
				var empDetailList = dataSet.empInfo.empDetailList; 
				var empSecretList = dataSet.empInfo.empSecretList;
				
				// 사원 상세정보 Data 넣기
				$('#empDetailInfoGrid')
					.jqGrid('setGridParam',{ datatype : 'local', data : empDetailList })
					.trigger('reloadGrid');

				// 사원 기밀정보 Data 넣기
				$('#empSecretInfoGrid')
					.jqGrid('setGridParam',{ datatype : 'local', data : empSecretList })
					.trigger('reloadGrid');

				$('#empCodeInputBox').val( dataSet.empInfo.empCode );
				$('#empNameInputBox').val( dataSet.empInfo.empName );
				$('#empEngNameInputBox').val( dataSet.empInfo.empEngname );
				$('#socialSecurityNumberBox').val( dataSet.empInfo.socialSecurityNumber );
				$('#hireDateInputBox').val( dataSet.empInfo.hireDate );
				$('#retirementDateInputBox').val( dataSet.empInfo.retirementDate );
				$('#UserOrNotInputBox').val( dataSet.empInfo.userOrNot );
				$('#birthDateInputBox').val( dataSet.empInfo.birthDate );
				$('#genderInputBox').val( dataSet.empInfo.gender );
				 
				empDetailInfoGrid_RowCount = dataSet.empInfo.empDetailList.length;
				
		}});  // ajax 끝
		
		*/
	}

	function showEmpDetailGrid() {
		
		$('#empDetailInfoGrid').jqGrid('clearGridData');

		$( gridRowJson ).each( function( index, obj )   {  // gridRowJson 의 전체 데이터에 대해 반복문 시작

			// gridRowJson 배열 Data 중의 어떤 객체 ( obj ) 의 companyCode, empCode 가 
			// 가장 최근에 선택한 codeGrid 행의 divisionCodeNo 와 같으면
			if( obj.companyCode == lastSelected_empListGrid_RowValue.companyCode &&
					obj.empCode == lastSelected_empListGrid_RowValue.empCode) {
				
				// 사원 상세정보 Data 넣기
				$('#empDetailInfoGrid')
					.jqGrid('setGridParam',{ datatype : 'local', data : obj.empDetailTOList })
					.trigger('reloadGrid');
				 				
			} 
			
		});  // 반복문 끝
		
	}
	
	function showEmpSecretGrid() {
		
		$('#empSecretInfoGrid').jqGrid('clearGridData');

		$( gridRowJson ).each( function( index, obj )   {  // gridRowJson 의 전체 데이터에 대해 반복문 시작

			// gridRowJson 배열 Data 중의 어떤 객체 ( obj ) 의 companyCode, empCode 가 
			// 가장 최근에 선택한 codeGrid 행의 divisionCodeNo 와 같으면
			if( obj.companyCode == lastSelected_empListGrid_RowValue.companyCode &&
					obj.empCode == lastSelected_empListGrid_RowValue.empCode) {
				
				// 사원 상세정보 Data 넣기
				$('#empSecretInfoGrid')
					.jqGrid('setGridParam',{ datatype : 'local', data : obj.empSecretTOList })
					.trigger('reloadGrid');
				 
			} 
			
		});  // 반복문 끝
		
	}
	
	function showCodeDialog(grid, rowid, iCol, divisionCodeNo, title) {

		$("#codeDialog").dialog({
			title : '코드 검색',
			width : 500,
			height : 500,
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
				{ name : 'detailCode', width : 100, align : "center", editable : false}, 
				{ name : 'detailCodeName', width : 100, align : "center", editable : false }, 
				{ name : 'codeUseCheck', width : 100, align : "center", editable : false} 
			],
			width : 500,
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

						$('#searchDetailCodeName').val(detailName);
						$('#searchDetailCode').val(detailCode);

					}

					$("#codeDialog").dialog("close");

				} else {
					
					alertError("사용자 에러", "사용 가능한 코드가 아닙니다");
				
				}
			}
		});

	}
	
	function checkUserIdDuplication(grid, rowid, iCol) {

		$('#userIdInputBox').val("");
		
		$("#checkUserIdDialog").dialog({
			
			title : '사용자 ID 입력',
			autoOpen : true,  
			width : 500,
			height : 170,
			modal : true,   // 폼 외부 클릭 못하게
			
			buttons : {  // 버튼 이벤트 적용
				"확인" : function() {

					if( checkUserIdDuplicationStatus == false ) {
							
						alertError("사용자 에러" , "중복된 ID 이거나 중복체크를 하지 않았습니다. </br> 기존 ID 값을 유지합니다");
						
					} else if ( checkUserIdDuplicationStatus  == true ) {
						
						$(grid).setCell(rowid, iCol, $('#userIdInputBox').val().trim() );
						checkUserIdDuplicationStatus = false;
					}
					
					$("#checkUserIdDialog").dialog("close");

				},
				
				"취소" : function() {
					$("#checkUserIdDialog").dialog("close");
				}
				
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

				$(grid).setCell(rowid, "zipCode", zipCode);
				$(grid).setCell(rowid, "basicAddress", address);
				
				$('#addressGrid').jqGrid('clearGridData');
				$("#addressDialog").dialog("close");
				
				checkRowChanged(lastSelected_empDetailInfoGrid_RowValue, grid, rowid);	
				
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

	<div style="width: 35%; display: inline-block; vertical-align: top;">
		<fieldset id="searchConditionFieldset">
			<legend>사원 검색 조건</legend>
			<select name="searchCondition" id="searchConditionBox">
				<option value="ALL">전체</option>
				<option value="WORKPLACE">사업장</option>
				<option value="DEPT">부서</option>
				<option value="RETIREMENT">퇴직</option>
			</select> 
			
			<input type="text" id="searchDetailCodeName" /> 
			<input type="button" value="사원 조회" id="empListSearchButton" /> 
			<input type="hidden" id="searchDetailCode" />

		</fieldset>

		<table id="empListGrid"></table>
		<div id="empListGridPager"></div>
	</div>

	<div style="width: 60%; display: inline-block; vertical-align: top;">

		<fieldset id="empBasicInfo">
			<legend>사원 기초정보</legend>
			
				<table>
					<tr>
						<td>
							<img src = "" id="empPhoto" width="140" height = "140">
						</td>
						<td width="10px">   </td>
						<td>
							<label for="empCodeInputBox" class="empBasicInfoFieldset">사원코드</label> 
								<input type="text" class="empBasicInfoFieldset" id="empCodeInputBox"/>
							<label for="empNameInputBox" class="empBasicInfoFieldset">사원명</label> 
								<input type="text" class="empBasicInfoFieldset" id="empNameInputBox" /> 
							<label for="empEngNameInputBox" class="empBasicInfoFieldset">사원영문명</label>
								<input type="text" class="empBasicInfoFieldset" id="empEngNameInputBox" />
							<br /> 
							<label for="socialSecurityNumberBox" class="empBasicInfoFieldset">주민등록번호</label> 
								<input type="text" class="empBasicInfoFieldset"id="socialSecurityNumberBox" />
							<label for="hireDateInputBox" class="empBasicInfoFieldset">입사일자</label> 	
								<input type="text" class="empBasicInfoFieldset" id="hireDateInputBox" /> 
							<label for="retirementDateInputBox" class="empBasicInfoFieldset">퇴직일자</label> 
								<input type="text" class="empBasicInfoFieldset" id="retirementDateInputBox" />
							<br /> 
							<label for="UserOrNotInputBox" class="empBasicInfoFieldset">사용자여부</label> 
								<input type="text" class="empBasicInfoFieldset"id="UserOrNotInputBox" /> 
							<label for="birthDateInputBox" class="empBasicInfoFieldset">생년월일</label>
									<input type="text" class="empBasicInfoFieldset"id="birthDateInputBox" />
							<label for="genderInputBox" class="empBasicInfoFieldset">성별</label> 
								<input type="text" class="empBasicInfoFieldset"id="genderInputBox" />
						</td>
					</tr>
				</table>
		</fieldset>

	<div id="tabs">
		<ul>
    		<li><a href="#tabs-1">사원세부정보</a></li>
    		<li><a href="#tabs-2" id="tab2" >사원기밀정보</a></li>	
  		</ul>
  	
		<div id="tabs-1"> 
			<input type="button" value="새로운 세부정보 입력" id="insertNewEmpDetailInfoButton" />
			<input type="button" value="저장" id="batchEmpDetailSaveButton" />
			<input type="button" value="계정 정지" id="cancleEmpAccountButton" />
			
			
			<table id = "empDetailInfoGrid"></table>
			<div id="empDetailInfoGridPager"></div>
			
		</div>

		<div id="tabs-2"> 
			<input type="button" value="새로운 비밀번호 입력" id="insertNewEmpSecretInfoButton" />
			<input type="button" value="저장" id="batchEmpSecretSaveButton" />
			
			<table id = "empSecretInfoGrid"></table>
			<div id="empSecretInfoGridPager"></div>
			
		</div>
	
	</div>

	</div>


<div id="codeDialog">
	<table id="codeGrid"></table>
</div>

<div id="checkUserIdDialog">
	<table>
		<tr>
			<td><label for="userIdInputBox" style="font-size: 20px; margin-right: 10px">새로운 사용자 ID</label></td>
			<td>
				<input type="text" id="userIdInputBox"/>&nbsp;&nbsp;
				<input type="button" value = "ID 중복 체크" id="checkUserIdDuplicationButton" style="font-size: 16px;"/>
			</td>
		</tr>
	</table>

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