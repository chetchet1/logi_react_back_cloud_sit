<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>부서 정보</title>
<script>
	
	var lastSelected_departmentGrid_Id;   // 가장 나중에 선택한 부서 grid 의 행 id 
	var lastSelected_departmentGrid_RowValue;   // 가장 나중에 선택한 부서 grid 의 행 값 
	var previousCellValue;  // 수정 가능한 셀에서 수정 전의 셀 값 
	var resultList = [];  // 최종적으로 컨트롤러로 보내는 JS 객체 배열 
	var searchConditionValue; // 부서 검색 조건 => "ALL" : 전체 , "WORKPLACE" : 사업장
	$(document).ready(function() {  
	   $("input[type=button], input[type=submit]").button();   // jqueryUI Button 위젯 적용
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
	         }
	         $('#departmentGrid').jqGrid('clearGridData');
	         lastSelected_departmentGrid_Id = ""; // 초기화
	         lastSelected_departmentGrid_RowValue = ""; // 초기화
	      }
	   });
	   $('#searchDetailCodeName').hide();
	   searchConditionValue = 'ALL'; // 최초 페이지 로딩시 전체 조회가 가능하도록 설정
	   initGrid();
	   initEvent();
	   showDepartmentGrid();
	});

	function initGrid() {
	   // 부서 그리드 시작
	   $('#departmentGrid').jqGrid({ 
	      mtype : 'POST', 
	      datatype : 'local',
	      colNames : [ "삭제", "사업장코드", "사업장명", "부서코드" , "부서명" , 
	         "부서신설일" , "부서해체일" , "status", "companyCode" , "beforeStatus" , "deleteStatus" ] ,
	      colModel : [       
	         { name: "departmentDeleteCheck", width: "40", resizable: true, align: "center" , hidden : true  ,  // 삭제 기능은 숨겨둠
	            formatter : function (cellvalue, options, rowObj) {
	               var chk = "<input type='checkbox' name='departmentDeleteCheck' value=" +
	                 JSON.stringify(options.rowId) + " />";         
	               return chk;
	            }
	         },
	         { name: "workplaceCode", width: "80", resizable: true, align: "center"} ,
	         { name: "workplaceName", width: "140", resizable: true, align: "center" , editable : true } ,
	         { name: "deptCode", width: "120", resizable: true, align: "center" , editable : true } ,
	         { name: "deptName", width: "120", resizable: true, align: "center" , editable : true } ,
	         { name: "deptStartDate", width: "100", resizable: true, align: "center", editable: true,
	//              formatter: 'date',   => 주석 처리 : 여기 지정되면 사용자가 값을 미입력시 걸러주지 못함
	//              formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' },
	              edittype: 'text', 
	                editoptions: { size: 12, maxlengh: 12, 
	                  dataInit: function (element) { 
	                     $(element).datepicker({ 
	                        changeMonth: true, 
	                        numberOfMonths: 1, 
	                        onClose: function(dateText, datepicker) {
	                           $(this).editCell( lastSelected_departmentGrid_Id, 5, false); 
	                        }
	                        })}
	                }, 
	                editrules: { date: true } 
	         } ,
	         { name: "deptEndDate", width: "100", resizable: true, align: "center", editable: true,
	//              formatter: 'date',   => 주석 처리 : 여기 지정되면 사용자가 값을 미입력시 걸러주지 못함
	//              formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' },  
	              edittype: 'text', 
	                editoptions: { size: 12, maxlengh: 12, 
	                  dataInit: function (element) { 
	                     $(element).datepicker({ 
	                        changeMonth: true, 
	                        numberOfMonths: 1, 
	                        onClose: function(dateText, datepicker) {
	                           $(this).editCell( lastSelected_departmentGrid_Id, 6 ,false); 
	                        }
	                        })}
	                }, 
	                editrules: { date: true } 
	         } ,
	         { name: "status", width: "80", resizable: true, align: "center" } ,
	         { name: "companyCode", width: "10", resizable: true, align: "center" , editable : true, hidden : true } ,
	         { name: "beforeStatus", width: "10", resizable: true, align: "center" , hidden: true } ,
	         { name: "deleteStatus", width: "10", resizable: true, align: "center" , hidden: true } 
	      ], 
	      caption : '부서 정보', 
	      sortname : 'deptCode', 
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
	      pager : '#departmentGridPager',
	      beforeEditCell(rowid, cellname, value, iRow, iCol){
	           if(value == null || value == "" ) {
	              previousCellValue = null;
	           } else {
	              previousCellValue = value;
	           }
	      },
	      afterSaveCell(rowid, cellname, value, iRow, iCol){
	           var status = $(this).getCell(rowid,"status");
	           if(  status == 'NORMAL' && iCol != 7 ) {
	              alertError("사용자 에러", "기존 부서 정보는 수정할 수 없습니다 ^^ </br> 원래 값으로 돌릴께요");
	             $(this).setCell(rowid,cellname, previousCellValue);   
	           } else if(status == 'NORMAL' && iCol == 7 ) {
	              var confirmStatus = confirm( '부서해체일 지정은 되돌릴 수 없습니다. 계속하시겠습니까?' );
	              if(confirmStatus == true ) {
	                 if( previousCellValue != value ) {
	                    $(this).setCell(rowid,"status", "UPDATE");
	                  }   
	              } else {
	                 $(this).setCell(rowid, iCol , null);
	              }
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
	                case 'departmentDeleteCheck' :
	                    $(this).setCell(rowid,"status", "DELETE");
	                    $(this).setCell(rowid,"beforeStatus", currentStatus);
	                   break;
	             }
	          } else if( $target.is(":checkbox") && !$target.is(":checked") ) {  // 체크 해제시
	             switch(chekedColumn) {
	                case 'departmentDeleteCheck' :
	                   $(this).setCell(rowid,"status", beforeStatus);
	                   break;
	             }
	          }
	      },
	      onSelectRow: function(rowid) {   
	         if( lastSelected_departmentGrid_Id != rowid ){
	            lastSelected_departmentGrid_Id = rowid;
	            lastSelected_departmentGrid_RowValue = $(this).jqGrid('getRowData', rowid);
	         }
	      },
	      onCellSelect : function(rowid, iCol, previousCellValue, e) {
	         if( lastSelected_departmentGrid_Id != rowid ){
	            lastSelected_departmentGrid_Id = rowid;
	            lastSelected_departmentGrid_RowValue = $(this).jqGrid('getRowData', rowid); 
	         }
	         var status = $(this).getCell(rowid,"status");
	         
	         if( status == "INSERT" ){
	                if( iCol == 2 || iCol == 3 ) {  // 사업장코드 , 사업장명 cell 클릭
	                   showCodeDialog(this ,rowid , iCol , "CO-02","사업장 검색");
	                }
	            }
	      }
	   });   // 부서 정보 그리드 끝
	   
	   // 부서 정보 그리드 페이저
	   $('#departmentGrid').navGrid("#departmentGridPager", {
	      add : false,
	      del : false,
	      edit : false,
	      search : true,
	      refresh : true,
	      view: true
	   });
	}

	function initEvent() {
	   $('#searchDetailCodeName').on("click" , function() { 
	       showCodeDialog(null ,null , null , "CO-02","사업장 검색");
	   });
	   
	   $('#departmentInsertButton').on("click" , function() {
	      var grid = $('#departmentGrid');
	      var newRowNum = grid.jqGrid('getDataIDs').length+1;  // 새로운 행 넘버
	      grid.addRowData(
	            newRowNum, 
	            { "deptCode":"저장시 지정됨", "companyCode" : "${sessionScope.companyCode}" ,
	               "status":"INSERT" , "deleteStatus" : "LOCAL 삭제" } );
	   });
	   
	   $('#batchSaveButton').on("click" , function() {
	      var grid = $('#departmentGrid');
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
	            } else if(rowObject.deptName == '' ) {
	               errorMsg += ( rowId + "행 : 부서명 미입력 \r" );
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
	         ( ( insertCount != 0 ) ? insertCount + "개의 부서 정보 추가 \n" : "" ) +
	         ( ( updateCount != 0 ) ? updateCount + "개의 부서 정보 수정 \n" : "" ) +
	         ( ( deleteCount != 0 ) ? deleteCount + "개의 부서 정보 삭제 \n" : ""  ) +
	         "\r위와 같이 작업합니다. 계속하시겠습니까?"
	
	      var confirmStatus = "";
	      
	      if(resultList.length != 0) {
	         confirmStatus = confirm(confirmMsg);
	      }
	      
	      if(resultList.length != 0 && confirmStatus) {
	         $.ajax({ 
	            type : 'POST',
	            url : '${pageContext.request.contextPath}/compinfo/department/batch' ,
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
	                  "< 부서 정보 작업 내역 >   <br/><br/>"
	                  + "추가된 부서 코드 : "
	                  + ( ( dataSet.result.INSERT.length != 0 ) ? dataSet.result.INSERT : "없음" ) + "</br></br>"
	                  + "수정된 부서 코드 : " 
	                  + ( ( dataSet.result.UPDATE.length != 0 ) ? dataSet.result.UPDATE : "없음" ) + "</br></br>"
	                  + "삭제된 부서 코드 :  : " 
	                  + ( ( dataSet.result.DELETE.length != 0 ) ? dataSet.result.DELETE : "없음" ) + "</br></br>"
	                  + "위와 같이 작업이 처리되었습니다";
	               alertError("성공", resultMsg);
	               showDepartmentGrid();  // 부서 그리드 새로고침
	            }
	         });  
	         
	      } else if(resultList.length != 0 && !confirmStatus) {
	         alertError("^^", "취소되었습니다");
	      } else if(resultList.length == 0) {
	         alertError("^^", "추가/수정/삭제할 부서 정보가 없습니다");
	      }
	      resultList = [];   // 초기화
	   });
	   
	   $('#deptListSearchButton').on("click" , function() { 
	      if( $('#searchDetailCodeName') == '사업장 조회' ) {
	         alertError("사용자 에러" , "사업장을 선택하세요");
	         return;
	      }
	      showDepartmentGrid();
	   });
	}
	
	function showDepartmentGrid() {
	   $('#departmentGrid').jqGrid('clearGridData');
	   $.ajax({ 
	      type : 'GET',
	      url : '${pageContext.request.contextPath}/compinfo/department/list' ,
	      async :false,
	      data : {
	         method : 'searchDepartmentList' ,
	         searchCondition : searchConditionValue ,
	         companyCode : '${sessionScope.companyCode}' ,  // 자신의 회사에 속한 사업장만 검색
	         workplaceCode : ( ( searchConditionValue == 'WORKPLACE' ) ? $('#searchDetailCode').val() : '' ) ,
	      },
	      dataType : 'json', 
	      cache : false, 
	      success : function(dataSet) {
	         console.log(dataSet);
	         var gridRowJson = dataSet.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
	         // 부서 Data 넣기
	         $('#departmentGrid')
	            .jqGrid('setGridParam',{ datatype : 'local', data : gridRowJson })
	            .trigger('reloadGrid');
	      }
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
	               $(grid).setCell(rowid, iCol+1, detailName);
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
</script>
</head>
<body>
	<fieldset style="display: inline;">
		<legend>부서 검색 조건</legend>
		<select name="searchCondition" id="searchConditionBox">
			<option value="ALL">전체</option>
			<option value="WORKPLACE">사업장</option>
		</select> 
			
		<input type="text" id="searchDetailCodeName" /> 
		<input type="button" value="부서 조회" id="deptListSearchButton" /> 
		<input type="hidden" id="searchDetailCode" />

	</fieldset>

	<fieldset style="display: inline;">
	    <legend>부서 정보 관리</legend>
		 	<input type="button" value="새로운 부서 정보 추가" id="departmentInsertButton" />
  			<input type="button" value="일괄저장" id="batchSaveButton" />
  			
 	</fieldset>

<table id="departmentGrid" ></table>
<div id="departmentGridPager"></div>

<div id="codeDialog">
	<table id="codeGrid"></table>
</div>

</body>
</html>