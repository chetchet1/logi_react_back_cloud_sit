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
      // O setting datapicker
      $(function () {
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
        $('#fromDate').on("change", function () {
          //when chosen from_date, the end date can be from that point forward
          var startVal = $('#fromDate').val();
          $('#toDate').data('datepicker').setStartDate(startVal);
        });
        $('#toDate').on("change", function () {
          //when chosen end_date, start can go just up until that point
          var endVal = $('#toDate').val();
          $('#fromDate').data('datepicker').setEndDate(endVal);
        });

      });
    </script>
    <style>
        .fromToDate {
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
            padding-left: 20px;
        }
        @media (min-width: 768px) {
            .modal-xl {
                width: 90%;
                max-width:1200px;
            }
        }
    </style>
</head>
<body>
<article class="contract">
    <div class="contract__Title">
        <h5>📅 MPS 등록</h5>
        <div style="color: black;">
            <b>수주 상세</b><br/>
            <label for="contractDate">수주 일자</label>
            <input type="radio" name="searchContractDetailCondition" value="contractDate" id="contractDate" checked>
            &nbsp;<label for="dueDateOfContract">납기 일자</label>
            <input type="radio" name="searchContractDetailCondition" value="dueDateOfContract" id="dueDateOfContract">
        </div>

        <form autocomplete="off">
            <div class="fromToDate">
                <input type="text" id="fromDate" placeholder="YYYY-MM-DD 📅" size="15" style="text-align: center">
                &nbsp; ~ &nbsp;<input type="text" id="toDate" placeholder="YYYY-MM-DD 📅" size="15"
                                    style="text-align: center">
            </div>
        </form>
        <button id="contractCandidateSearchButton">MPS등록가능조회</button>
        <button id="mpsModalBtn">MPS조회</button>
        &nbsp;&nbsp;<button id="registerNewMpsButton"  style="background-color:#F15F5F" >MPS등록</button>
    </div>
</article>
<article class="contractMpsGrid">
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:30vh; width:auto; text-align: center;"></div>
    </div>
</article>
<!-- div>
    <h5>📷 판매 계획</h5>
</div> -->
<article class="salesMpsGrid">
    <div align="center" class="ss">
        <div id="myGrid2" class="ag-theme-balham" style="height:30vh;width:auto;"></div>
    </div>
</article>

<div class="modal fade" id="mpsModal" role="dialog">
    <div class="modal-dialog modal-xl">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">MPS LIST</h5>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
                <div id="mpsGrid" class="ag-theme-balham" style="height:600px;width:auto;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<script>
  const myGrid = document.querySelector("#myGrid");
  const myGrid2 = document.querySelector("#myGrid2");
  const searchByDateRadio = document.querySelector("#searchByDateRadio");
  const startDatePicker = document.querySelector("#fromDate");
  const endDatePicker = document.querySelector("#toDate");
 

  // O customerList Grid
  let mpsColumn = [
    {
      headerName: "수주상세일련번호", field: "contractDetailNo", suppressSizeToFit: true, headerCheckboxSelection: true,
      headerCheckboxSelectionFilteredOnly: true,
      checkboxSelection: true
    },
    {headerName: "수주유형", field: "contractType"},
    {headerName: "계획구분", field: "planClassification", hide: true},
    {headerName: "수주일자", field: "contractDate"},
    {headerName: "견적수량", field: "estimateAmount"},
    {headerName: "초기납품내역", field: "stockAmountUse"},
    {headerName: "제작수량", field: "productionRequirement"},
    {
      headerName: "계획일자", field: "mpsPlanDate", editable: true, cellRenderer: function (params) {
        if (params.value == null) {
          params.value = "";
        }
        return '📅 ' + params.value;
      }, cellEditor: 'datePicker1'
    },
    {
      headerName: "출하예정일", field: "scheduledEndDate", editable: true, cellRenderer: function (params) {
        if (params.value == null) {
          params.value = "";
        }
        return '📅 ' + params.value;
      }, cellEditor: 'datePicker2'
    },
    {headerName: "납기일", field: "dueDateOfContract", cellRenderer: function (params) {
        if (params.value == null) {
          params.value = "";
        }
        return '📅 ' + params.value;
      },},
    {headerName: "거래처코드", field: "customerCode"},
    {headerName: "품목코드", field: "itemCode"},
    {headerName: "품목명", field: "itemName"},
    {headerName: "단위", field: "unitOfContract"},
    {headerName: "비고", field: "description", editable: true, hide: true},
  ];
  // event.colDef.field
  let rowData = [];
  let contractMpsRowNode;
  let mpsGridOptions = {
    defaultColDef: {
      flex: 1,
      minWidth: 100,
      resizable: true,
    },
    columnDefs: mpsColumn,
    rowSelection: 'multiple',
    rowData: rowData,
    getRowNodeId: function (data) {
      return data.contractDetailNo;
    },
    defaultColDef: {editable: false, resizable : true},
    overlayNoRowsTemplate: "수주 가능한 견적이 없습니다.",
    onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
      event.api.sizeColumnsToFit();
    },
    onGridSizeChanged: function (event) {
      event.api.sizeColumnsToFit();
    },
    onCellEditingStarted: (event) => {
    },
    onRowClicked: function(event) {
      console.log(event.data);
      contractMpsRowNode = event;
    },
    getSelectedRowData() {
      let selectedNodes = this.api.getSelectedNodes();
      let selectedData = selectedNodes.map(node => node.data);
      return selectedData;
    },
    components: {
      datePicker1: getDatePicker("mpsPlanDate"),
      datePicker2: getDatePicker("scheduledEndDate")
    }
  }

  //ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ MPS 등록가능 수주 조회ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
  
 
  const contractCandidateSearchBtn = document.querySelector("#contractCandidateSearchButton");
  
  contractCandidateSearchBtn.addEventListener("click", () => {
    // o contractDate or dueDateOfContract
    let isChecked = document.querySelector("#contractDate").checked
    let searchCondition = isChecked ? "contractDate" : "dueDateOfContract";
    console.log(searchCondition);
    let startDate = startDatePicker.value;
    let endDate = endDatePicker.value;
    // o detect error
    if (startDate == "" || endDate == "") {
      Swal.fire("입력", "시작일자와 종료일자를 입력하셔야합니다.", "info");
      return;
    }
    console.log(startDate);
    console.log(endDate);
    // o reset Grid
    mpsGridOptions.api.setRowData([]);
    // o ajax
    let xhr = new XMLHttpRequest();
    xhr.open('GET', "${pageContext.request.contextPath}/production/mps/contractdetail-available"
        + "?method=searchContractDetailListInMpsAvailable"
        + "&searchCondition=" + searchCondition
        + "&startDate=" + startDate
        + "&endDate=" + endDate,
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    console.log(xhr);
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4 && xhr.status == 200) {
        let txt = xhr.responseText;
        txt = JSON.parse(txt);
        console.log(txt);
        let gridRowJson = txt.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
        if (gridRowJson == "") {
          swal.fire("mps 등록가능 수주가 없습니다.");
          return;
        }
        console.log(gridRowJson);
        gridRowJson.map((unit, idx) => {
          unit.description = unit.description == null ? "" : unit.description
          unit.planClassification = unit.planClassification == null ? "수주상세" : unit.planClassification
          console.log(unit);
          mpsGridOptions.api.updateRowData({add: [unit]});
        });
      }
    }

  });

  //ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ MPS 등록 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
 
  const registerNewMpsBtn = document.querySelector("#registerNewMpsButton");
  
  registerNewMpsBtn.addEventListener("click", () => {
    let selectedNodes = mpsGridOptions.api.getSelectedNodes();
    // o No seleted Nodes
    if (selectedNodes == "") {
      Swal.fire({
        position: "top",
        icon: 'info',
        title: '체크 항목',
        text: '선택한 행이 없습니다.',
      })
      return;
    }

    let resultList = []; // client data => server
    let resultRows = [];
    for (let node of selectedNodes) {
      if (node.data.mpsPlanDate == null || node.data.scheduledEndDate == null) {
        Swal.fire('입력', '계획일자와 출하예정일을 입력해야합니다.', 'info');
        return;
      }
      // 계획일자, 출하예정일을 new Date() 함수로 날짜 타입으로 변환
      encodeURI(resultList.push(node.data)); // 체크한 수주상세 행의 데이터
      resultRows.push(node.data);
      console.log(resultList);
    }
    resultList = JSON.stringify(resultList);  
    // o insert mps
    Swal.fire({
      title: 'MPS 등록',
      text: selectedNodes.length + "건을 등록하시겠습니까?",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      cancelButtonText: '취소',
      confirmButtonText: '확인',
    }).then((result) => {
      if (result.isConfirmed) {
      let xhr = new XMLHttpRequest();
      xhr.open('PUT', "${pageContext.request.contextPath}/production/mps/contractdetail"
          + "?method=convertContractDetailToMps"
          + "&batchList=" + encodeURI(resultList),
          true);
      xhr.setRequestHeader('Accept', 'application/json');
      xhr.send();
      xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
          // 데이터 확인
          let txt = xhr.responseText;
          txt = JSON.parse(txt);
          if (txt.errorCode != 1) {
            Swal.fire('실패', txt.errorMsg, 'error');
          }
          // 초기화
          let step;
          for (step = 0; step < resultRows.length; step++) {  // resultRows는 선택한 수주상세 데이터를 담아두었던 변수 
            mpsGridOptions.api.updateRowData({remove: [resultRows[step]]});
          }
          console.log("mps 등록 완료");
          console.log(txt);
          let resultMsg =
              `<판매판계획에서 MPS 등록 내역 ><br>
                     추가 : ${"${( ( txt.result.INSERT.length != 0 ) ? txt.result.INSERT : '없음' )}"}<br>
                     위와 같이 작업이 처리되었습니다.`;
          Swal.fire('등록 완료', resultMsg, 'success');
        }
      };
    }})
  });
  let _getMpsList = (function() {
    let executed = false;
    return function() {
      if (!executed) {
        executed = true;
        getMpsList()
      }
    };
  })();
  let _setMpsModal = (function() {
    let executed = false;
    return function() {
      if (!executed) {
        executed = true;
        setMpsModal()
      }
    };
  })();

   // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ MPS조회 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
   
   const mpsModalBtn = document.querySelector("#mpsModalBtn");
  
  mpsModalBtn.addEventListener("click", () => {   // MPS 조회
    if (startDatePicker.value == "" || endDatePicker.value == "") {
      swal.fire("입력", "조회기간을 설정해야합니다.", "info");
      return;
    } else {
      _getMpsList();
      _setMpsModal();
      $('#mpsModal').modal('show');
    }
  });
  // O getDataPicker
  function getDatePicker(paramFmt) {
    let _this = this;
    _this.fmt = "yyyy-mm-dd";


    // function to act as a class
    function Datepicker() {
    }
    Datepicker.prototype.init = function (params) {
      // create the cell
      this.autoclose = true;
      this.eInput = document.createElement('input');
      this.eInput.style.width = "100%";
      this.eInput.style.border = "0px";
      this.cell = params.eGridCell;
      this.oldWidth = this.cell.style.width;
      this.cell.style.width = this.cell.previousElementSibling.style.width;
      this.eInput.value = params.value;
      console.log(paramFmt);
      // Setting startDate and endDate
      let _startDate = new Date();
      let _endDate;
      let year = _startDate.getFullYear();              //yyyy
      let month = (1 + _startDate.getMonth());          //M
      month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
      let day = _startDate.getDate();                   //d
      day >= 10 ? day : '0' + day;          //day 두자리로 저장
      _startDate = year + '' + month + '' + day;
      _endDate = _startDate
      console.log(contractMpsRowNode);
      if (paramFmt == "scheduledEndDate") {
        _endDate = contractMpsRowNode.data.dueDateOfContract;
        console.log(_endDate);
      }

      $(this.eInput).datepicker({
        startDate: _startDate,
        endDate: _endDate,
        dateFormat: _this.fmt
      }).on('change', function () {
        mpsGridOptions.api.stopEditing();
        $(".datepicker-container").hide();
      });
    };
    // gets called once when grid ready to insert the element
    Datepicker.prototype.getGui = function () {
      return this.eInput;
    };

    // focus and select can be done after the gui is attached
    Datepicker.prototype.afterGuiAttached = function () {
      this.eInput.focus();
      console.log(this.eInput.value);
    };

    // returns the new value after editing
    Datepicker.prototype.getValue = function () {
      console.log(this.eInput);
      return this.eInput.value;
    };

    // any cleanup we need to be done here
    Datepicker.prototype.destroy = function () {
      mpsGridOptions.api.stopEditing();
    };
    return Datepicker;
  }
  // O setup the grid after the page has finished loading
  document.addEventListener('DOMContentLoaded', () => {
    new agGrid.Grid(myGrid, mpsGridOptions);
    // new agGrid.Grid(myGrid2, estDetailGridOptions);
  })
</script>
</body>
</html>