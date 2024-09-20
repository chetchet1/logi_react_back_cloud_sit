<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>assign Authority Group</title>
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
<h4>🚫권한그룹설정</h4>
<h6>등록할 권한그룹을 <span style='color:red'>모두</span> 선택하세요</h6>
<table>
<tr>
<td> 
<article class="UserInformationGrid">
    <h5>🐱사용자</h5>
    <div align="center">
        <div id="myGrid1" class="ag-theme-balham" style="height:500px; width:500px; text-align: center;"></div>
    </div>
</article>
</td>
<td>
	<div class="menuButton">
     	<button id="saveButton" style="float:right; background-color:#F15F5F"> &nbsp;저장&nbsp; </button>
	</div>
<article class="AuthorityGroupGrid">
	<h5>✔️권한그룹</h5>
    <div align="center">
        <div id="myGrid2" class="ag-theme-balham" style="height:500px; width:500px; text-align: center;"></div>
    </div>
</article>
</td>
</tr>
</table>

<script>
   const myGrid1 = document.querySelector('#myGrid1');
   const myGrid2 = document.querySelector('#myGrid2');
   //사용자 그리드
   let userInformationColumn = [
       {headerName: "사원명", field: "empName", checkboxSelection: true},
       {headerName: "직책", field: "positionName"},
       {headerName: "부서", field: "deptName"}
     ];

   let userInformationRowData = [];
   let userInformationGridOptions = {
             columnDefs: userInformationColumn,
             rowSelection: 'single',
             rowData: userInformationRowData,
             defaultColDef: {editable: false},
             overlayNoRowsTemplate: "사용자 정보가 없습니다.",
             onGridReady: function (event) {
               event.api.sizeColumnsToFit();
             },
             onGridSizeChanged: function (event) {
               event.api.sizeColumnsToFit();
             },
             onRowClicked: function(event) {
                getUserAuthorityGroupData();
               }
           }



   //권환그룹 그리드
   let authorityGroupColumn = [
       {headerName: "권한그룹명", field: "authorityGroupName", checkboxSelection: true, headerCheckboxSelection: true, headerCheckboxSelectionFilteredOnly: true},
       {headerName: "권한그룹코드", field: "authorityGroupCode", hide:true},
       {headerName: "현재 권한여부", field: "authority", cellRenderer: function (params) {
            if (params.value == "1") {
               // params.node.setSelected(true);
                return params.value =  "🟢" ;
            }
            return '✖️' ;
        }}
     ];
   let authorityGroupRowData = [];
   let authorityGroupGridOptions = {
             columnDefs: authorityGroupColumn,
             rowSelection: 'multiple',
             rowData: authorityGroupRowData,
             defaultColDef: {editable: false},
             overlayNoRowsTemplate: "권한그룹 정보가 없습니다.",
             rowMultiSelectWithClick: true,
             onGridReady: function (event) {
               event.api.sizeColumnsToFit();
             },
             onGridSizeChanged: function (event) {
               event.api.sizeColumnsToFit();
             }
   }

   let EmployeeData;
   function getEmployeeData(){
        let xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/hr/emp/alllist' +
            "?method=searchAllEmpList"
            + "&searchCondition=ALL"
            + "&companyCode=COM-01",
            true);
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send();
        xhr.onreadystatechange = () => {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let txt = xhr.responseText;
                EmployeeData = JSON.parse(txt).gridRowJson;
                console.log(EmployeeData);
                if (txt.errorCode < 0) {
                    Swal.fire({
                        text: '데이터를 불러들이는데 오류가 발생했습니다.',
                        icon: 'error',
                    });
                    return;
                }
            }
        }
   }

   let authorityGroupData;
   let employeeRowNode;
   let empCode;
   function getUserAuthorityGroupData(){
      employeeRowNode = userInformationGridOptions.api.getSelectedNodes();
      empCode = employeeRowNode[0].data.empCode;
      console.log(empCode);
        let xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/hr/authoritygroup/user' +
            "?method=getUserAuthorityGroup&empCode="+empCode,
            true);
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send();
        xhr.onreadystatechange = () => {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let txt = xhr.responseText;
                authorityGroupData = JSON.parse(txt).gridRowJson;
                // console.log(authorityGroupData);
                authorityGroupGridOptions.api.setRowData(authorityGroupData);
                if (txt.errorCode < 0) {
                    Swal.fire({
                        text: '데이터를 불러들이는데 오류가 발생했습니다.',
                        icon: 'error',
                    });
                    return;
                }
            }
        }
   }

     //저장버튼 클릭이벤트
     saveButton.addEventListener("click", () => {
           Swal.fire({
               title: '권한그룹 변경',
               text: "권한그룹을 변경하시겠습니까?",
               icon: 'warning',
               showCancelButton: true,
               confirmButtonColor: '#3085d6',
               cancelButtonColor: '#d33',
               cancelButtonText: '취소',
               confirmButtonText: '확인',
             }).then((result) => {
                if (result.isConfirmed) {
                 let employeeAuthorityGroupData = [];
               let authorityGroupData = authorityGroupGridOptions.api.getSelectedNodes();
               for(data of authorityGroupData){
                  let newData = {empCode:empCode, authorityGroupCode: data.data.authorityGroupCode};
                  employeeAuthorityGroupData.push(newData);
               }
               let insertData = JSON.stringify(employeeAuthorityGroupData);
               // console.log(insertData);

                   let xhr = new XMLHttpRequest();
                 xhr.open('POST', '${pageContext.request.contextPath}/hr/employeeauthoritygroup' +
                     "?method=insertEmployeeAuthorityGroup"+
                     "&empCode="+empCode+
                     "&insertData="+encodeURI(insertData),
                     true);
                 xhr.setRequestHeader('Accept', 'application/json');
                 xhr.send();
                 xhr.onreadystatechange = () => {
                     if (xhr.readyState == 4 && xhr.status == 200) {
                        let txt = xhr.responseText;
                        getUserAuthorityGroupData();
                        // 현재 로그인 한 user의 정보가 변경되었을 경우, session 재 세팅을 위해 재로그인이 필요하다.
                        if(empCode=='${sessionScope.empCode}'){
                            Swal.fire({
                               title: '변경사항 적용을 위해서 다시 로그인이 필요합니다.',
                               text: "지금 다시 로그인 하시겠습니까?",
                               icon: 'warning',
                               showCancelButton: true,
                               confirmButtonColor: '#3085d6',
                               cancelButtonColor: '#d33',
                               cancelButtonText: '취소',
                               confirmButtonText: '확인',
                             }).then((result) => {
                                if (result.isConfirmed) {
                                   location.href="${pageContext.request.contextPath}/logiinfo/loginForm/view";
                                }
                             });
                        }else{
                           Swal.fire('변경 완료','권한그룹이 정상적으로 변경되었습니다','success');
                        }
                         if (txt.errorCode < 0) {
                             Swal.fire({
                                 text: '데이터를 불러들이는데 오류가 발생했습니다.',
                                 icon: 'error',
                             });
                             return;
                         }
                     }
                 }
            }
      });
     });

     function setGrid(){
         new agGrid.Grid(myGrid1, userInformationGridOptions);
            userInformationGridOptions.api.setRowData(EmployeeData);
         new agGrid.Grid(myGrid2, authorityGroupGridOptions);
     }
     document.addEventListener('DOMContentLoaded', () => {
        getEmployeeData();
        setTimeout("setGrid()",200);
        });
</script>
</body>
</html>