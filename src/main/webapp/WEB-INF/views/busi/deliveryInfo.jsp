<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
    <script src="${pageContext.request.contextPath}/js/modal.js?v=<%=System.currentTimeMillis()%>" defer></script>
    <script src="${pageContext.request.contextPath}/js/datepicker.js" defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datepicker.css">
    <script>
            // O 날짜 설정
            $(function() {
              // set default dates
              let start = new Date();
              start.setDate(start.getDate() - 20);
              // set end date to max one year period:
              let end = new Date(new Date().setYear(start.getFullYear() + 1));
              // o set searchDate
              $('#datepicker').datepicker({
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
              });
              // o set searchRangeDate
              $('#fromDate').datepicker({
                startDate: start,
                endDate: end,
                minDate: "-10d",
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
                // update "toDate" defaults whenever "fromDate" changes
              })
              $('#toDate').datepicker({
                startDate: start,
                endDate: end,
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
              })
              $('#fromDate').on("change", function() {
                //when chosen from_date, the end date can be from that point forward
                var startVal = $('#fromDate').val();
                $('#toDate').data('datepicker').setStartDate(startVal);
              });
              $('#toDate').on("change", function() {
                //when chosen end_date, start can go just up until that point
                var endVal = $('#toDate').val();
                $('#fromDate').data('datepicker').setEndDate(endVal);
              });
      
            });
    </script>
    <style>
        .fromToDate {
            display: inline-block;
            margin-bottom: 7px;
        }

        #searchCustomerBox {
            display: none;
            margin-bottom: 7px;
        }

        #datepicker {
            margin-bottom: 7px;
        }

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
            padding-left: 5px;
        }
    </style>
</head>
<body>
<article class="delivery">
    <div class="delivery__Title" style="color: black">
        <h5>🚚 납품</h5>
        <b>수주 검색 조건</b><br/>
        <div>
            <label for="searchByPeriodRadio">기간 검색</label>
            <input type="radio" name="searchCondition" value="searchByDate" id="searchByPeriodRadio" checked>
            &nbsp;<label for="searchByCustomerRadio">거래처 검색</label>
            <input type="radio" name="searchCondition" value="searchByCustomer" id="searchByCustomerRadio">
        </div>

        <form autocomplete="off">
            <select name='searchCustomerBox' id='searchCustomerBox' style='width: 152px; height:26px;'>
            </select>
            <div class="fromToDate">
                <input type="text" id="fromDate" placeholder="YYYY-MM-DD 📅" size="15" style="text-align: center">
                &nbsp; ~ &nbsp;<input type="text" id="toDate" placeholder="YYYY-MM-DD 📅" size="15"
                                    style="text-align: center">
            </div>
        </form>
        <button id="deliverableContractSearchButton">납품 가능 수주조회</button>
        <button id="deliverableContractDetailButton">납품 가능 상세조회</button>
        &nbsp;&nbsp;<button id="deliveryButton" style="background-color:#F15F5F">납품</button>
    </div>
</article>
<article class="contractGrid">
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:30vh; width:auto; text-align: center;"></div>
    </div>
</article>
<div>
    <h5>📋 납품 수주 상세</h5>
</div>
<article class="deliveryDetailGrid">
    <div align="center" class="ss">
        <div id="myGrid2" class="ag-theme-balham" style="height:30vh;width:auto;"></div>
    </div>
</article>

<div class="modal fade" id="contractType" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">CONTRACT TYPE</h5>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
                <div id="contractGrid" class="ag-theme-balham" style="height:500px;width:auto;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<script>
  const myGrid = document.querySelector("#myGrid");
  const myGrid2 = document.querySelector("#myGrid2");
  const searchByPeriodRadio = document.querySelector("#searchByPeriodRadio");     // 기간검색
  const searchByCustomerRadio = document.querySelector("#searchByCustomerRadio"); // 거래처검색
  const searchCustomerBox = document.querySelector("#searchCustomerBox");
  const fromToDate = document.querySelector(".fromToDate");
  const startDatePicker = document.querySelector("#fromDate"); //  시작일자
  const endDatePicker = document.querySelector("#toDate");     //  종료일자
  const deliverableContractSearchBtn = document.querySelector("#deliverableContractSearchButton"); // 납품 가능 수주 조회
  const deliverableContractDetailBtn = document.querySelector("#deliverableContractDetailButton"); // 납품 가능 상세 조회
  const deliveryBtn = document.querySelector("#deliveryButton");                                     // 납품
  
  // O setup the grid after the page has finished loading
  document.addEventListener('DOMContentLoaded', () => {
    getCustomerCode(); // 거래처 select태그 세팅 
    new agGrid.Grid(myGrid, deliverableContractGridOptions);
    new agGrid.Grid(myGrid2, deliverableDetailGridOptions);
  })
  
// 기간 검색, 거래처 검색 ==============================================
  searchByPeriodRadio.addEventListener("click", () => { 
    fromToDate.style.display = "inline-block";
    searchCustomerBox.style.display = "none";
  });
  searchByCustomerRadio.addEventListener("click", () => {
    searchCustomerBox.style.display = "inline-block";
    fromToDate.style.display = "none";
  });
  const getCustomerCode = () => { 
     getListData("CL-01");
    setTimeout(() => {
      let data = jsonData;
      let target = searchCustomerBox;
      for (let index of data.detailCodeList) {
        let node = document.createElement("option");
        node.value = index.detailCode;
        let textNode = document.createTextNode(index.detailCodeName);
        node.appendChild(textNode);
        target.appendChild(node);
      }
    }, 100)
  }
// ===============================================================
  // O deliverableContract Grid 첫번째 그리드
  let deliverableContractColumn = [
    {
      headerName: '수주일련번호',
      field: "contractNo",
      checkboxSelection: true,
      width: 200,
      headerCheckboxSelection: false,
      headerCheckboxSelectionFilteredOnly: true,
      suppressRowClickSelection: true,
    },
    {headerName: "견적일련번호", field: "estimateNo"},
    {headerName: "수주유형분류", field: "contractTypeName"},
    {headerName: "거래처코드", field: "customerCode", hide: true},
    {headerName: "거래처명", field: "customerName"},
    {headerName: "견적일자", field: "estimateDate", cellRenderer: function (params) {
        return '📅 ' + params.value;
      }},
    {headerName: "수주일자", field: "contractDate", cellRenderer: function (params) {
        return '📅 ' + params.value;
      }},
    {headerName: "수주요청자", field: "contractRequester"},
    {headerName: "수주담당자명", field: "empNameInCharge"},
    {headerName: "비고", field: "description"},
    {headerName: "수주유형", field: "contractType", hide: true},
    {headerName: "담당자", field: "personCodeInCharge", hide: true},
    {headerName: "납품완료여부", field: "deliveryCompletionStatus", hide: true},
  ];
  // o 첫번째 그리드 옵션들
  let deliverableContractRowData = [];
  let deliverableContractGridOptions = {
    columnDefs: deliverableContractColumn,
    rowSelection: 'single',
    rowData: deliverableContractRowData,
    getRowNodeId: function(data) {
      return data.contractNo;
    },
    defaultColDef: {editable: false, resizable : true},
    overlayNoRowsTemplate: "수주 가능 리스트가 없습니다.",
    onGridReady: function(event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
      event.api.sizeColumnsToFit();
    },
    onGridSizeChanged: function(event) {
      event.api.sizeColumnsToFit();
    },
    getRowStyle: function (param) {
      return {'text-align': 'center'};
    },
  }
  //=================================================================
  // O deliverableContractDetail Grid 두번째 납품 수주 상세 그리드
  let deliverableDetailColumn = [
    {headerName: '수주상세일련번호', field: "contractDetailNo", checkboxSelection: true,
      headerCheckboxSelection: false, headerCheckboxSelectionFilteredOnly: true,
      width: 400,
    },
    {headerName: "수주일련번호", field: "contractNo"},
    {headerName: "품목코드", field: "itemCode"},
    {headerName: "품목명", field: "itemName"},
    {headerName: "단위", field: "unitOfContract"},
    {headerName: "납기일", field: "dueDateOfContract"},
    {headerName: "견적수량", field: "estimateAmount"},
    {headerName: "재고사용량", field: "stockAmountUse"},
    {headerName: "필요제작수량", field: "productionRequirement"},
    {headerName: "단가", field: "unitPriceOfContract"},
    {headerName: "합계액", field: "sumPriceOfContract"},
    {headerName: "처리상태", field: "processingStatus", cellRenderer: function (params) {
        if (params.value == "Y") {
          return params.value = "🟢";
        }
        return '❌';
      },},
    {headerName: "작업완료여부", field: "operationCompletedStatus", cellRenderer: function (params) {
        if (params.value == "Y") {
          return params.value = "🟢";
        }
        return '❌';
      },},
    {headerName: "납품완료여부", field: "deliveryCompletionStatus", cellRenderer: function (params) {
        if (params.value == "Y") {
          return params.value = "🟢";
        }
        return '❌';
      },},
    {headerName: "비고", field: "description"},
  ];
  // o 두번째 그리드 옵션들
  let deliverableDetailRowData = [];
  let deliverableDetailRowNode;
  let deliverableDetailGridOptions = {
    columnDefs: deliverableDetailColumn,
    rowSelection: 'single',
    rowData: deliverableDetailRowData,
    getRowNodeId: function(data) {
      return data.contractDetailNo;
    },
    onRowClicked: function(event) {
       console.log(event);
      let selectedRows = deliverableDetailGridOptions.api.getSelectedRows();
      deliverableDetailRowNode = event;  
      console.log("test selectedRows");
      console.log(selectedRows);
      console.log("test deliverableDetailRowNode");
      console.log(deliverableDetailRowNode);
    },
    defaultColDef: {editable: false, resizable : true},
    overlayNoRowsTemplate: "수주 가능 상세리스트가 없습니다.",
    onGridReady: function(event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
      event.api.sizeColumnsToFit();
    },
    onGridSizeChanged: function(event) {
      event.api.sizeColumnsToFit();
    },
    getRowStyle: function (param) {
      return {'text-align': 'center'};
    },
  }
// 그리드 띄워주고 해당 옵션들 위치 끝====================================================================   
//========================================================
   // O 납품 가능 수주 조회 버튼
  const deliverableContract = (searchCondition, startDate, endDate, customerCode) => {
     
    deliverableContractGridOptions.api.setRowData([]);
    ableContractInfo = {"searchCondition":searchCondition,"startDate":startDate,"endDate":endDate,"customerCode":customerCode};
    ableContractInfo=encodeURI(JSON.stringify(ableContractInfo));
    console.log("searchCondition : "+searchCondition);
    console.log("startDate : "+startDate);
    console.log("endDate : "+endDate);
    console.log("customerCode : "+customerCode);
    let xhr = new XMLHttpRequest();
    xhr.open('GET', "${pageContext.request.contextPath}/sales/deliver/list/contractavailable"
        + "?method=searchDeliverableContractList"
        + "&ableContractInfo=" + ableContractInfo,
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4 && xhr.status == 200) {
        let txt = xhr.responseText;
        txt = JSON.parse(txt);
        if (txt.gridRowJson == "") {
          Swal.fire("알림", "조회 가능 리스트가 없습니다.", "info");
          return;
        } else if (txt.errorCode < 0) {
          Swal.fire("알림", txt.errorMsg, "error");
          return;
        }
        console.log(txt);
        deliverableContractGridOptions.api.setRowData(txt.gridRowJson);
      }
    }
  }
  // 납품 가능 수주 조회 클릭메서드
  deliverableContractSearchBtn.addEventListener("click", () => { 
    let searchCondition = (searchByPeriodRadio.checked) ? searchByPeriodRadio.value : searchByCustomerRadio.value;
    let startDate = "";
    let endDate = "";
    let customerCode = "";
    if (searchCondition == 'searchByDate') {
      if (startDatePicker.value == "" || endDatePicker.value == "") {
        Swal.fire("입력", "시작일과 종료일을 입력하십시오.", "info");
        return
      } else {
        startDate = startDatePicker.value;
        endDate = endDatePicker.value;
      }
    } else if (searchCondition == 'searchByCustomer'){
      customerCode = searchCustomerBox.value;
    }
    deliverableContract(searchCondition, startDate, endDate, customerCode);
  });
  //==================================================
  // O 납품 가능 상세조회
  deliverableContractDetailBtn.addEventListener('click', () => {  // 납품가능상세조회 
    let selectedRows = deliverableContractGridOptions.api.getSelectedRows();
    if (selectedRows == "") {
      Swal.fire("알림", "선택한 행이 없습니다.", "info");
      return;
    }
    let selectedRow = selectedRows[0];
    if (selectedRow.contractDetailTOList == "") {
      Swal.fire("알림", "조회되는 리스트가 없습니다.", "info");
      return;
    }
    console.log(selectedRow.contractDetailTOList);
    deliverableDetailGridOptions.api.setRowData(selectedRow.contractDetailTOList);
    deliverableDetailGridOptions.rowSelection='single';
  });
  //===================================================
  // O 납품
  const delivery = (contractDetailNo, itemName, estimateAmount) => { 
    console.log(contractDetailNo);
    console.log(itemName);
    console.log(estimateAmount);
    console.log(deliverableDetailRowNode);
    
    let rowNode = deliverableDetailRowNode.node; // deliverableDetailRowNode : 납품상세그리드의 선택한 로우 객체 
    console.log(rowNode);
    let confirmMsg = "이하 항목에 대해 납품처리합니다.</br>" +
        "수주상세일련번호 : " + contractDetailNo + "</br>" +
        "품목명 : " + itemName + "</br>" +
        "수량 : " + estimateAmount + "</br>" +
        "계속하시겠습니까?";
    // o 데이터 전송
    Swal.fire({
      title: '납품완료',
      html: confirmMsg,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      cancelButtonText: '취소',
      confirmButtonText: '확인',
    }).then((result) => {
      if (result.isConfirmed) {
        let xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/sales/deliver' +
            "?method=deliver"
            +"&contractDetailNo=" + contractDetailNo,
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
            }
            Swal.fire(
                '성공!',
                '납품이 완료되었습니다.',
                'success'
            )
            console.log(txt);
            
            rowNode.setDataValue("deliveryCompletionStatus", 'Y');
            
         	orderGridOptions.api.setRowData([]);
            orderListGridOptions.api.setRowData([]);

          }
        }
      }
    })
  }
  // 납품 클릭메서드
  deliveryBtn.addEventListener('click', () => { // 납품 
    let selectedRows = deliverableDetailGridOptions.api.getSelectedRows();
    if (selectedRows == "") {
      Swal.fire("알림", "선택한 행이 없습니다.", "info");
      return;
    }
    let selectedRow = selectedRows[0];
    console.log(selectedRow);
    if (selectedRow.processingStatus == "" || selectedRow.processingStatus == null) {
      Swal.fire("알림", "처리되지 않은 항목입니다. MPS계획수립부터 작업까지 완료해주세요.", "info");
      return;
    } else if(selectedRow.operationCompletedStatus == '' || selectedRow.operationCompletedStatus == null){
      Swal.fire("알림", "작업이 완료되지 않은 항목입니다. 작업지시 및 작업완료까지 완료해주세요.", "info");
      return;
    } else if(selectedRow.deliveryCompletionStatus == 'Y'){
      Swal.fire("알림", "납품이 완료된 항목입니다.", "info");
      return;
    }
    let contractDetailNo = selectedRow.contractDetailNo;
    let itemName = selectedRow.itemName;
    let estimateAmount = selectedRow.estimateAmount; 
    delivery(contractDetailNo, itemName, estimateAmount);
  });
</script>
</body>
</html>