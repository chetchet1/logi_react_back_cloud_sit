'use strict';
// O Customer, Item, to 변수
let jsonData;

let listGrid = document.querySelector('#listGrid');

let mpsGrid = document.querySelector('#mpsGrid');
let mrpGrid = document.querySelector("#mrpGrid");
let mrpGatheringGrid = document.querySelector("#mrpGatheringGrid");
let orderGrid = document.querySelector("#orderGrid");
let warehousingGrid = document.querySelector("#warehousingGrid");
let workOrderSimulationGrid = document.querySelector("#workOrderSimulationGrid");
let workSiteSituationGrid = document.querySelector("#workSiteSituationGrid");
let to;                      // 전달 변수
let transferVar = () => to;  // 전달 함수
let isElement = []; 

// O Common GridOptions
const gridOptions = {
    defaultColDef: {editable: false},
    onGridReady: function (event) {
        event.api.sizeColumnsToFit();
    },
    onGridSizeChanged: function (event) {
        event.api.sizeColumnsToFit();
    },
    rowSelection: 'multiple',
};

// O Get ajax Data  FROM (TABLE) DETAIL_CODE
const getListData = (divisionCodeNo) => {
    let xhr = new XMLHttpRequest();
    xhr.open('POST',
        '/compinfo/codedetail2/list?method=findDetailCodeList&divisionCodeNo='+divisionCodeNo,
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            jsonData = JSON.parse(txt);
            console.log("**********************");
            console.log(jsonData);
            if (jsonData.errorCode != 1) {
            	console.log('데이터를 불러드리는데 오류가 발생했습니다.');
                swal({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            }
			setListModal();
        }
    };
};

// O Setting Customer MODAL Grid FROM ajax data 
/*    if (!isElement.includes(section)) {
        isElement.push(section);
    } else {
        return;
    } // 요소가 있으면 나오기!! */
const setListModal = () => {   

    let listGridOptions = gridOptions;
    listGridOptions.columnDefs = [
        {headerName: '상세코드번호', field: 'detailCode', width: 80, cellStyle: {'textAlign': 'center'},},
        {headerName: '상세코드이름', field: 'detailCodeName', width: 80, cellStyle: {'textAlign': 'center'},},
        {headerName: '사용여부', field: 'codeUseCheck', width: 80, cellStyle: {'textAlign': 'center'}}];
    listGridOptions.onRowDoubleClicked = (event) => {
		console.log(event);
        console.log('event.data.detailCodeName:'+event.data);
        to = event.data;
        let closeList = document.querySelectorAll('.close');
        for (let value of closeList) {
            value.click();
        }

		let selectedRows=contractGridOptions.api.getSelectedNodes();
		console.log(selectedRows);
		if(selectedRows!=undefined){
			selectedRows.map(selectedData =>{
				selectedData.data.contractType=to.detailCode;
				selectedData.data.contractTypeName=to.detailCodeName;
			})
		}
		contractGridOptions.api.redrawRows(selectedRows);
    };
    console.log(listGrid);
	if(listGrid!=null){
		listGrid.innerHTML="";
    	new agGrid.Grid(listGrid, listGridOptions);
		listGridOptions.api.setRowData(jsonData.detailCodeList); 
	}
};
// O Get StandardUnitPrice
const getStandardUnitPrice = (itemCode, unit) => {
    console.log(itemCode);
    let xhr = new XMLHttpRequest();
    // BOX
    xhr.open('GET',
        `/logiinfo/item/standardunitprice?method=getStandardUnitPrice&itemCode=${itemCode}`,
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText
            jsonData = JSON.parse(txt);
            console.log(jsonData);
            document.querySelector("#unitPriceOfEstimateBox").value = jsonData.gridRowJson;
            if (jsonData.errorCode != 1) {
                swal({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            }
        }
    };
};
// jsonData.gridRowJson;
const setMpsModal = () => {
    let mpsGridOptions = gridOptions;
    mpsGridOptions.columnDefs = [
        {headerName: '주생산계획번호', field: 'mpsNo', width: 450, cellStyle: {'textAlign': 'center'}},
        {headerName: '계획구분', field: 'mpsPlanClassification', width: 250, cellStyle: {'textAlign': 'center'},},
        {headerName: '일련번호(수주/판매)', field: 'no', width: 500, cellStyle: {'textAlign': 'center'}},
        {headerName: '수주상세일련번호', field: 'contractDetailNo', cellStyle: {'textAlign': 'center'}, hide: true},
        {headerName: '판매계획일련번호', field: 'salesPlanNo', cellStyle: {'textAlign': 'center'}, hide: true},
        {headerName: '품목코드', field: 'itemCode', width: 350, cellStyle: {'textAlign': 'center'}},
        {headerName: '품목명', field: 'itemName', width: 450, cellStyle: {'textAlign': 'center'}},
        {headerName: '단위', field: 'unitOfMps', cellStyle: {'textAlign': 'center'}},
        {headerName: '계획일자', field: 'mpsPlanDate', width: 350, cellStyle: {'textAlign': 'center'}},
        {headerName: '계획수량', field: 'mpsPlanAmount', cellStyle: {'textAlign': 'center'}},
        {headerName: '납기일', field: 'dueDateOfMps', width: 350, cellStyle: {'textAlign': 'center'}},
        {headerName: '예정마감일자', field: 'scheduledEndDate', width: 350, cellStyle: {'textAlign': 'center'}},
        {headerName: 'MRP 적용상태', field: 'mrpApplyStatus', width: 350, cellStyle: {'textAlign': 'center'}, cellRenderer:(params) => {
                if (params.value == 'Y') {
                    params.node.selectable = false;
                  return params.value = "🟢";
                }
                return '❌';
            }},
        {headerName: '비고', field: 'description', cellStyle: {'textAlign': 'center'}},
    ];
    mpsGridOptions.onGridReady = function () {
        for (let i = 0; i < jsonData.gridRowJson.length; i++) {
            jsonData.gridRowJson[i].no = jsonData.gridRowJson[i].mpsPlanClassification == "수주상세"
                ? jsonData.gridRowJson[i].contractDetailNo : jsonData.gridRowJson[i].salesPlanNo;
        }
        mpsGridOptions.api.setRowData(jsonData.gridRowJson);
    };

    new agGrid.Grid(mpsGrid, mpsGridOptions);
}
// O mps modal
const getMpsList = () => {
    let fromDate = document.querySelector("#fromDate");
    let toDate = document.querySelector("#toDate");
    let xhr = new XMLHttpRequest();
    xhr.open('GET', '/production/mps/list' +
        "?method=searchMpsInfo"
        + "&startDate=" + fromDate.value
        + "&endDate=" + toDate.value
        + "&includeMrpApply=includeMrpApply",  // mrp적용된 데이터도 포함 
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            console.log(txt);
            jsonData = JSON.parse(txt);
            console.log(jsonData);
            if (jsonData.errorCode != 1) {
                swal({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            }
        }
    }
}
// O MRP SIMULATION
// o set Mrp modal
let mrpGridOptions;
const setMrpModal = () => {
    mrpGridOptions = gridOptions;
    mrpGridOptions.columnDefs = [
        {headerName: '주생산계획번호', field: 'mpsNo', width: 450, cellStyle: {'textAlign': 'center'}},
        {headerName: 'BOM 번호', field: 'bomNo', width: 450, cellStyle: {'textAlign': 'center'},},
        {headerName: '품목구분', field: 'itemClassification', width: 300, cellStyle: {'textAlign': 'center'}},
        {headerName: '품목코드', field: 'itemCode', width: 300, cellStyle: {'textAlign': 'center'}},
        {headerName: '품목명', field: 'itemName', width: 500, cellStyle: {'textAlign': 'center'}},
        {headerName: '발주/작업지시시작기한', field: 'orderDate', width: 450, cellStyle: {'textAlign': 'center'}, editable: true},
        {
            headerName: '발주/작업지시완료기한',
            field: 'requiredDate',
            width: 450,
            cellStyle: {'textAlign': 'center'},
            editable: true
        },
        {headerName: '계획수량', field: 'planAmount', width: 350, cellStyle: {'textAlign': 'center'}},
        {headerName: '누적손실율', field: 'totalLossRate', width: 350, cellStyle: {'textAlign': 'center'}},
        {headerName: '계산수량', field: 'caculatedAmount', width: 350, cellStyle: {'textAlign': 'center'}},
        {headerName: '필요수량', field: 'requiredAmount', width: 350, cellStyle: {'textAlign': 'center'}},
        {headerName: '단위', field: 'unitOfMrp', width: 350, cellStyle: {'textAlign': 'center'}},
    ];
    new agGrid.Grid(mrpGrid, mrpGridOptions);
}
// o get Mrp data
let mpsRowNodes;
let mpsNoList;
const getMrpList = (mpsRowNode) => {
    mrpGridOptions.api.setRowData([]);
    let xhr = new XMLHttpRequest();
	mpsRowNodes=mpsRowNode;
	mpsNoList = [];
	console.log(mpsRowNode);
	for(let i=0;i<mpsRowNode.length;i++){
		mpsNoList.push(mpsRowNode[i].data.mpsNo);
	}
    console.log(mpsNoList);
    xhr.open('GET', '/production/mrp/open' +
        "?method=openMrp"
        + "&mpsNoList=" + encodeURI(JSON.stringify(mpsNoList)),
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            jsonData = JSON.parse(txt);
            console.log(jsonData);
            mrpGridOptions.api.updateRowData({add: jsonData.gridRowJson});
            if (jsonData.errorCode != 0) {
                Swal.fire({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            }
        }
    }
}
// do registerMrp
const registerMrp = (mrpDate) => {  // mrp등록 (소요량 전개 일자)
    let xhr = new XMLHttpRequest();
    let batchList = JSON.stringify(jsonData.gridRowJson);  // 모의 전개 할때, MRP 모의전개 정보 담김  "[{},{}..]"
	console.log(mpsNoList);
    xhr.open('POST', '/production/mrp' +
        "?method=registerMrp"
        + "&batchList=" + encodeURI(JSON.stringify(mpsNoList))
        + "&mrpRegisterDate=" + mrpDate,
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            txt = JSON.parse(txt);
			console.log(txt);
			console.log("위는 txt의 값");
			console.log(txt.result);
			console.log("위는 txt.result의 값");
			console.log(txt.result[0].firstMrpNo);
			console.log("위는 txt.result.firstMrpNo의 값");
            let resultMsg =
                `< 소요량전개  => 소요량취합 등록 내역 ><br>`
                + (`소요량취합 일련번호 : <br>`
                + txt.result[0].firstMrpNo + ` 부터 ` + txt.result[0].lastMrpNo + ` 까지 <br>
                     총 ` + (txt.result[0].length-1) + `건 등록 완료.<br>`) + `<br>
                     위와 같이 작업이 처리되었습니다.`;
            console.log(mpsRowNodes);
			for(let i=0;i<mpsRowNodes.length;i++){
            	mpsRowNodes[i].setDataValue("mrpApplyStatus", 'Y'); 
			}
            if (jsonData.errorCode != 0) {
                Swal.fire({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            } else {
                Swal.fire("성공", resultMsg, "success");
                $('#mrpModal').modal('hide');
            }
        }
    }
}
// O MRP GATHERING
// o set MrpGathering
let mrpGatheringGridOptions;
const setMrpGatheringModal = () => {
    mrpGatheringGridOptions = gridOptions;
    mrpGatheringGridOptions.columnDefs = [
        {headerName: "구매 및 생산여부", field: "orderOrProductionStatus", cellStyle: {'textAlign': 'center'}},
        {headerName: "품목코드", field: "itemCode", cellStyle: {'textAlign': 'center'}},
        {headerName: '품목명', field: 'itemName', cellStyle: {'textAlign': 'center'}},
        {headerName: '단위', field: 'unitOfMrpGathering', cellStyle: {'textAlign': 'center'}},
        {
            headerName: '발주/작업지시시작기한',
            field: 'claimDate',
            cellStyle: {'textAlign': 'center'},
            cellRenderer: function (params) {
                if (params.value == null) {
                    params.value = "";
                }
                return '📅 ' + params.value;
            }
        },
        {
            headerName: '발주/작업지시완료기한',
            field: 'dueDate',
            cellStyle: {'textAlign': 'center'},
            cellRenderer: function (params) {
                if (params.value == null) {
                    params.value = "";
                }
                return '📅 ' + params.value;
            }
        },
        {headerName: '필요수량', field: 'necessaryAmount', cellStyle: {'textAlign': 'center'}}
    ];
    mrpGatheringGridOptions.getRowStyle = (param) => {
        if (param.data.orderOrProductionStatus != "구매") {
            return {'font-weight': 'bold', background: '#b1b5cc'};
        }
    }
    new agGrid.Grid(mrpGatheringGrid, mrpGatheringGridOptions);
}
// o get MrpGathering Data
const getMrpGatheringModal = (mrpNoList) => {  // 소요량취합결과 데이터를 받아와 그리드에 세팅 
    mrpGatheringGridOptions.api.setRowData([]);
    let xhr = new XMLHttpRequest();
    mrpNoList = JSON.stringify(mrpNoList);
    xhr.open('GET', '/production/mrp/gathering-list' +
        "?method=getMrpGatheringList"
        + "&mrpNoList=" + encodeURI(mrpNoList),  // 소요량취합되지 않은 mrp리스트를 보내고, 그들을 취합한다. 
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            jsonData = JSON.parse(txt);
            // todo ... 왜 mrpGatheringNo, mrpGatheringStatus, mrpTOList 넘어오는거지?
            for (let objcet of jsonData.gridRowJson) {   // json의 해당 키를 삭제한다?
                delete objcet.mrpGatheringNo;
                delete objcet.mrpGatheringStatus;
                delete objcet.mrpTOList;
            }
            console.log(jsonData);
            mrpGatheringGridOptions.api.updateRowData({add: jsonData.gridRowJson});
            if (jsonData.errorCode < 0) {
                Swal.fire({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            }
        }
    }
}
const registerMrpGathering = (mrpGatheringDate, mrpNoList, mrpNoAndItemCodeList) => {
    let xhr = new XMLHttpRequest();
    //let mrpGatheringList = JSON.stringify(jsonData.gridRowJson); // 소요량취합결과 데이터 
    mrpNoList = JSON.stringify(mrpNoList); // 소요량취합되지 않은 mrpno 목록
    mrpNoAndItemCodeList = JSON.stringify(mrpNoAndItemCodeList); // 소요량취합되지 않은 mrpno : itemCode
    xhr.open('POST', '/production/mrp/gathering' +
        "?method=registerMrpGathering"
        + "&mrpGatheringRegisterDate=" + mrpGatheringDate
        + "&mrpNoList=" + encodeURI(mrpNoList)
        + "&mrpNoAndItemCodeList=" + encodeURI(mrpNoAndItemCodeList),
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            txt = JSON.parse(txt);
			let t1 = JSON.stringify(txt);
	console.log("여기::"+t1.result);
	console.log(txt);
            let resultMsg =
                "< 소요량전개 => 소요량취합 등록 내역 ><br/>"
                + ( ( txt.result.INSERT.length != 0 ) ?
                "소요량취합 일련번호 : " + txt.result.firstMrpGatheringNo +" 부터 </br>"
                + txt.result.lastMrpGatheringNo  +" 까지 </br>"
                + txt.result.INSERT.length + " 건 등록 완료. </br>"
                + "소요량전개 일련번호 : " + txt.result.changeMrpGatheringStatus
                + "</br> 의 소요량취합 적용상태  \"Y\" 로 변경 완료.": "없음" ) + "</br>"
                + "위와 같이 작업이 처리되었습니다.";
            mrpGatheringGridOptions.api.setRowData([]);
            if (txt.errorCode < 0) {
                Swal.fire({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            } else {
                Swal.fire("성공", resultMsg, "success");
            }
        }
    }
}
// O OrderDialog
let orderGridOptions;
const setOrderModal = () => {
    orderGridOptions = gridOptions;
    orderGridOptions.columnDefs = [
        {headerName: "품목코드", field: "itemCode", cellStyle: {'textAlign': 'center'}},
        {headerName: '품목명', field: 'itemName', cellStyle: {'textAlign': 'center'}},
        {headerName: '단위', field: 'unitOfMrp', cellStyle: {'textAlign': 'center'}},
        {headerName: '총필요량', field: 'requiredAmount',cellStyle:{'textAlign': 'center'}},
        {headerName: '사용가능재고량', field: 'stockAmount', cellStyle: {'textAlign': 'center'},},
        {headerName: '실제발주필요량', field: 'calculatedRequiredAmount', cellStyle: {'textAlign': 'center'}},
        {headerName: '단가', field: 'standardUnitPrice', cellStyle: {'textAlign': 'center'}},
        {headerName: '합계금액', field: 'sumPrice', cellStyle: {'textAlign': 'center'},valueFormatter: currencyFormatter},
    ];
	function currencyFormatter(params) {
        return formatNumber(params.value)+' ₩';
    }
	function formatNumber(number) {
        // this puts commas into the number eg 1000 goes to 1,000,
        // i pulled this from stack overflow, i have no idea how it works
        return Math.floor(number).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
    }
    new agGrid.Grid(orderGrid, orderGridOptions);
}
const getOrderModal = (mrpGatheringList) => {
    let xhr = new XMLHttpRequest();
    mrpGatheringList = JSON.stringify(mrpGatheringList);
    xhr.open('GET', '/purchase/order/dialog' +
        "?method=openOrderDialog"
        + "&mrpGatheringNoList=" + encodeURI(mrpGatheringList),
        true)
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            txt = JSON.parse(txt);
            orderGridOptions.api.setRowData([]);
            if (txt.errorCode < 0) {
                Swal.fire({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            }
            orderGridOptions.api.updateRowData({add: txt.gridRowJson});
        }
    }
}


// O Warehousing
let warehousingGridOptions;
const setWarehousingModal = () => {
    warehousingGridOptions = gridOptions;
    warehousingGridOptions.columnDefs = [
        {headerName: "발주번호", field: "orderNo", suppressSizeToFit: true, headerCheckboxSelection: true,
            headerCheckboxSelectionFilteredOnly: true,
            checkboxSelection: true},
        {headerName: "발주날짜", field: "orderDate", cellStyle: {'textAlign': 'center'}},
        {headerName: "상태", field: "orderInfoStatus", cellStyle: {'textAlign': 'center'}},
        {headerName: '발주구분', field: 'orderSort', cellStyle: {'textAlign': 'center'}},
        {headerName: '품목코드', field: 'itemCode', cellStyle: {'textAlign': 'center'}},
        {headerName: '품목명', field: 'itemName',cellStyle:{'textAlign': 'center'}},
        {headerName: '수량', field: 'orderAmount', cellStyle: {'textAlign': 'center'},},
        {headerName: '검사상태', field: 'inspectionStatus', cellStyle: {'textAlign': 'center'},cellRenderer: function (params) {
            if (params.value == "Y") {
                return params.value =  "🟢" ;
            }
            return '✖️' ; 
        }},
    ];
    warehousingGridOptions.getRowNodeId = (data) => {
        return data.orderNo;
    };
    new agGrid.Grid(warehousingGrid, warehousingGridOptions);
}
const getWarehousingModal = () => {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', '/purchase/order/delivery' +
        "?method=searchOrderInfoListOnDelivery",
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            warehousingGridOptions.api.setRowData([]);
            let txt = xhr.responseText;
            txt = JSON.parse(txt);
			console.log(txt);
            if (txt.errorCode < 0) {
                Swal.fire({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            }
            warehousingGridOptions.api.updateRowData({add: txt.gridRowJson});
        }
    }
}
// O WorkOrderSimulationModal
// o set WorkOrderSimulationModal
let workOrderSimulationGridOptions;
const setWorkOrderSimulationModal = () => {
    workOrderSimulationGridOptions = gridOptions;
    workOrderSimulationGridOptions.columnDefs = [
        
       // {headerName: "주생산계획번호", width: 500,field: "mpsNo", cellStyle: {'textAlign': 'center'}},
        {headerName: "소요량취합번호", width: 500,field: "mrpGatheringNo",cellStyle:{'textAlign': 'center'}},
		{headerName: "소요량전개번호", width: 500, field: "mrpNo", cellStyle: {'textAlign': 'center'}},
        {headerName: '품목분류', field: 'itemClassification', width: 300,cellStyle: {'textAlign': 'center'}},
        {headerName: '품목코드', field: 'itemCode', width: 400, cellStyle: {'textAlign': 'center'}},
        {headerName: '품목명', field: 'itemName',width: 550,cellStyle:{'textAlign': 'center'}},
        {headerName: '단위', field: 'unitOfMrp', width: 300,cellStyle: {'textAlign': 'center'},},
        {headerName: '재고량(투입예정재고)', field: 'inputAmount', width: 450,cellStyle: {'textAlign': 'center'},},
        {headerName: '재고소요/제작수량', field: 'requiredAmount', width: 400,cellStyle: {'textAlign': 'center'},},
        {headerName: '재고량(재고소요이후)', field: 'stockAfterWork', width: 500,cellStyle: {'textAlign': 'center'},},
        {headerName: '작업지시기한', field: 'orderDate', width: 400,cellStyle: {'textAlign': 'center'},},
        {headerName: '작업완료기한', field: 'requiredDate', width: 400,cellStyle: {'textAlign': 'center'},},
    ];
    workOrderSimulationGridOptions.getRowNodeId = (data) => {
        return data.requiredDate;
    };
    new agGrid.Grid(workOrderSimulationGrid, workOrderSimulationGridOptions);
}
// o get WorkOrderSimulationModal
const getWorkOrderSimulationModal = (mrpGatheringNoList,mrpNoList) => {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', '/quality/workorder/dialog'
        + "?method=showWorkOrderDialog"
        + "&mrpGatheringNoList=" + encodeURI(JSON.stringify(mrpGatheringNoList))
		+ "&mrpNoList=" + encodeURI(JSON.stringify(mrpNoList)),
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            txt = JSON.parse(txt);
	        workOrderSimulationGridOptions.api.setRowData([]);
            if (txt.errorCode < 0) {
                Swal.fire({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            }
            console.log('txt');
            console.log(txt);
            console.log(txt.result);
            workOrderSimulationGridOptions.api.updateRowData({add: txt.result});
        }
    }
}
// o set Worksite
let workSiteSimulationGridOptions;
const setWorkSiteModal = () => {
    workSiteSimulationGridOptions = gridOptions;
    workSiteSimulationGridOptions.columnDefs = [
        {headerName: "작업지시번호",  field: "workOrderNo", cellStyle: {'textAlign': 'center'}},
        //{headerName: "소요량전개번호",  field: "mrpNo", cellStyle: {'textAlign': 'center'}},
       // {headerName: "주생산계획번호",  field: "mpsNo", cellStyle: {'textAlign': 'center'}},
        {headerName: "작업장명",  field: "workSieteName", cellStyle: {'textAlign': 'center'}},
        {headerName: "제작품목분류",  field: "wdItem", cellStyle: {'textAlign': 'center'}},
        {headerName: "제작품목코드",  field: "parentItemCode", cellStyle: {'textAlign': 'center'}},
        {headerName: "제작품목명",  field: "parentItemName", cellStyle: {'textAlign': 'center'}},
        {headerName: "작업품목분류",  field: "itemClassIfication", cellStyle: {'textAlign': 'center'}},
        {headerName: "작업품목코드",  field: "itemCode", cellStyle: {'textAlign': 'center'}},
        {headerName: "작업품목명",  field: "itemName", cellStyle: {'textAlign': 'center'}},
        {headerName: "작업량",  field: "requiredAmount", cellStyle: {'textAlign': 'center'}},
    ];
    new agGrid.Grid(workSiteSituationGrid, workSiteSimulationGridOptions);
}
const getWorkSiteModal = (workSiteCourse, workOrderNo, itemClassIfication) => { // 검사항목,작업지시번호,품목분류
    console.log(workSiteCourse);
    console.log(workOrderNo);
    console.log(itemClassIfication);

    let xhr = new XMLHttpRequest();
    xhr.open('GET', '/quality/worksite/situation'
        + "?method=showWorkSiteSituation"
        + "&workSiteCourse=" + workSiteCourse
        + "&workOrderNo=" + workOrderNo
        + "&itemClassIfication=" + encodeURI(itemClassIfication),
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            txt = JSON.parse(txt);
            console.log('test');
            console.log(txt.gridRowJson);
            workSiteSimulationGridOptions.api.setRowData([]);
            if (txt.errorCode < 0) {
                Swal.fire({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return;
            }
            workSiteSimulationGridOptions.api.setRowData(txt.gridRowJson);
        }
    }
}

const getOSListData = (condition) => {
    let xhr = new XMLHttpRequest();
    xhr.open('GET',
        '/compinfo/customer/list'
 		+ "?method=searchCustomerList"
        + "&searchCondition=" + condition,
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            jsonData = JSON.parse(txt);
            console.log(jsonData);
            if (jsonData.errorCode != 1) {
            	console.log('데이터를 불러드리는데 오류가 발생했습니다.');
                swal({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: 'error',
                });
                return jsonData.gridRowJson;
            }
        }
    };
};
// O 68_아웃소싱 Setting Customer MODAL Grid FROM ajax data

const setOSListModal = () => {   
    let listGridOptions = gridOptions;
	listGridOptions.columnDefs = [
        {headerName: '거래처코드', field: 'customerCode', width: 80, cellStyle: {'textAlign': 'center'}},
        {headerName: '거래처이름', field: 'customerName', width: 80, cellStyle: {'textAlign': 'center'}},
        {headerName: '품목코드', field: 'itemCode', width: 80, cellStyle: {'textAlign': 'center'},},
        {headerName: '품목명', field: 'itemName', width: 80, cellStyle: {'textAlign': 'center'},},
        {headerName: '품목군', field: 'itemGroupName', width: 80, cellStyle: {'textAlign': 'center'}}];
    listGridOptions.onRowDoubleClicked = (event) => {
        console.log('event.data.detailCodeName:'+event.data);
        to = event.data;
		/*console.log(to);*/
        let closeAll = document.querySelectorAll('.close');
        for (let closeBT of closeAll) {
            closeBT.click();
        }
		let customerTxt = document.getElementById('customerTxt'); 		//추가된 부분(텍스트박스 설정)
		let cusHiddenBox = document.getElementById("customerCode");
		let itemTxt = document.getElementById('itemTxt');
		let itemHiddenBox = document.getElementById('itemCode');
		if($("#listModalTitle").text() == "CUSTOMER BY ITEM_GROUP"){
			customerTxt.value = to.customerName;
			cusHiddenBox.value = to.customerCode;
			itemTxt.value = to.itemName;
			itemHiddenBox.value = to.itemCode;
		}else{
			customerTxt.value = to.customerName;
			cusHiddenBox.value = to.customerCode;
			itemTxt.value = to.itemName;
			itemHiddenBox.value = to.itemCode;
		}
    }; 
	listGridOptions.onGridReady = function () {
    	listGridOptions.api.setRowData(jsonData.gridRowJson); 
    };
    listGrid.innerHTML="";
	new agGrid.Grid(listGrid, listGridOptions);   
};

const getLatLng = (wareHouseCodeNo) => {
   
    let xhr = new XMLHttpRequest();
    xhr.open('GET',
        '/compinfo/code/latlng?method=findLatLngList&wareHouseCodeNo='+wareHouseCodeNo,
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            jsonData = JSON.parse(txt);
            console.log("**********************");
            console.log("jsonData");
            console.log(jsonData);
            console.log("jsonData.detailCodeList");
            console.log(jsonData.detailCodeList);          
              let lat = Number(jsonData.detailCodeList[0].latitude);
              let lng = Number(jsonData.detailCodeList[0].longitude);
              
              console.log(lat);
              console.log(lng);
              
              interceptor(lat,lng);
            if (jsonData.errorCode != 1) {
               console.log('데이터를 불러드리는데 오류가 발생했습니다.');
                swal({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: "error",
                });
                return;
            }else{
            
         }   
         
        }
    };
};

const getItemImage = (itemGroupCodeNo) => {
   
    let xhr = new XMLHttpRequest();
    xhr.open('GET',
        '/compinfo/code/itemimage?method=findDetailImageList&itemGroupCodeNo='+itemGroupCodeNo,
        true);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.send();
    xhr.onreadystatechange = () => {
        if (xhr.readyState == 4 && xhr.status == 200) {
            let txt = xhr.responseText;
            jsonData = JSON.parse(txt);
            console.log("**********************");
            console.log("jsonData");
            console.log(jsonData);
            console.log("jsonData.detailCodeList");
            console.log(jsonData.detailCodeList);
            console.log("jsonData.detailCodeList.image");
            console.log(jsonData.detailCodeList[0].image);
            let imgRoute = jsonData.detailCodeList[0].image;
            let www = jsonData.detailCodeList[0].explanation;
            if (jsonData.errorCode != 1) {
               console.log('데이터를 불러드리는데 오류가 발생했습니다.');
                swal({
                    text: '데이터를 불러드리는데 오류가 발생했습니다.',
                    icon: "error",
                });
                return;
            }else{
             Swal.fire({
                 text: www,
                 imageUrl: imgRoute,
               });
         }   
        }
    };
};