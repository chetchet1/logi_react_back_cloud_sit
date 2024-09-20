<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>workSite</title>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
    <script src="${pageContext.request.contextPath}/js/modal.js?v=<%=System.currentTimeMillis()%>" defer></script>
    <script src="${pageContext.request.contextPath}/js/datepicker.js" defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datepicker.css">
    <script>
      $(function () {
        $('[data-toggle="datepicker"]').datepicker({
          autoHide: true,
          zIndex: 2048,
        });
        $('#datepicker').datepicker({
          todayHiglght: true,
          autoHide: true,
          autoaShow: true,
        });
      })
    </script>
    <style>
        button {
            background-color: #506FA9;
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            border-radius: 3px;
            margin-bottom: 10px;
        }

        .ag-header-cell-label {
            justify-content: center;
        }

        .ag-cell-value {
            padding-left: 10px;
        }

        .form-control {
            display: inline;
        !important;
        }

        #orderModal {
            position: absolute !important;
            z-index: 3000;
        }

        @media (min-width: 768px) {
            .modal-xl {
                width: 90%;
                max-width: 1700px;
            }
        }
    </style>
</head>
<body>
<article class="workSite">
    <div class="workSite__Title" style="color: black">
        <h5>🏭 작업장</h5>
        <b>작업장 조회 / 제품 작업장</b><br/>
        <button id="workSiteList">조회</button>
        &nbsp;&nbsp;&nbsp;&nbsp;
       <!--  <button id="workSiteRawMaterials">원재료 검사</button> -->
        <button id="workSiteProduction">제품 제작</button>
        <button id="workSiteExamine">판매제품 검사</button>
    </div>
</article>
<article class="myGrid">
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:30vh; width:auto; text-align: center;"></div>
    </div>
</article>
<article class="workSiteLog" style="color: black">
    <div class="workSiteLog__Ttile">
        <h5>🏭 작업장로그</h5>
        <b>작업장로그 조회</b><br/>
            <input type="text" data-toggle="datepicker" id="workSiteLogDate" placeholder="YYYY-MM-DD 📅" size="15" autocomplete="off" style="text-align: center">&nbsp;&nbsp;
            <button id="workSiteLogListButton">작업로그 조회</button>
    </div>
</article>
<article class="myGrid2">
    <div align="center">
        <div id="myGrid2" class="ag-theme-balham" style="height:40vh; width:auto; text-align: center;"></div>
    </div>
</article>
<%--O WORK COMPLET MODAL--%>
<div class="modal fade" id="workSiteModal" role="dialog">
    <div class="modal-dialog modal-xl">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">
                    <h5>WORK SITE</h5>
                    <button id="complete">검사 및 제작완료</button>
                </div>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px; height: 35px">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <div id="workSiteSituationGrid" class="ag-theme-balham" style="height: 40vh;width:auto;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<script>
//그리드
  const myGrid = document.querySelector("#myGrid");
  const myGrid2 = document.querySelector("#myGrid2");
//작업장
  const workSiteListBtn = document.querySelector("#workSiteList");                  //조회버튼
  const workSiteProductionBtn = document.querySelector("#workSiteProduction");      // 제품제작
  const workSiteExamineBtn = document.querySelector("#workSiteExamine");            // 판매제품검사
  const completeBtn = document.querySelector("#complete");                           // 모으전개된 제작완료 버튼
// 작업장로그
  const workSiteLogListBtn = document.querySelector("#workSiteLogListButton");      // 작업장 로그
  const workSiteLogDate = document.querySelector("#workSiteLogDate");               // 작업장 로그일자


// 작업장 컬럼
  const workSiteColumn = [
    {
      headerName: "작업지시일련번호", field: "workOrderNo",  headerCheckboxSelection: false,
      headerCheckboxSelectionFilteredOnly: true, suppressRowClickSelection: true,
      checkboxSelection: true
    },
    {headerName: '소요량취합번호', field: 'mrpGatheringNo'},
    {headerName: '품목분류', field: 'itemClassification', },
    {headerName: '품목코드', field: 'itemCode'},
    {headerName: '품목명', field: 'itemName'},
    {headerName: '단위', field: 'unitOfMrp'},
    {headerName: '생산공정코드', field: 'productionProcessCode'},
    {headerName: '생산공정명', field: 'productionProcessName'},
    {headerName: '작업장코드', field: 'workSiteCode'},
    {headerName: '작업장명', field: 'workSiteName'},
    {headerName: '원재료검사', field: 'inspectionStatus', cellRenderer: function (params) {
        if (params.value == "Y") {
          return params.value = "🟢";
        }
        return '❌';
      },
    },
    {headerName: '제품제작', field: 'productionStatus',cellRenderer: function (params) {
        if (params.value == "Y") {
          return params.value = "🟢";
        }
        return '❌';
      },},
    {headerName: '제품검사', field: 'completionStatus',cellRenderer: function (params) {
        if (params.value == "Y") {
          return params.value = "🟢";
        }
        return '❌';
      },},
      {headerName: '작업완료여부', field: 'operationCompleted' , cellRenderer: function (params) {
          if (params.value == "Y") {
              return params.value = "🟢";
            }
            return '❌';
          },},
  ];
  let workSiteRowData = [];
  const workSiteGridOptions = {
    defaultColDef: {
      flex: 1,
      minWidth: 100,
      resizable: true,
    },
    columnDefs: workSiteColumn,
    rowSelection: 'single',
    rowData: workSiteRowData,
    defaultColDef: {editable: false, resizable : true},
    overlayNoRowsTemplate: "작업지시 리스트가 없습니다.",
    onGridReady: function(event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
      event.api.sizeColumnsToFit();
    },
    onRowSelected: function(event) { // checkbox
    },
    onGridSizeChanged: function(event) {
      event.api.sizeColumnsToFit();
    },
    getRowStyle: function(param) {
      return {'text-align': 'center'};
    },
  }
//-----------------------------------조회버튼------------------------------------//
  // 작업장 조회버튼
  workSiteListBtn.addEventListener('click', () => {  // 조회버튼
    getWorkSiteList();
  });



//-----------------------------------공통으로 쓰임 ------------------------------------//
  const getWorkSiteList = () => { //제품제작 하기전 조회버튼에서 한번 완료한뒤 변환값을 다시 부름
    workSiteGridOptions.api.setRowData([]);
    let xhr = new XMLHttpRequest();
    xhr.open('GET', '${pageContext.request.contextPath}/quality/workorder/list' +
        "?method=showWorkOrderInfoList",
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4 && xhr.status == 200) {
        let txt = xhr.responseText;
        txt = JSON.parse(txt);
        if (txt.errorCode < 0) {
          swal.fire("오류", txt.errorMsg, "error");
          return;
        }else if (txt.gridRowJson == "") {
            swal.fire("알림", "조회된 작업지시 리스트가 없습니다.", "info");
            return;
        }
        console.log(txt);
        workSiteGridOptions.api.setRowData(txt.gridRowJson);
      }
    }
  }

//-----------------------------------------------------------------------//



//-----------------------------------제품제작 버튼------------------------------------//
//모달에있는 그리드 함수호출
  let _setWorkSiteModal = (function() {
    let executed = false;
    return function() {
      if (!executed) {
        executed = true;
        setWorkSiteModal();
      }
    };
  })();

  // 제품제작에서 부른 검사 항목 알림
  let workSiteCourse;       // 검사항목
  let workOrderNo;         // 작업지시번호
  let itemClassIfication; // 품목분류
  const isCheck = () => {
    let selectedRows = workSiteGridOptions.api.getSelectedRows();
    if (selectedRows == "") {
      Swal.fire("알림", "선택한 행이 없습니다.", "info");
      return true;
    } else if (selectedRows[0].inspectionStatus == 'Y' &&
        selectedRows[0].productionStatus == 'Y' &&
        selectedRows[0].completionStatus == 'Y' ) {
      Swal.fire("알림", "모든작업이 완료되었습니다.", "info");
      return true;
    }
    workOrderNo = selectedRows[0].workOrderNo;
    itemClassIfication = selectedRows[0].itemClassification;
    return false;
  }

  // 제품제작 버튼
  workSiteProductionBtn.addEventListener('click', () => {  //   P_WORK_SITE_SITUATION 프로시저
    if (isCheck()) {
      return;
    }
    let selectedRows = workSiteGridOptions.api.getSelectedRows();
    if (selectedRows[0].completionStatus == 'Y' || selectedRows[0].productionStatus == 'Y') {
      return Swal.fire("알림", "완료된 작업입니다.", "info");
    } else if (selectedRows[0].inspectionStatus != 'Y') {
      return Swal.fire("알림", "원재료 검사가 완료되지 않았습니다.", "info");
    }
    workSiteCourse = "Production" // 검사항목 : 제품제작
    _setWorkSiteModal();  // 모달 그리드를 생성
    getWorkSiteModal(workSiteCourse, workOrderNo, itemClassIfication);
    $('#workSiteModal').modal('show');
  });





//-----------------------------------모의전개된 제작완료 버튼 , 검사 및 제작완료 버튼(공통)------------------------------------//

  // o 모의전개된 결과 작업지시
  completeBtn.addEventListener('click', () => { // 검사 및 제작완료   P_WORK_SITE_COMPLETION 프로시저
    let displayModel = workSiteSimulationGridOptions.api.getModel();
    let modalData = workSiteSimulationGridOptions.api.getRenderedNodes();   // 랜더링된 노드들을 가지고 오는 방식임
    let workProduct = modalData[0].data;
    let now = new Date();
    let today = now.getFullYear() + "-" +('0' + (now.getMonth() +1 )).slice(-2) + "-" + ('0' + (now.getDate())).slice(-2);
    console.log(modalData)
    let itemCodeList = [];
    modalData.forEach(function(rowNode, index) {
      itemCodeList.push(rowNode.data.itemCode); // 랜더링된 노드의 아이템코드를 배열에 넣는다.
    });

    let confirmMsg = "완료날짜 : "+ today +"</br>"+
        "제품 "+(workProduct.itemClassIfication == "원재료" ? "검사" : "제작") +" 할 갯수"+ modalData.length +"</br>"
        + "<b>"+workProduct.wdItem+" : "+workProduct.parentItemName+ "</b>"
    console.log(itemCodeList);
    // o 데이터 전송
    Swal.fire({
      title: '작업완료',
      html: confirmMsg,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      cancelButtonText: '취소',
      confirmButtonText: '확인',
    }).then((result) => {
      if (result.isConfirmed) {
        console.log(workProduct.workOrderNo); // 랜더링된 노드(작업중인 품목)의 작업지시번호
        console.log(workProduct.parentItemCode); // 상위 아이템코드
        console.log(itemCodeList); // 작업중인 품목들의 아이템코드
        let xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/quality/workorder/workcompletion' +
            "?method=workCompletion"
            + "&workOrderNo=" + encodeURI(workProduct.workOrderNo)
            + "&itemCode=" + encodeURI(workProduct.parentItemCode)
            + "&itemCodeList=" + encodeURI(JSON.stringify(itemCodeList)),
            true)
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send();
        xhr.onreadystatechange = () => {
          if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            console.log(txt);
            if (txt.errorCode < 0) {
              swal.fire("오류", txt.errorMsg, "error");
              return;
            }
            Swal.fire(
                '성공!',
                '작업이 완료되었습니다.',
                'success'
            )
            getWorkSiteList(); // 조회 그리드의 데이터를 다시 가지고옴 (상태정보 변경되었다)
            workSiteSimulationGridOptions.api.setRowData([]);
          }
        }
      }
    })
  });
//-----------------------------------(공통)------------------------------------//

//-----------------------------------판매제품검사 버튼------------------------------------//
  // 판매제품검사
  workSiteExamineBtn.addEventListener('click', () => {   //P_WORK_SITE_SITUATION 프로시저 호출
    if (isCheck()) { //제품제작 체크 되어있는지 확인
      return;
    }
    let selectedRows = workSiteGridOptions.api.getSelectedRows();
    if (selectedRows[0].inspectionStatus != 'Y') {
      return Swal.fire("알림", "원재료 검사가 완료되지 않았습니다", "info");
    } else if (selectedRows[0].productionStatus != 'Y') {
      return Swal.fire("알림", "제품 제작이 완료되지 않았습니다.", "info");
    }
    workSiteCourse = "SiteExamine";
    getWorkSiteModal(workSiteCourse, workOrderNo, itemClassIfication); //선택한 품목의 작업정보를 가져와서 모달 그리드에 뿌림
    _setWorkSiteModal(); // 모달 그리드 생성..
    $('#workSiteModal').modal('show');
  });    //판매제품의 있는 검사완료 중복됩니다.



//-----------------------------------작업장 로그그리드------------------------------------//
  const workSiteLogColumn = [
    {headerName: "작업지시번호", field: "workOrderNo"},
    {headerName: "품목코드", field: "itemCode", width: 100},
    {headerName: '품목명', field: "itemName",},
    {headerName: '생산공정코드', field: 'productionProcessCode',width: 150},
    {headerName: '생산공정명', field: 'productionProcessName',},
    {headerName: '상황', field: 'reaeson', width: 450},
    {headerName: '작업장명', field: 'workSiteName',},
    {headerName: '날짜', field: 'workDate',cellRenderer: function (params) {
    if (params.value == null) {
      params.value = "";
    }
    return '📅 ' + params.value;
  }},
  ];
  let workSiteLogRowData = [];
  const workSiteLogGridOptions = {
    defaultColDef: {
      flex: 1,
      minWidth: 100,
      resizable: true,
    },
    columnDefs: workSiteLogColumn,
    rowSelection: 'multiple',
    rowData: workSiteLogRowData,
    defaultColDef: {editable: false, resizable : true},
    overlayNoRowsTemplate: "조회된 작업로그 리스트가 없습니다.",
    onGridReady: function(event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
      event.api.sizeColumnsToFit();
    },
    onRowSelected: function(event) { // checkbox
    },
    onGridSizeChanged: function(event) {
      event.api.sizeColumnsToFit();
    },
    getRowStyle: function(param) {
      return {'text-align': 'center'};
    },
  }


//-----------------------------------작업장 조회버튼------------------------------------//
  workSiteLogListBtn.addEventListener('click', () => {
	    workSiteLog();
	  });
  // o get workSiteLog
  const workSiteLog = () => {
    let _workSiteLogDate = workSiteLogDate.value;
    if (_workSiteLogDate == "") {
      Swal.fire("알림", "조회할 날짜를 입력하십시오", "info");
      return;
    }
    let xhr = new XMLHttpRequest();
    xhr.open('GET', '${pageContext.request.contextPath}/quality/workorder/worksitelog' +
        "?method=workSiteLogList"
        + "&workSiteLogDate=" + _workSiteLogDate,
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4 && xhr.status == 200) {
        let txt = xhr.responseText;
        txt = JSON.parse(txt);
        if (txt.errorCode < 0) {
          swal.fire("오류", txt.errorMsg, "error");
          return;
        } else if (txt.gridRowJson == "") {
          swal.fire("알림", "조회된 작업장리스트가 없습니다.", "info");
          return;
        }
        console.log(txt);
        workSiteLogGridOptions.api.setRowData(txt.gridRowJson);
      }
    }
  }

  // 문서가 다 읽어들이면 객체이용해서 그리드를 생성해줌
  document.addEventListener('DOMContentLoaded', () => {
    new agGrid.Grid(myGrid, workSiteGridOptions);
    new agGrid.Grid(myGrid2, workSiteLogGridOptions);
  });

</script>
</body>
</html>
