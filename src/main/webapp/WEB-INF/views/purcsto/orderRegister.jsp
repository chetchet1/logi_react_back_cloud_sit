<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
    <script src="${pageContext.request.contextPath}/js/modal.js?v=<%=System.currentTimeMillis()%>" defer></script>
    <script src="${pageContext.request.contextPath}/js/datepicker.js" defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datepicker.css">
    <script>
      // O setting datapicker
      $(function() {
        // set default dates
        let start = new Date();
        start.setDate(start.getDate() - 20);
        // set end date to max one year period:
        let end = new Date(new Date().setYear(start.getFullYear() + 1));
        // o set searchDate
        $('[data-toggle="datepicker"]').datepicker({
          autoHide: true,
          zIndex: 3072,
          startDate: new Date(),
          endDate: '0d',
          todayHiglght: true,
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
            padding-left: 25px;
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
                max-width: 1200px;
            }
        }

        .swal2-container {
            z-index: 1000000 !important;
        }
    </style>
</head>
<body>
<article class="order">
    <div class="order__Title" style="color:black">
        <h5>📦 발주</h5>
        <b>발주필요품목검색(BY MRP_G) / 취합발주</b>
        <form autocomplete="off">
            <div class="fromToDate">
                <input type="text" id="fromDate" placeholder="YYYY-MM-DD 📅" size="15" style="text-align: center">
                &nbsp; ~ &nbsp;<input type="text" id="toDate" placeholder="YYYY-MM-DD 📅" size="15"
                                    style="text-align: center">
            </div>
        </form>
        <button id="getOrderListButton">재고처리 / 발주필요 목록조회</button>
        <button id="OrderDialogButton">모의재고처리 및 취합발주</button>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <!-- <button id="OptionOrderButton">임의 발주</button> -->
    </div>
</article>
<article class="myGrid">
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:70vh; width:auto; text-align: center;"></div>
    </div>
</article>
<%--O MRP MODAL--%>
<div class="modal fade" id="orderModal" role="dialog">
    <div class="modal-dialog modal-xl">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">
                    <h5>WAREHOUSING</h5>
                    <input type="text" data-toggle="datepicker" id="orderDate" placeholder="YYYY-MM-DD📅" size="15"
                           autocomplete="off" style="text-align: center">&nbsp;&nbsp;
                    <button id="orderButton">현재 전개된 결과 발주 및 재고처리</button>
                </div>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
                <div id="orderGrid" class="ag-theme-balham" style="height: 40vh;width:auto;">
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
  const getOrderListBtn = document.querySelector("#getOrderListButton");
  const fromDate = document.querySelector("#fromDate");
  const toDate = document.querySelector("#toDate");
  const orderDate = document.querySelector("#orderDate");
  const OrderDialogBtn = document.querySelector("#OrderDialogButton");
  const orderBtn = document.querySelector("#orderButton");
  /* const OptionOrderBtn = document.querySelector("#OptionOrderButton"); */

  const orderListColumn = [
    {
      headerName: "소요량취합번호", field: "mrpGatheringNo", suppressSizeToFit: true, headerCheckboxSelection: true,
      headerCheckboxSelectionFilteredOnly: true,
      checkboxSelection: true
    },
    {headerName: "품목코드", field: "itemCode",},
    {headerName: '품목명', field: "itemName",},
    {headerName: '단위', field: 'unitOfMrp',},
    {headerName: '필요수량', field: 'requiredAmount',},
    {headerName: '현재고량', field: 'stockAmount',},
    {
      headerName: '발주기한', field: 'orderDate', cellRenderer: function(params) {
        if (params.value == null) {
          params.value = "";
        }
        return '📅 ' + params.value;
      }
    },
    {
      headerName: '입고기한', field: 'requiredDate', cellRenderer: function(params) {
        if (params.value == null) {
          params.value = "";
        }
        return '📅 ' + params.value;
      }
    },
  ];
  let orderRowData = [];
  const orderListGridOptions = {
    defaultColDef: {
      flex: 1,
      minWidth: 100,
      resizable: true,
    },
    columnDefs: orderListColumn,
    rowSelection: 'multiple',
    rowData: orderRowData,
    getRowNodeId: function(data) {
      return data.mrpGatheringNo;
    },
    defaultColDef: {editable: false, resizable : true},
    overlayNoRowsTemplate: "조회된 발주 데이터가 없습니다.",
    onGridReady: function(event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
      event.api.sizeColumnsToFit();
    },
    onRowSelected: function(event) { // checkbox
      console.log(event);
    },
    onGridSizeChanged: function(event) {
      event.api.sizeColumnsToFit();
    },
    getRowStyle: function(param) {
      return {'text-align': 'center'};
    },
  }
  const orderList = () => { // 발주필요목록 가져온다 
    orderListGridOptions.api.setRowData([]);
    console.log(fromDate.value);
    console.log(toDate.value);
    let xhr = new XMLHttpRequest();
    xhr.open('GET', '${pageContext.request.contextPath}/purchase/order/list' +
        "?method=getOrderList"
        + "&startDate=" + fromDate.value
        + "&endDate=" + toDate.value,
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4 && xhr.status == 200) {
        let txt = xhr.responseText;
        txt = JSON.parse(txt);
        console.log(txt);
        if (txt.gridRowJson == "") {
          Swal.fire("알림", "모의재고 처리 및 취합발주를 완료했습니다.", "info");
          return;
        } else if (txt.errorCode < 0) {
          Swal.fire("오류", txt.errorMsg, "error");
          return;
        }
        console.log(txt);
        orderListGridOptions.api.setRowData(txt.gridRowJson);
      }
    }
  }
  getOrderListBtn.addEventListener("click", () => {  // 재고처리 / 발주필요 목록조회
    if (fromDate.value == "" || toDate.value == "") {
      Swal.fire("입력", "조회할 날짜를 입력하십시오.", "info");
    }
    orderList();
  });
  
  let _setOrderModal = (function() {
    let executed = false;
    return function() {
      if (!executed) {
        executed = true;
        setOrderModal()
      }
    };
  })();
  let mrpGatheringNoList = [];
  OrderDialogBtn.addEventListener('click', () => { // 모의재고처리 및 취합 발주 
	mrpGatheringNoList = [];
    selectedRows = orderListGridOptions.api.getSelectedRows();
    if (selectedRows == "") {
      Swal.fire("알림", "선택한 행이 없습니다.", "info");
      return;
    }
    selectedRows.forEach(function(selectedRow, index) {
      console.log(selectedRow);
      mrpGatheringNoList.push(selectedRow.mrpGatheringNo);
    });
    _setOrderModal();
    getOrderModal(mrpGatheringNoList);
    $("#orderModal").modal('show');
    
  });

  // O 취합 발주
  orderBtn.addEventListener('click', () => {
    if (orderDate.value == "") {
      Swal.fire("알림", "날짜를 입력하십시오.", "info");
      return;
    }
    let xhr = new XMLHttpRequest();
    xhr.open('POST', '${pageContext.request.contextPath}/purchase/order' +
        "?method=order"
        + "&mrpGatheringNoList=" + encodeURI(JSON.stringify(mrpGatheringNoList)),
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
      if (xhr.readyState == 4 && xhr.status == 200) {
        let txt = xhr.responseText;
        txt = JSON.parse(txt);
        console.log(txt);
        if (txt.gridRowJson == "") {
          console.log(txt);
          swal.fire("알림", "없습니다.", "info");
          return;
        } else if (txt.errorCode < 0) {
          swal.fire("오류", txt.errorMsg, "error");
          return;
        }
        Swal.fire("성공", "재고처리 및 발주완료", "success");
        orderGridOptions.api.setRowData([]);
        orderList();
        $('#orderModal').modal('hide');
      }
    }
  });
  // O 임의 발주
/*   OptionOrderBtn.addEventListener('click', () => {
    let jsonData;
    getCustomerData('IT-MA');
    setTimeout(() => {
      jsonData = transferVar();
    }, 100);
    setTimeout(() => {
      console.log(jsonData);
      console.log(jsonData.detailCodeList);
      Swal.fire({
        position: 'top',
        title: '임의 발주',
        html:
            "<label for= 'itemCodeSearchBox'>품목코드</label>" +
            "<select name='itemCodeSearchBox'id='itemCodeSearchBox'>" +
            "<option value='' id='allItem'>전체</option>"
            + "</select><br>" +
            "<label for='unitPriceOfEstimateBox' style='margin-right: 35px'>수량</label>" +
            "<input type='text' id='itemAmountBox' autocomplete='off' style='width: 178px; height: 29px'/><br>"
        ,
        willOpen: () => {
          let target = document.querySelector("#itemCodeSearchBox");
          for (let index of jsonData.detailCodeList) {
            let node = document.createElement("option");
            node.value = index.detailCode;
            let textNode = document.createTextNode(index.detailCodeName);
            node.appendChild(textNode);
            target.appendChild(node);
          }
        },
        showCloseButton: true,
        showCancelButton: true,
        focusConfirm: false,
        confirmButtonText: '발주',
        cancelButtonText: '취소',
        preConfirm: () => {
          let itemCode = document.querySelector("#itemCodeSearchBox");
          let itemAmount = document.querySelector("#itemAmountBox");
          console.log(itemCode.value);
          console.log(itemAmount.value);
          if (itemCode.value == "" || itemAmount.value == "") {
            Swal.fire("알림", "발주할 품목과 품목의 개수를 입력하셔야합니다.", "info");
            return;
          }
          return fetch(`${pageContext.request.contextPath}/material/order/option?method=optionOrder`
              + '&itemCode=' + itemCode.value
              + '&itemAmount=' + itemAmount.value, {
            method: 'POST',
            cache: 'no-cache',
            headers: {
              'Accept': 'application/json',
            },
          }).then(response => {
            console.log(response);
            Swal.fire("성공", "임의발주하였습니다.", "success");
            if (!response.ok) {
              throw new Error(response.statusText)
            }
            return response.json()
          }).catch(error => {
            Swal.showValidationMessage(
                `데이터 송신에 문제가 발생했습니다.: ${error}`
            )
          })
        },
      });
    }, 300);
  }); */
  document.addEventListener('DOMContentLoaded', () => {
    new agGrid.Grid(myGrid, orderListGridOptions);
  });
</script>
</body>
</html>