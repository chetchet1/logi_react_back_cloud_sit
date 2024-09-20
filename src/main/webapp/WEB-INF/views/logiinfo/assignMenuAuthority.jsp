<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>assign Menu Authority</title>
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
<h4>🚫메뉴권한설정</h4>
<h6>등록할 메뉴를 <span style='color:red'>모두</span> 선택하세요</h6>
<table>
<tr>
<td> 
<article class="AuthorityGroupGrid">
    <h5>🐱권한그룹</h5>
    <div align="center">
        <div id="myGrid1" class="ag-theme-balham" style="height:500px; width:500px; text-align: center;"></div>
    </div>
</article>
</td>
<td>
	<div class="menuButton">
     	<button id="saveButton" style="float:right; background-color:#F15F5F"> &nbsp;저장&nbsp; </button>
	</div>
<article class="MenuGrid">
	<h5>✔️메뉴</h5>
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

   let userAuthorityGroupList = []; // user의 권한그룹리스트를 담는 배열

   // 권한그룹 그리드
   let authorityGroupColumn = [
       {headerName: "권한그룹명", field: "authorityGroupName", checkboxSelection: true},
       {headerName: "권한그룹코드", field: "authorityGroupCode"}
     ];

   let authorityGroupRowData = [];
   let authorityGroupGridOptions = {
             columnDefs: authorityGroupColumn,
             rowSelection: 'single',
             rowData: authorityGroupRowData,
             defaultColDef: {editable: false},
             overlayNoRowsTemplate: "권한그룹 정보가 없습니다.",
             onGridReady: function (event) {
               event.api.sizeColumnsToFit();
             },
             onGridSizeChanged: function (event) {
               event.api.sizeColumnsToFit();
             },
             onRowClicked: function(event) {
                getMenuAuthorityData();
               }
           }

   // 메뉴 그리드
   let menuAuthorityColumn = [
       {headerName: "메뉴", field: "menuName",
          headerCheckboxSelection: true,
          headerCheckboxSelectionFilteredOnly: true,
          checkboxSelection: function(row){
              if(row.data.authority == "1" || row.data.authority == "0")
               return true;
             }},
       {headerName: "메뉴코드", field: "menuCode", hide:true},
       {headerName: "현재 권한여부", field: "authority", cellRenderer: function (params) {
            if (params.value == "1") {
               // params.node.setSelected(true);
                return params.value =  "🟢" ;
            }else if(params.value == "-1" || params.value == "-2"){
               params.node.selectable = false;
               return params.value =  "" ;
            }
            return '✖️' ;
           }
       }
     ];

   let menuAuthorityRowData = [];
   let menuAuthorityGridOptions = {
             columnDefs: menuAuthorityColumn,
             rowSelection: 'multiple',
             rowData: menuAuthorityRowData,
             defaultColDef: {editable: false},
             overlayNoRowsTemplate: "메뉴 정보가 없습니다.",
             rowMultiSelectWithClick: true,
             onGridReady: function (event) {
               event.api.sizeColumnsToFit();
             },
             onGridSizeChanged: function (event) {
               event.api.sizeColumnsToFit();
             },
              getRowStyle: function (param) {
                  if (param.data.authority == "-1") {
                      return {'font-weight': 'bold'};
                  }
              },
               onSelectionChanged : function (event) {
                 selectedMenuList = this.api.getSelectedRows();
                 console.log(selectedMenuList);
              }
         }

   // 권한그룹 데이터를 가져오는 함수
   let authorityGroupData;
   function getAuthorityGroupData(){
        let xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/hr/authoritygroup' +
            "?method=getAuthorityGroup",
            true);
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send();
        xhr.onreadystatechange = () => {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let txt = xhr.responseText;
                authorityGroupData = JSON.parse(txt).gridRowJson;
                console.log(authorityGroupData);
                if (txt.errorCode < 0) {
                    Swal.fire({
                        text: '데이터를 불러들이는데 오류가 발생했습니다.',
                        icon: 'error'
                    });
                    return;
                }
            }
        }
   }

   // 권한그룹별 메뉴 데이터를 가져와 그리드에 세팅. 권한그룹 그리드 로우를 클릭했을때 이벤트
   let menuAuthorityData;
   let authorityGroupCode;
   function getMenuAuthorityData(){
      authorityGoupRows = authorityGroupGridOptions.api.getSelectedRows();
      authorityGroupCode = authorityGoupRows[0].authorityGroupCode;
      console.log(authorityGroupCode);
        let xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/hr/menu/authority' +
            "?method=getMenuAuthority&authorityGroupCode="+authorityGroupCode,
            true);
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send();
        xhr.onreadystatechange = () => {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let txt = xhr.responseText;
                menuAuthorityData = JSON.parse(txt).gridRowJson;
                console.log(menuAuthorityData);
                menuAuthorityGridOptions.api.setRowData(menuAuthorityData);
                if (txt.errorCode < 0) {
                    Swal.fire({
                        text: '데이터를 불러들이는데 오류가 발생했습니다.',
                        icon: 'error'
                    });
                    return;
                }
            }
        }
   }

     // 저장버튼 클릭이벤트
     saveButton.addEventListener("click", () => {

           Swal.fire({
               title: '메뉴권한 변경',
               text: "메뉴권한을 변경하시겠습니까?",
               icon: 'warning',
               showCancelButton: true,
               confirmButtonColor: '#3085d6',
               cancelButtonColor: '#d33',
               cancelButtonText: '취소',
               confirmButtonText: '확인',
             }).then((result) => {
                if (result.isConfirmed) {
                 let selectmenuAuthorityData = [];
               let selectMenuData = menuAuthorityGridOptions.api.getSelectedRows();
               for(data of selectMenuData){
                  console.log(data.menuCode);
                  let newData = {authorityGroupCode:authorityGroupCode, menuCode: data.menuCode};
                  selectmenuAuthorityData.push(newData);
               }
               let insertData = JSON.stringify(selectmenuAuthorityData);
               console.log(insertData);

                    let xhr = new XMLHttpRequest();
                 xhr.open('POST', '${pageContext.request.contextPath}/hr/menu/authority' +
                     "?method=insertMenuAuthority"+
                     "&authorityGroupCode="+authorityGroupCode+
                     "&insertData="+encodeURI(insertData),
                     true);
                 xhr.setRequestHeader('Accept', 'application/json');
                 xhr.send();
                 xhr.onreadystatechange = () => {
                     if (xhr.readyState == 4 && xhr.status == 200) {
                        let txt = xhr.responseText;
                        getMenuAuthorityData();

                        if(userAuthorityGroupList.includes(authorityGroupCode)){
                           // 현재 user의 권한그룹과 선택한 권한그룹이 일치한다면
                           // 현재 로그인 한 user의 정보가 변경되었을 경우, session 재 세팅을 위해 재로그인이 필요하다.
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
                           Swal.fire('변경 완료','메뉴권한이 정상적으로 변경되었습니다','success');
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
         new agGrid.Grid(myGrid1, authorityGroupGridOptions);
         authorityGroupGridOptions.api.setRowData(authorityGroupData);
         new agGrid.Grid(myGrid2, menuAuthorityGridOptions);
         /* menuAuthorityGridOptions.api.setRowData(menuAuthorityData); */
     }


     document.addEventListener('DOMContentLoaded', () => {

           userAuthorityGroupList = new Array(); // 현재 user의 권한그룹 리스트
            <c:forEach var="authorityGroup" items="${sessionScope.authorityGroupCode}">
               userAuthorityGroupList.push("${authorityGroup}");
         </c:forEach>

        getAuthorityGroupData();
        setTimeout("setGrid()",200);

        });
</script>
</body>
</html>