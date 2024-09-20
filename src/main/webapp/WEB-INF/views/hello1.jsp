<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOGIN INFORMATION</title>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">
    <style>
        * {
            margin: 0px;
        }

        h5 {
            margin-top: 3px;
            margin-bottom: 3px;
        }

        .ag-header-cell-label {
            justify-content: center;
        }
        .ag-cell-value {
            padding-left: 50px;
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

    </style>
</head>
<body>
<br>
<h5>❔ 로그인 정보</h5>
<br>
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:205px; width:auto; text-align: center;"></div>
    </div>
<script>
	const myGrid = document.querySelector('#myGrid');

	let loginInformationColumn = [
	    {headerName: "", field: "key"},
	    {headerName: "", field: "value"}
	  ];
	
	let loginInformationData = [
		{'key': 'WORKPLACE', 'value': '${sessionScope.workplaceName}' },
		{'key': 'DEPT', 'value': '${sessionScope.deptName}' },
		{'key': 'POSITION', 'value': '${sessionScope.positionName}' },
		{'key': 'NAME', 'value': '${sessionScope.empName}' },
		{'key': 'ID', 'value': '${sessionScope.userId}' },
		{'key': '접속자', 'value': '${userCount} 명' }
	];
	let loginInformationGridOptions = {
			    columnDefs: loginInformationColumn,
			    rowSelection: 'single',
			    rowData: loginInformationData,
			    defaultColDef: {editable: false},
			    overlayNoRowsTemplate: "로그인 정보가 없습니다.",
			    onGridReady: function (event) {
			      event.api.sizeColumnsToFit();
			    },
			    onGridSizeChanged: function (event) {
			      event.api.sizeColumnsToFit();
			    }
			  }
	
	  document.addEventListener('DOMContentLoaded', () => {
		  new agGrid.Grid(myGrid, loginInformationGridOptions);
		  });
</script>

</body>
</html>