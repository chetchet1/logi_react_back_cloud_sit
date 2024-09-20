<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ taglib prefix="J2H" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
    <script src="${pageContext.request.contextPath}/js/modal.js?v=<%=System.currentTimeMillis()%>" defer></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=17f589ec2340ee90f6b411fa04316f22"></script>	
	<script src="/jquery-3.3.1.min.js"></script>
	<script src="/bootstrap.min.js"></script>
	<style>
		* {
            margin: 0px;
        }
		#tabs table {
			font-size: 11px;
		}
		#tabs .ui-jqgrid .ui-widget-header {
			height: 30px;
			font-size: 1em;
		}
        h5 {
            margin-top: 3px;
            margin-bottom: 3px;
        }
        input {
            padding: 2px 0 2px 0;
            text-align: center;
            border-radius: 3px;
        }
        .warehouse {
            margin-bottom: 10px;
        }
        .warehouseDetail {
            margin-bottom: 10px;
        }
		.small_Btn {
			width: auto;
			height: auto;
			font-size: 15px;
		}‍
		.ui-jqgrid-view {
			font-size: 0.8em;
		}
		.menuButton {
            margin-top: 10px;
        }
		.menuButton button {
            background-color: #506FA9;
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            border-radius: 3px;
        }
        .menuButton__selectCode {
            display: inline-block;
        }
        .ag-header-cell-label {
            justify-content: center;
        }
        .ag-cell-value {
            padding-left: 50px;
        }
	</style>
</head>
<body>
	<!-- 창고 -->
	<article class="warehouse">
    	<div class="warehouse__Title">
			<h5>🏡 창고 관리</h5>
			<span style="margin-top: 10px; color: black">창고 조회 및 정보 수정</span><br/>
	        <div class="menuButton">
	        	<button id="warehouseSearchButton">창고 조회</button>&nbsp;&nbsp;
 &nbsp;&nbsp;&nbsp;<button id="warehouseInsertButton" onclick="addRow(this)">창고 추가</button>
	            <button id="warehouseDeleteButton" onclick="deleteRow(this)">창고 삭제</button>
 &nbsp;&nbsp;&nbsp;<button id="batchSaveButton" style="float:right; background-color:#F15F5F">창고일괄처리</button>
    			<button id="warehouseLocationButton">창고 위치 조회</button>
	        </div>
		</div>
	</article>
	<article class="warehouseGrid">
	    <div align="center">
	        <div id="warehouseGrid" class="ag-theme-balham" style="height:20vh; width:auto; text-align: center;"></div>
	    </div>
	</article>
	<!-- 창고 품목 -->
	<article class="warehouseDetail">
    	<div class="warehouseDetail__Title">
		<!-- 	<h5>🧱 창고 자재 관리</h5> -->
			<br/>
			<span style="color: black">창고 자재 조회 및 정보 수정</span><br/>
	        <div class="menuButton">
	        	<button id="warehouseDetailSearchButton">자재 조회</button>&nbsp;&nbsp;
 &nbsp;&nbsp;&nbsp;<button id="warehouseDetailInsertButton" onclick="addRow(this)">자재 추가</button>
	            <button id="warehouseDetailDeleteButton" onclick="deleteRow(this)">자재 삭제</button>
	            <button id="DetailbatchSaveButton" style="float:right; background-color:#F15F5F">자재일괄처리</button>
	        </div>
		</div>
	</article>
	<!-- 창고위치모달 -->
	<article class="warehouseDetailGrid">
	    <div align="center" class="ss">
	        <div id="warehouseDetailGrid" class="ag-theme-balham" style="height:50vh; width:auto; text-align: center;"></div>
	    </div>
	</article>
	<div id="googleMapModal" class="modal fade" role="dialog">
      <div class="modal-dialog">
         <!-- Modal content-->
         <div class="modal-content">
            <div class="modal-header">
               <h4 class="modal-title">Google Map</h4>
               <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">
               <!-- 맵 출력 -->
               <div id="googleMap" style="width: 100%; height: 500px;"></div>
            </div>

            <div class="modal-footer">
               <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
         </div>
      </div>
   </div>
	
	<script>
		//Grid 버튼
		const warehouseGrid = document.querySelector("#warehouseGrid");
		const warehouseDetilGrid = document.querySelector("#warehouseDetilGrid");
		//pageList 버튼
	//	const warehousePageListButton = document.querySelector("#warehousePageListButton");
		//창고 버튼
		const warehouseSearchBtn = document.querySelector("#warehouseSearchButton");
		const warehouseInsertBtn = document.querySelector("#warehouseInsertButton");
		const warehouseDeleteBtn = document.querySelector("#warehouseDeleteButton");
		//자재 버튼
		const warehouseDetailSearchBtn = document.querySelector("#warehouseDetailSearchButton");
		const warehouseDetailInsertBtn = document.querySelector("#warehouseDetailInsertButton");
		const warehouseDetailDeleteBtn = document.querySelector("#warehouseDetailDeleteButton");
		//일괄 처리
		const batchSaveBtn = document.querySelector("#batchSaveButton");
		const DetailbatchSaveBtn = document.querySelector("#DetailbatchSaveButton");
		
		/* let change=false;
		warehousePageListButton.addEventListener("click", () => {
			if(change==false) change=true;
			else change=false;
		}); */
		let searchCheck = 0;
		let Data=[];
		// 창고 Grid
		let warehouseColumn = [
			{headerName: "창고코드", field: "warehouseCode", editable: true,
				checkboxSelection: true},
			{headerName: "창고이름", field: "warehouseName", editable: true},
			{headerName: "창고사용여부", field: "warehouseUseOrNot", editable: true},
			{headerName: "비고", field: "description", editable: true},
			{headerName: "상태", field: "status"}
		];
		// event.colDef.field
		let warehouseRowData=[];
		let whGridOptions = {
		    columnDefs: warehouseColumn,
		    rowSelection: 'single',
		    rowData: warehouseRowData,
	    	paginationAutoPageSize: true,
	    	pagination: true,
		 /*    getRowNodeId: function(data) {
		      return data.warehouseCode;
		    }, */
		    defaultColDef: {editable: false, resizable : true},
		    overlayNoRowsTemplate: "조회된 창고 데이터가 없습니다.",
		    onGridReady: function(event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
		      event.api.sizeColumnsToFit();
		    },
		    onRowSelected: function(event) { // checkbox
		    	searchCheck = 0;
		    	if(event.data.status == "INSERT"){
		    		console.log(event.data);
		    		event.data.editable = true;
		    		console.log(event.data.editable);
		    	//	event.data[0].editable = true;
		    	}
		  //    console.log(event);
		    },
		    onRowClicked: function(event) {
	             const wareHouseCodeNo = event.data.warehouseCode; //창고 번호 가져오기
	             getLatLng(wareHouseCodeNo);
	           },
		    getSelectedRowData() {
		        let selectedNodes = this.api.getSelectedNodes();
		        let selectedData = selectedNodes.map(node => node.data);
		        return selectedData;
		    },
		    onGridSizeChanged: function (event) {
		        event.api.sizeColumnsToFit();
		    },
		    onGridSizeChanged: function(event) {
		      event.api.sizeColumnsToFit();
		    },
		    onCellValueChanged: function(event) {
		    	if(event.data.status == "NORMAL"){
			    	console.log(event.data);
		    		event.data.status = "UPDATE";
		    		whGridOptions.api.updateRowData({update: [event.data]});
		    	}
	        },
		    getRowStyle: function(param) {
		      return {'text-align': 'center'};
		    }
		}
		//창고 조회 기능
		warehouseSearchBtn.addEventListener("click", () => {
			let xhr = new XMLHttpRequest();
			xhr.open('GET', '${pageContext.request.contextPath}/logiinfo/warehouse/list' +
				"?method=getWarehouseList", true)
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
					console.log(txt);
					whGridOptions.api.setRowData(txt.gridRowJson);
				}
			}
		});
		
		//창고 자재 Grid
		let warehouseDetailColumn = [
			{headerName: "창고코드", field: "warehouseCode",
				suppressSizeToFit: true,
				headerCheckboxSelection: true,
				headerCheckboxSelectionFilteredOnly: true,
				checkboxSelection: true},
		    {headerName: "자재코드", field: "itemCode", editable: true},
		    {headerName: '자재명', field: "itemName", editable: true},
		    {headerName: '단위', field: 'unitOfStock'},
		    {headerName: '안전재고량', field: 'safetyAllowanceAmount', editable: true},
		    {headerName: '가용재고량', field: 'stockAmount', editable: true},
		    {headerName: '입고예정재고량', field: 'orderAmount', hide: true},
		    {headerName: '투입예정재고량', field: 'inputAmount', hide: true},
		    {headerName: '납품예정재고량', field: 'deliveryAmount', hide: true},
		    {headerName: '전체재고량', field: 'totalStockAmount', editable: true},
		    {headerName: "상태", field: "status"}
		];
		// event.colDef.field
		let warehouseDetailRowData=[];
		let whDetailGridOptions = {
		    columnDefs: warehouseDetailColumn,
		    rowSelection: 'multiple',
		    rowData: warehouseDetailRowData,
		    paginationAutoPageSize: true,
	    	pagination: true,
		   /*  getRowNodeId: function(data) {
		      return data.warehouseCode;
		    }, */
		    defaultColDef: { /* editable: false,*/ resizable : true},
		    overlayNoRowsTemplate: "조회된 품목 데이터가 없습니다.",
		    onGridReady: function(event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
		      event.api.sizeColumnsToFit();
		    },
		    onRowSelected: function(event) { // checkbox
		  	  //    console.log(event);
	  	    },
	  	    getSelectedRowData() {
	  	        let selectedNodes = this.api.getSelectedNodes();
	  	        let selectedData = selectedNodes.map(node => node.data);
	  	        return selectedData;
	  	    },
	  	    onGridSizeChanged: function (event) {
	  	        event.api.sizeColumnsToFit();
	  	    },
		    onCellValueChanged: function(event) {
		    	if(event.data.status != "INSERT" && event.data.status != "DELETE"){
			    	console.log(event.data);
		    		event.data.status = "UPDATE";
		    		whDetailGridOptions.api.updateRowData({update: [event.data]});
		    	}
	        },
		    onGridSizeChanged: function(event) {
		      event.api.sizeColumnsToFit();
		    },
		    getRowStyle: function(param) {
		      return {'text-align': 'center'};
		    }
		}
		//자재 조회 기능
		warehouseDetailSearchBtn.addEventListener("click",()=>{
			searchCheck = 0;
			let warehouseData = whGridOptions.getSelectedRowData(); // 선택된 기존 setting 값
			if (warehouseData.length == 0) {
				Swal.fire({
					text: "품목을 조회할 창고를 선택 하세요.",
					icon: "info",
				})
				return;
			}
			if (warehouseData[0].warehouseCode == "" || warehouseData[0].warehouseName == "") {
				Swal.fire({
					text: "품목을 조회할 창고의 창고 코드 또는 이름을 입력 하세요.",
					icon: "info",
				})
				return;
			}
			else{
				let xhr = new XMLHttpRequest();
				xhr.open('GET', '${pageContext.request.contextPath}/stock/sto/warehousestocklist' +
					"?method=searchWarehouseStockList"
					+"&warehouseCode="+ warehouseData[0].warehouseCode, true)
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
						console.log(txt);
						whDetailGridOptions.api.setRowData(txt.gridRowJson);
						searchCheck = 1;
					}
				}
			}
		});
		
		//공통 기능 ***************************************************************
		//추가 기능 *****************************************************************
		function addRow(event) {
			console.log("add이벤트 실행");
			//추가 기능 : 창고
			if (event.id == "warehouseInsertButton") {
				let flag = 0;
				whGridOptions.api.forEachNode(function(eachRow, index){
					if (eachRow.data.warehouseCode == "" && eachRow.data.warehouseName == "") {
						flag = 1;
						Swal.fire({
							text: "수정 중인 창고 데이터가 있습니다.",
							icon: "info",
						})
						return;
					}
					flag = 2;
				});
				if (flag == 0) {
					Swal.fire({
						text: "조회한 창고 데이터가 없습니다.",
						icon: "info",
					})
					return;
				}
				if(flag == 2){
					console.log("창고추가");
					let row = {
						warehouseCode: "",
						warehouseName: "",
						warehouseUseOrNot: "",
						description: "",
						status: "INSERT"
					};
					whGridOptions.api.updateRowData({add: [row]});
				}
			}
			//추가 기능 : 자재
			else if (event.id == "warehouseDetailInsertButton") {
				let flag = 0;
				console.log("자재추가");
				console.log(event.innerText);
				let warehouseData = whGridOptions.getSelectedRowData(); // 선택된 기존 setting 값
				console.log(warehouseData);
				if (warehouseData.length == 0) {
					Swal.fire({
						text: "자재을 추가할 창고를 선택 하세요.",
						icon: "info",
					})
					return;
				}
				console.log("품목상세" + warehouseData[0]);
				if (warehouseData[0].warehouseCode == undefined && warehouseData[0].warehouseName == undefined) {
					Swal.fire({
						text: "창고 코드 또는 이름을 등록하셔야 합니다.",
						icon: "info",
					})
					return;
				}
				whDetailGridOptions.api.forEachNode(function(eachRow){
					if (eachRow.data.itemCode == "" && eachRow.data.itemName == "") {
						flag = 1;
						Swal.fire({
							text: "수정 중인 자재 데이터가 있습니다.",
							icon: "info",
						})
						return;
					}
				});
				if (searchCheck == 0) {
					Swal.fire({
						text: "조회한 창고 데이터가 없습니다.",
						icon: "info",
					})
					return;
				}
			  	if(flag == 0 && searchCheck == 1){
					let row = {
						warehouseCode: warehouseData[0].warehouseCode,
						itemCode: "",
						itemName: "",
						unitOfStock: "EA",
						safetyAllowanceAmount: "",
						stockAmount: "",
						orderAmount: "",
						inputAmount: "",
						deliveryAmount: "",
						totalStockAmount: "",
						status: "INSERT"
					};
					whDetailGridOptions.api.updateRowData({add: [row]});
			  	}
			}
		}
		
		//삭제 기능 *****************************************************************
		function deleteRow(event) {
			//삭제 기능 : 창고 삭제
			if (event.id == "warehouseDeleteButton") {
				let selected = whGridOptions.api.getFocusedCell();
				if (selected == undefined) {
					Swal.fire({
						text: "삭제할 행이 선택되지 않았습니다.",
						icon: "info",
					})
					return;
				}
				let warehouseData = whGridOptions.getSelectedRowData();
				warehouseData.forEach(function(selectedRow, index) {
					if(selectedRow.status == "INSERT"){
						whGridOptions.api.updateRowData({remove: [selectedRow]});
					}else{
						selectedRow.status = "DELETE";
						whGridOptions.api.updateRowData({update: [selectedRow]});
					}
				});
			}
			//삭제 기능 : 자재 삭제
			else if (event.id == "warehouseDetailDeleteButton"){
				let selected = whDetailGridOptions.api.getFocusedCell();
				if (selected == undefined) {
					Swal.fire({
						text: "삭제할 행이 선택되지 않았습니다.",
						icon: "info",
					})
					return;
				}
				let warehouseDetailRows = whDetailGridOptions.getSelectedRowData();
				warehouseDetailRows.forEach( function(selectedRow, index) {
					if(selectedRow.status == "INSERT"){
						whDetailGridOptions.api.updateRowData({remove: [selectedRow]});
					}else{
						selectedRow.status = "DELETE";
						console.log(selectedRow);
						whDetailGridOptions.api.updateRowData({update: [selectedRow]});
					}
				});
			}
		}
		
		
		//일괄 처리 *****************************************************************
		batchSaveBtn.addEventListener("click", () =>{
			batchFunc("warehouse");
		});
		DetailbatchSaveBtn.addEventListener("click", () =>{
			batchFunc("stock");
		});
		function batchFunc(event){
			console.log(event);
			let flag = 0;
			let whRowValue = [];
			let whDetailRowValue = [];
			whGridOptions.api.forEachNode(function(eachRow){
				if (eachRow.data.warehouseCode == "" && eachRow.data.warehouseName == "") {
					flag = 1;
					Swal.fire({
						text: "수정 중인 창고 데이터가 있습니다.",
						icon: "info",
					})
					return;
				}
				whRowValue.push(eachRow.data);
			});
			whDetailGridOptions.api.forEachNode(function(eachRow){
				if (eachRow.data.itemCode == "" && eachRow.data.itemName == "") {
					flag = 1;
					Swal.fire({
						text: "수정 중인 자재 데이터가 있습니다.",
						icon: "info",
					})
					return;
				}
				whDetailRowValue.push(eachRow.data);
			});
			if(flag == 0){
				//일괄 처리 : 창고
				if(event == "warehouse"){
				  	console.log(whRowValue);
				  	whRowValue = JSON.stringify(whRowValue);
				  	console.log(whRowValue);
					Swal.fire({
						title: "창고 데이터를 수정하시겠습니까?",
						icon: 'warning',
						showCancelButton: true,
						confirmButtonColor: '#3085d6',
						cancelButtonColor: '#d33',
						cancelButtonText: '취소',
						confirmButtonText: '확인',
					}).then((result) => {
						if (result.isConfirmed) {
							let xhr = new XMLHttpRequest();
							xhr.open('POST', "${pageContext.request.contextPath}/logiinfo/warehouse/batch"
								+ "?method=modifyWarehouseInfo&batchList="+encodeURI(whRowValue),
							true);
							xhr.setRequestHeader('Accept', 'application/json');
							xhr.send();
							xhr.onreadystatechange = () => {
								if (xhr.readyState == 4 && xhr.status == 200) {
									// 초기화 
									whGridOptions.api.setRowData([]);
									whDetailGridOptions.api.setRowData([]);
									let txt = xhr.responseText;
									txt = JSON.parse(txt);
									Swal.fire({
										title: "창고 정보 수정이 완료되었습니다.",
										icon: "success"
									});
								}
							};
						}
					})
				}
				//일괄 처리 : 자재
				else if(event == "stock"){
					console.log(whDetailRowValue);
					whDetailRowValue = JSON.stringify(whDetailRowValue);
					Swal.fire({
						title: "자재 데이터를 수정하시겠습니까?",
						icon: 'warning',
						showCancelButton: true,
						confirmButtonColor: '#3085d6',
						cancelButtonColor: '#d33',
						cancelButtonText: '취소',
						confirmButtonText: '확인',
					}).then((result) => {
						if (result.isConfirmed) {
							let xhr = new XMLHttpRequest();
							xhr.open('POST', "${pageContext.request.contextPath}/stock/sto/batch"
								+ "?method=modifyStockInfo&batchList="+encodeURI(whDetailRowValue),
							true);
							xhr.setRequestHeader('Accept', 'application/json');
							xhr.send();
							xhr.onreadystatechange = () => {
								if (xhr.readyState == 4 && xhr.status == 200) {
									// 초기화 
									whDetailGridOptions.api.setRowData([]);
									let txt = xhr.responseText;
									txt = JSON.parse(txt);
									Swal.fire({
										title: "자재 정보 수정이 완료되었습니다.",
										icon: "success"
									});
								}
							};
						}
					})
				}
			}
		}
		
		// O setup the grid after the page has finished loading
		document.addEventListener('DOMContentLoaded', () => {
	         $("#warehouseLocationButton").on("click", function() {
	            $("div#googleMapModal").modal();
	         });

	         $("div#googleMapModal").on("shown.bs.modal", function() {
	            myMap();
	         });

	         $("div#googleMapModal").on("hidden.bs.modal", function() {
	            $("div#googleMap").empty();
	         });
	         
			
			
			console.log("***그리드 생성");
			new agGrid.Grid(warehouseGrid, whGridOptions);
			new agGrid.Grid(warehouseDetailGrid, whDetailGridOptions);
		})
		
	
      let Lat;
      let Lng;
      
      function interceptor(num1,num2){
         Lat = num1;
         Lng = num2;
      }
      
      function myMap() {                        
         //위도, 경도 
         var center = new kakao.maps.LatLng(Lat,Lng); //지도에 띄어질 중앙부
         var handok = new kakao.maps.LatLng(Lat,Lng); //마커

         //맵 정보
         var options = {
            center : center,
            zoom : 17,
         };

         //맵 요청
         var map = new kakao.maps.Map(document.getElementById("googleMap"), options);

         //마커 표시
         var marker = new kakao.maps.Marker({
            position : handok
         });

         marker.setMap(map);

         //InfoWindow
         var infowindow = new kakao.maps.InfoWindow(
            {
               content : "<div style=\"text-align:center;\"><strong>한독약품빌딩</strong><br>서울특별시 강남구 역삼1동 735<br></div>"
            });
         
         infowindow.open(map, marker);
         
      }
	</script>
</body>
</html>