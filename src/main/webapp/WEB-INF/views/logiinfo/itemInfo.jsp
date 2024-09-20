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
    <script src="${pageContext.request.contextPath}/js/datepickerUse.js" defer></script>
    <script src="${pageContext.request.contextPath}/js/datepicker.js" defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datepicker.css">

    <style>

        #searchCustomerBox {
            display: none;
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
<div>
    <h5>📋 품목 목록조회</h5>
    <button id="itemgroupButton">품목 조회</button>
    <button id="itemdetailgroupButton">품목 상세조회</button>
    <button id="deleteitemgroupButton">품목 삭제</button>

</div>
    <div id="myGrid2" class="ag-theme-balham" style="height:30vh;width:auto; text-align: center;"></div>
</div>
</article>

<div>
        <h5>📋 품목 상세 목록조회</h5>
        <button id="itemDetailInsertButton" >품목상세추가</button>
        <button id="itemDetailDeleteButton" >품목상세삭제</button>

        <button id="batchSaveButton" style="float:right; background-color:#F15F5F"  >일괄처리</button>



</div>

<article class="contractGrid">
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:30vh; width:auto; text-align: center;"></div>
    </div>
</article>



<script>
  const myGrid = document.querySelector("#myGrid");
  const myGrid2 = document.querySelector("#myGrid2");
  const fromToDate = document.querySelector(".fromToDate");

  const itemgroupBtn = document.querySelector("#itemgroupButton"); //품목그룹 조회
  const deleteitemgroupBtn = document.querySelector("#deleteitemgroupButton"); //품목그룹 삭제

  const itemDetailSearchBtn = document.querySelector("#itemdetailgroupButton"); //품목상세목록 조회
  const itemDetailDeleteBtn = document.querySelector("#itemDetailDeleteButton"); //품목상세 삭제
  const itemDetailInsertBtn = document.querySelector("#itemDetailInsertButton"); //품목상세 추가
  const batchSaveBtn = document.querySelector("#batchSaveButton"); //일괄처리

  //품목그룹 그리드
  let clientInformationColumn = [
      {headerName: "품목그룹코드", field: "itemGroupCode",
           checkboxSelection: true,
            width: 200,
            headerCheckboxSelection: true,
            headerCheckboxSelectionFilteredOnly: true,
            suppressRowClickSelection: true,
      },
        {headerName: "품목그룹명", field: "itemGroupName"},
  ];
  let clientInformationRowData = [];
  let clientInformationRowNode;
  let clientInformationGridOptions = {
    columnDefs: clientInformationColumn,
    rowSelection: 'single',
    rowData: clientInformationRowData,
    /* getRowNodeId: function(data) { //RowNodeId를 가져오는 함수로 값을 지정해 두면 그리드에서 데이터를 여기서 정의한 값으로 접근할 수 있다
      return data.contractDetailNo;                         // L> 데이터 접근 예제: var rowNode = gridOptions.api.getRowNode(selectedRow.goodCd);
    }, */
    onRowClicked: function(event) {
       console.log(event);
      let selectedRows = clientInformationGridOptions.api.getSelectedRows();
      clientInformationRowNode = event;
      console.log("test selectedRows");
      console.log(selectedRows);
      console.log("test clientInformationRowNode");
      console.log(clientInformationRowNode);
    },
    onCellDoubleClicked:function(event){
        let itemGroupCodeNo = event.data.itemGroupCode; //품목 코드를 가져온다
        console.log(itemGroupCodeNo);
        getItemImage(itemGroupCodeNo);
     },
    defaultColDef: {editable: false, resizable : true},
    overlayNoRowsTemplate: "품목 리스트가 없습니다.",
    onGridReady: function(event) {////보통 그리드 자동 사이즈 등을 지정, ready 이후 필요한 이벤트 삽입
      event.api.sizeColumnsToFit();
    },
    onGridSizeChanged: function(event) {
      event.api.sizeColumnsToFit();
    },
  }

  // 품목그룹 조회
  const iteminquiryinformation = (itemGroupCode) => {

    ableContractInfo = {"itemGroupCode":itemGroupCode};
    ableContractInfo=encodeURI(JSON.stringify(ableContractInfo));
    console.log("itemGroupCode : "+itemGroupCode);
    let xhr = new XMLHttpRequest();
    xhr.open('GET', "${pageContext.request.contextPath}/logiinfo/item/group-list"
        + "?method=searchitemGroupList"
        + "&ableContractInfo=" + ableContractInfo,
        true);
    xhr.setRequestHeader('Accept', 'application/json'); //클라이언트가 서버로 전송할 데이터 지정()
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
        clientInformationGridOptions.api.setRowData(txt.gridRowJson);
      }
    }
  }

  //품목그룹 조회 이벤트
  itemgroupBtn.addEventListener("click", () => {
     iteminquiryinformation();
  });

  //품목그룹 삭제
  const deleteitemgroup = (selectedRow) => {
       ableContractInfo = {"itemGroupCode":selectedRow.itemGroupCode};
       ableContractInfo=encodeURI(JSON.stringify(ableContractInfo));

       let xhr = new XMLHttpRequest(); //XMLHttpRequest의 객체생성
       xhr.open('DELETE', "${pageContext.request.contextPath}/logiinfo/item/group"
           + "?method=deleteItemGroup"
           + "&ableContractInfo=" + ableContractInfo,
           true);
       xhr.setRequestHeader('Accept', 'application/json'); //헤더, 헤더값으로 검사
       xhr.send();
       xhr.onreadystatechange = () => { //이벤트 발생이 될 때마다 onreadystatechange 이벤트 핸들러가 호출
         if (xhr.readyState == 4 && xhr.status == 200) {
           let txt = xhr.responseText;
           txt = JSON.parse(txt);
           alert("삭제되었습니다.");
           if (txt.gridRowJson == "") {
             Swal.fire("알림", "조회 가능 리스트가 없습니다.", "info");
             return;
           } else if (txt.errorCode < 0) {
             Swal.fire("알림", txt.errorMsg, "error");
             return;
           }
           console.log("ttt :" + JSON.stringify(txt));
         }
       }
     }


  //품목그룹 삭제 이벤트
  deleteitemgroupBtn.addEventListener("click", () => {
       let selectedRows = clientInformationGridOptions.api.getSelectedRows();
        console.log(selectedRows);
        if (selectedRows == "") {
          Swal.fire("알림", "선택한 행이 없습니다.", "info");
          return;
        }
         let selectedRow = selectedRows[0];
        if (selectedRow.clientInformationList == "") {
          Swal.fire("알림", "삭제 가능한 리스트가 없습니다.", "info");
          return;
        }

        deleteitemgroup(selectedRow);
        clientInformationGridOptions.api.updateRowData({remove:[selectedRow]});
  });


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */




  //품목 상세 그리드
  let deliverableContractColumn = [
      {headerName: "품목코드", field: "itemCode",
           checkboxSelection: true,
            width: 200,
            headerCheckboxSelection: false,
            headerCheckboxSelectionFilteredOnly: true,
            suppressRowClickSelection: true,
            editable: true

      },
      {headerName: "품목명", field: "itemName", editable: true},
      {headerName: "품목그룹코드", field: "itemGroupCode", editable: true},
       {headerName: "품목분류", field: "itemClassification", editable: true},
       {headerName: "단위", field: "unitOfStock", editable: true},
       {headerName: "손실율", field: "lossRate", editable: true},
       {headerName: "소요일", field: "leadTime", editable: true},
       {headerName: "단가", field: "standardUnitPrice", editable: true},
       {headerName: "설명", field: "description", editable: true},
       {headerName: "status", field: "status"}

  ];
  let deliverableContractRowData = [];
  let deliverableContractGridOptions = {
    columnDefs: deliverableContractColumn,
    rowSelection: 'multiple',
    rowData: deliverableContractRowData,
 /*    getRowNodeId: function(data) {
      return data.itemGroupCode;
    }, */

    defaultColDef: {editable: false, resizable : true},
    overlayNoRowsTemplate: "품목 상세 리스트가 없습니다.",
    onGridReady: function(event) { //RowNodeId를 가져오는 함수로 값을 지정해 두면 그리드에서 데이터를 여기서 정의한 값으로 접근할 수 있다
      event.api.sizeColumnsToFit();              // L> 데이터 접근 예제: var rowNode = gridOptions.api.getRowNode(selectedRow.goodCd);
    },
    onGridSizeChanged: function(event) { //보통 그리드 자동 사이즈 등을 지정, ready 이후 필요한 이벤트 삽입
      event.api.sizeColumnsToFit();
    },
    onRowSelected: function (event) { // checkbox
        console.log(event);
    },
    onSelectionChanged(event) { //Row가 선택이 바뀌는 경우 발생하는 이벤트
        console.log("onSelectionChanged" + event);
    },
    onCellEditingStarted: function(event) {
		let updaterow = this.api.getSelectedRows();
		console.log(updaterow);
		if (updaterow == "") {
		   Swal.fire("알림", "선택한 행이 없습니다.", "info");
		     return;
		 }
		updaterow.forEach(function(updaterow,index){
			console.log(updaterow);
			if(updaterow.status == 'NORMAL'){
			   updaterow.status = 'UPDATE'
			   deliverableContractGridOptions.api.updateRowData({update: [updaterow]});
			}
		});
    },
    getSelectedRowData() {
        let selectedNodes = this.api.getSelectedNodes();
        let selectedData = selectedNodes.map(node => node.data);
        return selectedData;
       },

 }

  // 품목 상세목록조회
  const deliverableContract = (selectedRow) => {

   deliverableContractGridOptions.api.setRowData([]);
    ableContractInfo = {"itemGroupCode":selectedRow.itemGroupCode};
    ableContractInfo=encodeURI(JSON.stringify(ableContractInfo));

    let xhr = new XMLHttpRequest();
    xhr.open('GET', "${pageContext.request.contextPath}/logiinfo/item/info-list"
        + "?method=searchitemInfoList"
        + "&ableContractInfo=" + ableContractInfo,
        true);
    xhr.setRequestHeader('Accept', 'application/json'); //클라이언트가 서버로 전송할 데이터 지정()
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


  //목록상세조회 이벤트
  itemDetailSearchBtn.addEventListener("click", () => {  //품목 목록조회
     let selectedRows = clientInformationGridOptions.api.getSelectedRows();
     console.log(selectedRows);
       if (selectedRows == "") {
         Swal.fire("알림", "선택한 행이 없습니다.", "info");
         return;
       }
        let selectedRow = selectedRows[0];
       if (selectedRow.clientInformationList == "") {
         Swal.fire("알림", "조회되는 리스트가 없습니다.", "info");
         return;
       }
     deliverableContract(selectedRow);
  });



      //품목상세 추가
     itemDetailInsertBtn.addEventListener("click", () => {  //품목 목록조회
          let row = {
        		 description: "",
                 standardUnitPrice: "",
                 leadTime: "",
                 lossRate: "",
                 unitOfStock: "",
                 itemClassification: "",
                 itemGroupCode: "",
                 itemName: "",
                 itemCode: "",
                 status: "INSERT"
                };
                deliverableContractGridOptions.api.updateRowData({add: [row]});
       });

  //상세품목 삭제
  itemDetailDeleteBtn.addEventListener("click", () => {
   let selected = deliverableContractGridOptions.api.getSelectedRows();
     console.log(selected);
       if (selected == "") {
         Swal.fire("알림", "선택한 행이 없습니다.", "info");
         return;
   }
    /*  let selectedRows = deliverableContractGridOptions.api.getSelectedRows();
     console.log("선택된 행" + selectedRows ); */

     selected.forEach(function(selected,index){
     console.log(selected);
        if(selected.status == 'INSERT')
           deliverableContractGridOptions.api.updateRowData({remove: [selected]});
        else{
          selected.status = 'DELETE'
             deliverableContractGridOptions.api.updateRowData({update: [selected]});
       }
      });
  });

 // 일괄처리 <= 선택된 항목만
  batchSaveButton.addEventListener("click", () => {
    let newitemRowValue = deliverableContractGridOptions.getSelectedRowData();
    console.log(newitemRowValue);

    let selectedRows = deliverableContractGridOptions.api.getSelectedRows();
    if(selectedRows.length==0){
       Swal.fire({
            text: "상세 목록을 추가하지 않았습니다",
            icon: "info",
          })
       return;
    }
    for(index in selectedRows){
          selectedRow=selectedRows[index];
          console.log(selectedRow);
       if (selectedRow.itemCode == "") {
           Swal.fire({
             text: "품목코드를 입력하지 않았습니다",
             icon: "info",
      })
         return;
      }else if (selectedRow.itemName == "") {
          Swal.fire({
              text: "품목명를 입력하지 않았습니다",
              icon: "info",
          })
         return;
     }
    }

    newitemRowValue = deliverableContractGridOptions.getSelectedRowData();
    console.log('@@@@@@@@@@@@ HERE!!!@@@@@@@@@@@@@')

    Swal.fire({
      title: "품목상세를 등록하시겠습니까?",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      cancelButtonText: '취소',
      confirmButtonText: '확인',
    }).then( (result) => {
      if (result.isConfirmed) {

         ableContractInfo = {"newitemRowValue":newitemRowValue};
         ableContractInfo=encodeURI(JSON.stringify(newitemRowValue));
         newitemRowValue = JSON.stringify(newitemRowValue);
         let xhr = new XMLHttpRequest();
           xhr.open('POST', "${pageContext.request.contextPath}/logiinfo/item/batchsave"
               + "?method=itemBatchSave"
               + "&ableContractInfo=" + ableContractInfo,
               true);
      xhr.setRequestHeader('Accept', 'application/json');
      xhr.send();
      xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
          // 초기화
          deliverableContractGridOptions.api.setRowData([]);
          deliverableContractGridOptions.api.setRowData([]);
          let txt = xhr.responseText;
          txt = JSON.parse(txt);
          let resultMsg =
              "<h5>< 품목상세 등록 내역 ></h5>"
              + "위와 같이 작업이 처리되었습니다";
          Swal.fire({
            title: "등록이 완료되었습니다.",
            html: resultMsg,
            icon: "success",
          });
        }
      };
    }})
  })
   document.addEventListener('DOMContentLoaded', () => {
   new agGrid.Grid(myGrid2, clientInformationGridOptions);
   new agGrid.Grid(myGrid, deliverableContractGridOptions);
  })
  </script>
</body>