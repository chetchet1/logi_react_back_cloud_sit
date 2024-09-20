<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">

    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

    <script src="${pageContext.request.contextPath}/js/datepicker.js" defer></script>
    <script src="${pageContext.request.contextPath}/js/datepickerUse.js" defer></script>
    <script src="${pageContext.request.contextPath}/js/modal.js?v=<%=System.currentTimeMillis()%>" defer></script>
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
            $('[data-toggle="datepicker"]').datepicker({
                autoHide: true,
                zIndex: 2048,
            });
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

        .form-control {
            display: inline;
             !important;
        }

        @media (min-width: 768px) {
            .modal-xl {
                width: 90%;
                max-width: 1200px;
            }
        }
    </style>
</head>

<body>
    <article class="contract">
        <div class="contract__Title">
            <h5>📋 수주</h5>
            <div>
                <label for="searchByDateRadio">기간검색</label>
                <input type="radio" name="searchCondition" value="searchByDate" id="searchByDateRadio" checked>
                &nbsp;<label for="searchByDateDateRadio">거래처 검색</label>
                <input type="radio" name="searchCondition" value="searchByCustomer" id="searchByDateRadio">
            </div>

            <form autocomplete="off">
                <div class="fromToDate">
                    <input type="text" id="fromDate" placeholder="YYYY-MM-DD 📅" size="15" style="text-align: center">
                    &nbsp; ~ &nbsp;<input type="text" id="toDate" placeholder="YYYY-MM-DD 📅" size="15"
                        style="text-align: center">
                </div>
            </form>
            <button id="contractSearchButton">수주조회</button>
            <button id="contractDetaillButton">수주상세 조회</button>
            <button id="pdfOpenButton">PDF 출력/저장</button>
        </div>
    </article>
    <article class="estimuloInfoGrid">
        <div align="center">
            <div id="myGrid" class="ag-theme-balham" style="height:30vh; width:auto; text-align: center;"></div>
        </div>
    </article>
    <br/>
    <article class="contractDetail">
    <div class="contractDetail__Title">
        <h5>📋 수주상세</h5>
    </div>
</article>
    <article class="myGrid2">
        <div align="center">
            <div id="myGrid2" class="ag-theme-balham" style="height: 30vh;width:auto; text-align: center;"></div>
        </div>
    </article>

<%--Customer Modal--%>
<div class="modal fade" id="customerModal" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">CUSTOMER CODE</h4>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
                <div id="customerGrid" class="ag-theme-balham" style="height:500px;width:auto;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
    

<%--Item Modal--%>
<div class="modal fade" id="itemModal" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">ITEM CODE</h4>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
                <div id="itemGrid" class="ag-theme-balham" style="height:500px;width:auto;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<%--Unit Modal--%>
<div class="modal fade" id="unitModal" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">UNIT CODE</h4>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
                <div id="unitGrid" class="ag-theme-balham" style="height:500px;width:auto;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<%--Amount Modal--%>
<div class="modal fade" id="amountModal" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">AMOUNT</h4>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
                <div style="width:auto; text-align:left">
                    <label style='font-size: 20px; margin-right: 10px'>견적수량</label>
                    <input type='text' id='estimateAmountBox' autocomplete="off"/><br>
                    <label for='unitPriceOfEstimateBox' style='font-size: 20px; margin-right: 10px'>견적단가</label>
                    <input type='text' id='unitPriceOfEstimateBox' autocomplete="off"/><br>
                    <label for='sumPriceOfEstimateBox' style='font-size: 20px; margin-right: 30px'>합계액  </label>
                    <input type="text" id='sumPriceOfEstimateBox' autocomplete="off"></input>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" id ="amountSave" class="btn btn-default" data-dismiss="modal">Save</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
    <script>
    
    
       
        
  //Grid 버튼      
        const myGrid = document.querySelector("#myGrid");
        const myGrid2 = document.querySelector("#myGrid2");       
  //달력      
        const datepicker = document.querySelector('#datepicker'); //달력
        const fromDate = document.querySelector("#fromDate");
        const toDate = document.querySelector("#toDate");
  //수주      
        const contractSearchBtn = document.querySelector("#contractSearchButton");//수주조회버튼   
        const contractDetaillBtn = document.querySelector("#contractDetaillButton"); // 수주상세조회버튼   
        const pdfOpenBtn = document.querySelector("#pdfOpenButton");            // pdf출력
      

      
      // O DATEPICKER => dbClick 하면 할 수 있게끔
    function getDatePicker(paramFmt) {
        let _this = this;
        _this.fmt = "yyyy-mm-dd";
        console.log(_this);

        // function to act as a class
        function Datepicker() {
        }

        // gets called once before the renderer is used
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
            // Setting startDate and endDate
            console.log(paramFmt);
            let _startDate = datepicker.value;
            let _endDate = new Date(_startDate);
            let days = 14; // 유효 일자는 현재일자 + 14일
            if (paramFmt == "dueDateOfEstimate") {
                _startDate = new Date(_startDate)
                days = 9;
                _startDate.setTime(_startDate.getTime() + days * 86400000);
                let dd = _startDate.getDate();
                let mm = _startDate.getMonth() + 1; //January is 0!
                let yyyy = _startDate.getFullYear();
                _startDate = yyyy + '-' + mm + '-' + dd;
                console.log(_startDate);
                _endDate = new Date(_startDate);
                days = 19;
            }
            _endDate.setTime(_endDate.getTime() + days * 86400000);
            let dd = _endDate.getDate();
            let mm = _endDate.getMonth() + 1; //January is 0!
            let yyyy = _endDate.getFullYear();
            _endDate = yyyy + '-' + mm + '-' + dd;

            $(this.eInput).datepicker({
                dateFormat: _this.fmt,
                startDate: _startDate,
                endDate: _endDate,
            }).on('change', function () {
                estGridOptions.api.stopEditing();
                estDetailGridOptions.api.stopEditing();
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
            estGridOptions.api.stopEditing();
        };

        return Datepicker;
    }
 // o if customer modal hide, next cell
    $("#customerModal").on('hide.bs.modal', function () {
        estGridOptions.api.stopEditing();
        let rowNode = estGridOptions.api.getRowNode(datepicker.value);
        console.log("rowNode:" + rowNode);
        if (rowNode != undefined) { // rowNode가 없는데 거래처 코드 탐색시 에러
            setDataOnCustomerName();
        }
    });

    // o change customerName cell
    function setDataOnCustomerName() {
        let rowNode = estGridOptions.api.getRowNode(datepicker.value);
        let to = transferVar();
        console.log(to);
        rowNode.setDataValue("customerName", to.detailCodeName);
        rowNode.setDataValue("customerCode", to.detailCode);
        let newData = rowNode.data;
        rowNode.setData(newData);
        console.log(rowNode.data);
    }
      
    
  

        const contractInfoColumn = [
        
           {
                headerName: "수주일련번호", field: "contractNo", suppressSizeToFit: true, headerCheckboxSelection: false,
                headerCheckboxSelectionFilteredOnly: true, suppressRowClickSelection: true,
                checkboxSelection: true
            },
            { headerName: "견적일련번호", field: "estimateNo"},
            { headerName: '수주유형분류', field: 'contractTypeName' },
            { headerName: '거래처코드', field: 'customerCode', hide: true },
            { headerName: '거래처명', field: 'customerName', hide: true },
            { headerName: '견적일자', field: 'contractDate' },
            { headerName: '수주일자', field: 'contractDate' },
            { headerName: '수주요청자', field: 'contractRequester' },
            { headerName: '수주담당자명', field: 'empNameInCharge' },
            { headerName: '납품완료여부', field: 'deliveryCompletionStatus',   cellRenderer:(params) => {
                if (params.value == 'Y') {
                  return  "🟢";
                }
                return '❌';
            }  },
            { headerName: '비고', field: 'description' },
        ];
      
        
        let rowData = [];
        let contractInfoColumnRowNode;
        let contractInfoGridOptions = {
            columnDefs: contractInfoColumn,
            rowSelection: 'single',
            rowData: rowData,
            getRowNodeId: function (data) {
                return data.contractNo;
            },
            defaultColDef: {editable: false, resizable : true},
            overlayNoRowsTemplate: "조회된 견적 데이터가 없습니다.",
            onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                event.api.sizeColumnsToFit();
            },
            onGridSizeChanged: function (event) {
                event.api.sizeColumnsToFit();
            },
            onCellEditingStarted: (event) => {
                if (event != undefined) {
                    console.log("IN onRowSelected");
                    let rowNode = contractInfoGridOptions.api.getDisplayedRowAtIndex(event.rowIndex);
                    console.log(rowNode);
                    contractInfoColumnRowNode = rowNode;
          
                } 
            },
            getSelectedRowData() { 
                let selectedNodes = this.api.getSelectedNodes();
                let selectedData = selectedNodes.map(node => node.data);
                console.log(selectedNodes+"selectedNodes");
                console.log(selectedData+"selectedData");
                return selectedData;
            }
        }
        
//-------------------------------------수주조회 버튼--------------------------------------------//
     contractSearchBtn.addEventListener("click", () => {
            let isChecked = document.querySelector("#searchByDateRadio").checked;
            let dateApply = isChecked ? "searchByDate" : "searchByCustomer";
            contractInfoGridOptions.api.setRowData([]);
            let xhr = new XMLHttpRequest();
            xhr.open('GET', '${pageContext.request.contextPath}/logisales/contract/list' +
                "?method=searchContract"
                + "&startDate=" + fromDate.value
                + "&endDate=" + toDate.value
                /* + "&customerCode=" +  */
                + "&searchCondition=" + dateApply,
                true)
                console.log(fromDate.value);
                console.log(toDate.value);
            xhr.setRequestHeader('Accept', 'application/json');
            xhr.send();
            xhr.onreadystatechange = () => {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    let txt = xhr.responseText;
                    txt = JSON.parse(txt);
                    console.log(txt.gridRowJson);
                    let gridRowJson = txt.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
                    if (gridRowJson == "") {
                        swal({
                           icon: 'error',
                           text : "조회할 견적이 없습니다."
                        });
                        return;
                    }
                    contractInfoGridOptions.api.setRowData(txt.gridRowJson);
                }
            }
        });

        
      //-------------------------------------수주상세 조회--------------------------------------------//        
        
        //수주상세조회
        contractDetaillBtn.addEventListener("click", () => {
           let selectedNodes = contractInfoGridOptions.api.getSelectedNodes();
            if (selectedNodes == "") {
              Swal.fire({
                position: "top",
                icon: 'error',
                title: '체크 항목',
                text: '선택한 행이 없습니다.',
              })
              return;
            }
            console.log(selectedNodes[0].data);
            getRowIdValue = selectedNodes[0].data.contractNo;
            
            let xhr = new XMLHttpRequest();
            xhr.open('GET', '${pageContext.request.contextPath}/logisales/contractdetail/list' +
                "?method=searchContractDetail"
                + "&contractNo=" + getRowIdValue,
                true)
            xhr.setRequestHeader('Accept', 'application/json');
            xhr.send();
            xhr.onreadystatechange = () => {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    let txt = xhr.responseText;
                    txt = JSON.parse(txt);
                    console.log(txt.gridRowJson);
                    let gridRowJson = txt.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
                    if (gridRowJson == "") {
                        swal({
                           position: "top",
                           icon: 'error',
                           title: '체크 항목',
                           text: '조회할 견적상세가 없습니다.',
                        });
                        return;
                    }
                    contractDetailInfoGridOptions.api.setRowData(txt.gridRowJson);
                }
            }
        })        
        
        
        
        
 //-----------------------------------------PDF 출력 저장버튼------------------------------------//      
        //PDF iReport  
        pdfOpenBtn.addEventListener("click", () => {
           let selectedNodes = contractInfoGridOptions.api.getSelectedNodes();
           console.log(selectedNodes);
            if (selectedNodes == "") {
                   Swal({
                     position: "top",
                     icon: 'error',
                     title: '체크 항목',
                     text: '선택한 행이 없습니다.',
                   })
                   return;
                   }
            let getRowIdValue = selectedNodes[0].id;
            console.log("test");
            console.log(getRowIdValue);
                    
           window.open("${pageContext.request.contextPath}/compinfo/report/contract?method=contractReport&orderDraftNo=" + getRowIdValue,"window", "width=1600, height=1000" );
        });
  
//-----------------------------------------수주상세 그리드------------------------------------//   
       
        // 수주상세 grid           
        const contractDetailGridColumn = [
        
           {
                headerName: "수주상세일련번호", field: "contractDetailNo", width: 300, 
                suppressRowClickSelection: true
            },
            { headerName: '취합발주번호', field: 'mrpGatheringNo',   cellRenderer:(params) => {
                if (params.value!=null) {
                  return params.value;
                }
                return '-';
            } },
            { headerName: '수주일련번호', field: 'contractNo', hide: true },
            { headerName: "품목코드", field: "itemCode", width: 300, hide: true },
            { headerName: '품목명', width: 300, field: 'itemName' },
            { headerName: '단위', field: 'unitOfContract', hide: true },
            { headerName: '납기일', field: 'dueDateOfContract'},
            { headerName: '견적수량', field: 'estimateAmount' },
            { headerName: '재고사용량', field: 'stockAmountUse' },
            { headerName: '제작필요수량', field: 'productionRequirement' },
            { headerName: '견적단가', field: 'unitPriceOfContract' },
            { headerName: '합계액', field: 'sumPriceOfContract' },
            { headerName: '납품가능여부', field: 'operationCompletedStatus' ,   cellRenderer:(params) => {
                if (params.value == 'Y') {
                    params.node.selectable = false;
                  return params.value = "🟢";
                }
                return '❌';
            }},
            { headerName: '납품완료여부', field: 'deliveryCompletionStatus',   cellRenderer:(params) => {
                if (params.value == 'Y') {
                    params.node.selectable = false;
                  return params.value = "🟢";
                }
                return '❌';
            } },
            { headerName: '비고', field: 'description' }
        ];   
        let itemRowNode;
        let detailRowData = [];
        let contractDetailInfoGridOptions = {
            columnDefs: contractDetailGridColumn,
            rowSelection: 'single',
            rowData: detailRowData,
            getRowNodeId: function (data) {
                return data.contractDetailNo;
            },
            defaultColDef: {editable: false, resizable : true},
            overlayNoRowsTemplate: "조회된 수주 데이터가 없습니다.",
            onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
                event.api.sizeColumnsToFit();
            },
            onGridSizeChanged: function (event) {
                event.api.sizeColumnsToFit();
            },
            onCellEditingStarted: (event) => {
                if (event != undefined) {
                    console.log("IN onRowSelected");
                    let rowNode = estimuloInfoGridOptions.api.getDisplayedRowAtIndex(event.rowIndex);
                    console.log(rowNode);
                    itemRowNode = rowNode;
                }
            },
            getSelectedRowData() { 
                let selectedNodes = this.api.getSelectedNodes();
                let selectedData = selectedNodes.map(node => node.data);
                console.log(selectedNodes+"selectedNodes");
                console.log(selectedData+"selectedData");
                return selectedData;
            }
          
        }
       
        document.addEventListener('DOMContentLoaded', () => {
            new agGrid.Grid(myGrid, contractInfoGridOptions);
            new agGrid.Grid(myGrid2, contractDetailInfoGridOptions);
        });

    </script>
</body>

</html>