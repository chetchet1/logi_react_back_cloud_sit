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
        <h5>📅 공정계획 등록</h5>
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
        <button id="contractCandidateSearchButton">수주상세조회</button>
        <button class="search" id="createProcessPlan" data-toggle="modal"
                data-target="#amountModal">공정계획생성</button>
        <%--                <button  id="amountList" >공정계획생성--%>
        <%--                </button>--%>


        &nbsp;&nbsp;<button id="registerProcessPlanButton"  style="background-color:#F15F5F" >공정계획등록</button>
    </div>
</article>
<article class="contractMpsGrid">
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="margin-bottom: 20px; height:15vh; width:auto; text-align: center;"></div>
    </div>
</article>
<!-- div>
    <h5>📷 공정 계획</h5>
</div> -->

<article class="salesMpsGrid">
    <div align="center" class="ss">
        <div id="myGrid2" class="ag-theme-balham" style="height:30vh;width:auto;"></div>
    </div>
</article>


<%--===========================================수량 모달창===========================================--%>
<div class="modal fade" id="amountModal" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">공정계획</h5>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
                <div style="width:auto; text-align:left">
                    <label style='font-size: 20px; margin-right: 10px'>견적수량</label>
                    <input type='text' id='estimateAmountBox'  autocomplete="off"/><br>
                    <label for='stockAmountUseBox' style='font-size: 20px; margin-right: 10px'>재고사용량</label>
                    <input type='text' id='stockAmountUseBox'  autocomplete="off"/><br>
                    <label for='RequirementAmountBox' style='font-size: 20px; margin-right: 10px'>필요생산량</label>
                    <input type='text' id='RequirementAmountBox' autocomplete="off"/><br>

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
    const myGrid = document.querySelector("#myGrid");
    const myGrid2 = document.querySelector("#myGrid2");
    const searchByDateRadio = document.querySelector("#searchByDateRadio");
    const startDatePicker = document.querySelector("#fromDate");
    const endDatePicker = document.querySelector("#toDate");
    const registerProcessPlanButton = document.querySelector("#registerProcessPlanButton");
    // 위아래 공통으로 사용하는 column
    // let itemName;
    // let itemCode;
    // let estimateAmount;
    // let stockAount;
    // O customerList Grid
    let mpsColumn = [
        {
            headerName: "수주상세일련번호", field: "contractDetailNo", suppressSizeToFit: true, headerCheckboxSelection: true,
            headerCheckboxSelectionFilteredOnly: true,
            checkboxSelection: true
        },
        {headerName: "수주유형", field: "contractType"},
        {headerName: "계획구분", field: "planClassification", hide: true},
        {headerName: "수주일자", field: "contractDate", hide: true},
        {headerName: "견적수량", field: "estimateAmount"},
        {headerName: "기존재고량", field: "stockAmountUse"},
        {headerName: "제작수량", field: "productionRequirement"},
        {
            headerName: "계획일자", field: "mpsPlanDate", hide: true, editable: true, cellRenderer: function (params) {
                if (params.value == null) {
                    params.value = "";
                }
                return '📅 ' + params.value;
            }, cellEditor: 'datePicker1'
        },
        {
            headerName: "출하예정일", field: "scheduledEndDate", hide: true, editable: true, cellRenderer: function (params) {
                if (params.value == null) {
                    params.value = "";
                }
                return '📅 ' + params.value;
            }, cellEditor: 'datePicker2'
        },
        {headerName: "납기일", field: "dueDateOfContract", hide: true, cellRenderer: function (params) {
                if (params.value == null) {
                    params.value = "";
                }
                return '📅 ' + params.value;
            },},
        {headerName: "품목코드", field: "itemCode"},
        {headerName: "품목명", field: "itemName"},
        {headerName: "단위", field: "unitOfContract"},
        {headerName: "비고", field: "description", editable: true, hide: true},
    ];
    // ------------------------------------------공정계획 칼럼리스트-------------------------------------------
    let processPlanColumn = [

        {headerName: "수주상세일련번호", field: "contractDetailNo", suppressSizeToFit: true, headerCheckboxSelection: true,
            headerCheckboxSelectionFilteredOnly: true,
            checkboxSelection: true},
        {headerName: "품목명", field: "itemName"},
        {headerName: "품목코드", field: "itemCode"},
        {headerName: "수주유형", field: "contractType"},
        {headerName: "재고량", field: "stockAmount", hide: true},
        {headerName: "견적수량", field: "estimateAmount"},
        {headerName: "재고사용량", field: "stockAmountUse"},
        {headerName: "필요생산량", field: "RequirementAmount"},
        // {headerName: "재고보충량", field: "stockAmountPlus"},
        // {headerName: "총생산량", field: "productionRequirement"},
        {headerName: "MPS", field: "MPS"},
        {headerName: "납품가능", field: "Release"},
        {headerName: "비고", field: "description", editable: true, hide: true},
    ];
    let itemRowNode;
    let rowData2=[];
    let processPlaneGridOptions = {
        defaultColDef: {
            flex: 1,
            minWidth: 100,
            resizable: true,
        },
        rowData: rowData2,
        columnDefs: processPlanColumn,
        rowSelection: 'single',
        //
        //
        // defaultColDef: {editable: false, resizable : true},
        overlayNoRowsTemplate: "공정계획 가능한 수주가 없습니다.",
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
        onCellDoubleClicked: (event) => {
            if (event != undefined) {
                console.log("IN onRowSelected");
                let rowNode = estDetailGridOptions.api.getDisplayedRowAtIndex(event.rowIndex);  //getDisplayedRowAtIndex: 보이는 줄의 인덱스 얻기
                console.log(rowNode);
                itemRowNode = rowNode;
            }
            if (event.colDef.field == "stockAmountUse" || event.colDef.field == "stockAmountPlus") { //     || A OR B
                amountList.click();
            }
        },
        getSelectedRowData() {
            let selectedNodes = this.api.getSelectedNodes();
            let selectedData = selectedNodes.map(node => node.data);
            return selectedData;
        }
    }
    //----------------------------------------------------------------------
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
        rowSelection: 'single',
        rowData: rowData,
        getRowNodeId: function (data) {
            return data.contractDetailNo;
        },
        defaultColDef: {editable: false, resizable : true},
        overlayNoRowsTemplate: "조회된 수주가 없습니다.",
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

    //ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ MPS 등록가능 수주상세 조회ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
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
        xhr.open('GET', "${pageContext.request.contextPath}/production/mps/contractdetail-processplanavailable"
            + "?method=searchContractDetailListInProcessPlanAvailable"
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
                    swal.fire("공정계획 등록가능 수주가 없습니다.");
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

    // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 공정계획 생성버튼 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    const createProcessPlanbtn = document.querySelector("#createProcessPlan");
    // 위에서 채크된 row의 값들을 받아오고 재고량은 모달창 띄워서 가져오게
    // //*************여기부터 다시**********************
    createProcessPlanbtn.addEventListener("click", () => {

        (mpsGridOptions.getSelectedRowData()).forEach((val)=>{  //val = 선택한 row하나

                // modal창에 값전달
                document.querySelector("#estimateAmountBox").value=val.estimateAmount;  // 견적수량
                document.querySelector("#stockAmountUseBox").value=val.stockAmountUse; // 위에서의 stockAmountUse
                console.log()

            }
        );
    });
    // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

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
    $("#amountModal").on('show.bs.modal', function () {

        let firstSum = parseInt($('#estimateAmountBox').val()) - parseInt($('#stockAmountUseBox').val());
        let stuckAmount = parseInt($('#stockAmountUseBox').val());
        $('#RequirementAmountBox').val(firstSum);
        $('#stockAmountUseBox').on("keyup", function() {

//   if (mpsGridOptions.getRowNodeId("stockAmount") >= parseInt($('#stockAmountUseBox').val())) {
            if (stuckAmount < parseInt($('#stockAmountUseBox').val())) {
                // 기존재고량보다 큰 값을 재고 사용량에 입력했을 때
                $('#stockAmountUseBox').val(stuckAmount);
            }
            if (parseInt($('#estimateAmountBox').val()) < parseInt($('#stockAmountUseBox').val())) {
                // 견적수량보다 큰값을 재고사용량에 입력했을 때
                $('#stockAmountUseBox').val($('#estimateAmountBox').val());
            }

            let sum1 = parseInt($('#estimateAmountBox').val()) - parseInt($('#stockAmountUseBox').val())
            $('#RequirementAmountBox').val(sum1)
        });

    });

    /* $("#amountModal").on('shown.bs.modal', function () {  // 실행하고자 하는 jQuery 코드
      $('#stockAmountUseBox').focus(); //포커스를 얻었을 때 어떤 행위하기=> 견적수량 칸을 더블클릭해서 모달창이 띄워졌으면 바로 견적수량에 포커스가 위치하게 된다.
     })*/




    // -------------------------------모달창 save버튼-------------------------------------------

    document.querySelector("#amountSave").addEventListener("click", () => {  //modal창 밑에 있는 Save에 걸리는 이벤트


        console.log(mpsGridOptions.getSelectedRowData());
        let row = [];
        processPlaneGridOptions.api.setRowData(row);  // 하나만 선택되게 초기화


        (mpsGridOptions.getSelectedRowData()).forEach((val)=>{  //val = 선택한 row하나
                // 모달창의 초기수량
                console.log($('#stockAmountUseBox').val());
                console.log($('#RequirementAmountBox').val());


                row = { // 버튼을 누르자마자 빈 그리드가 위치 되어지기 때문에 다 공백처리로 빈 값을 넣어놓는다고 볼 수 있다
                    contractDetailNo:val.contractDetailNo,
                    itemName: val.itemName,
                    itemCode: val.itemCode,
                    contractType: val.contractType,
                    stockAmount: "",
                    estimateAmount: "",
                    stockAmountUse: "",
                    RequirementAmount: "",
                    stockAmountPlus: "",
                    productionRequirement: "",
                    MPS: "X",
                    Release: "불가능",
                    description: ""
                };
                // modal창에 값전달

                console.log("견적수량 : "+val.estimateAmount);
                console.log("재고사용량 : "+val.estimateAmount);
                row.stockAmountUse= $('#stockAmountUseBox').val(),
                    row.RequirementAmount= $('#RequirementAmountBox').val(),
                    console.log(val);
                console.log(val.contractNo);
                console.log(itemRowNode);
                // row.itemName=val.itemName;
                // row.itemCode=val.itemCode;
                //row.stockAmountUse=val.stockAmountUse;
                row.estimateAmount=val.estimateAmount;
                if(row.stockAmountUse==val.estimateAmount){
                    row.Release="가능";
                }
                if($('#RequirementAmountBox').val()>0){
                    row.MPS="O";
                }
                processPlaneGridOptions.api.updateRowData({add: [row]});  // 여기에 다가 위의 변수들을 넣어준다. 하지만 이 상태에서 견적상세등록 칸에 ag-Grid가 들어가는 건 아니다.
            }
        );

    })
    registerProcessPlanButton.addEventListener("click", () => {
        //입력받은 재고사용량가지고 DB로 가자

        let selectedNodes = processPlaneGridOptions.api.getSelectedNodes();
        // o No seleted Nodes
        if (selectedNodes == "") {
            Swal.fire({
                position: "top",
                icon: 'error',
                title: '체크 항목',
                text: '선택된 공정계획이 없습니다.',
            })
            return;
        }

        let contractDetailNo=[]; // 수주상세 일련번호
        let contractType=[]; //수주유형
        let stockAmountUse=[]; // 재고사용량

        let now = new Date();
        let today = now.getFullYear() + "-" + (now.getMonth() +1 ) + "-" +  now.getDate();

        selectedNodes.map(selectedData => {//[1,2,3]
            contractDetailNo.push(selectedData.data.contractDetailNo);
            contractType.push(selectedData.data.contractType);
            stockAmountUse.push(selectedData.data.stockAmountUse);

            console.log(selectedData.data.contractDetailNo);
            console.log(selectedData.data.stockAmountUse);


        });

        let resultArray={"contractDetailNo":contractDetailNo ,"contractType":contractType,"stockAmountUse":stockAmountUse};

        resultArray=JSON.stringify(resultArray);

        console.log(resultArray);
        Swal.fire({
            title: '공정계획 등록',
            text:  contractDetailNo + "를 등록하시겠습니까?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            cancelButtonText: '취소',
            confirmButtonText: '확인',
        }).then( (result) => {
            if (result.isConfirmed) {
                let xhr = new XMLHttpRequest();

                //let today = now.getFullYear() + "-" + (now.getMonth() +1 ) + "-" +  now.getDate();
                xhr.open('POST', "${pageContext.request.contextPath}/logisales/processplan/new?"
                    + "method=processPlan"
                    + "&batchList=" + encodeURI(resultArray),
                    true);
                xhr.setRequestHeader('Accept', 'application/json');
                xhr.send();
                xhr.onreadystatechange = () => {
                    if (xhr.readyState == 4 && xhr.status == 200) {

                        // 데이터 확인
                        let txt = xhr.responseText;
                        txt = JSON.parse(txt);

                        if (txt.errorCode < 0) {
                            Swal.fire("오류", txt.errorMsg, "error");
                            return;
                        }
                        // 초기화
                        mpsGridOptions.api.setRowData([]);
                        processPlaneGridOptions.api.setRowData([]);
                        //Swal.fire("data",,"success")
                        // console.log(txt.gridRowJson)
                        // let conDNStr="";
                        // const conDetailList = Object.values(txt.gridRowJson);//어레이라이크를 배열형태로 바꿔줌
                        // console.log(conDetailList)
                        // for(let i=0;i<conDetailList.length;i++){
                        //     if(conDetailList[i]!=undefined){
                        //         conDNStr+=conDetailList[i].contractDetailNo;
                        //         conDNStr+="<br>"
                        //         console.log(conDetailList[i].contractDetailNo);
                        //     }
                        // }
                        // console.log(conDNStr);
                        // console.log("수주 완료");
                        // let resultMsg =
                        //     "<h5>< 공정계획 등록 내역 ></h5><br>"
                        //     + txt.errorMsg+"<br>"
                        //     +"수주 상세 번호 :"
                        //     +   conDNStr
                        //     + "<br>위와 같이 작업이 처리되었습니다";
                        Swal.fire({
                            title: "공정등록이 완료되었습니다.",
                            html:"수주 상세 코드 : " + contractDetailNo,
                            icon: "success",
                        });
                    }
                };
            }})
    });

    // O setup the grid after the page has finished loading
    document.addEventListener('DOMContentLoaded', () => {
        new agGrid.Grid(myGrid, mpsGridOptions);
        new agGrid.Grid(myGrid2, processPlaneGridOptions);
    })

</script>
</body>
</html>