<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8"%>
<%@ taglib prefix="decorator"
           uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html>
<head>
    <title>Estimulo71</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/popper.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script> 
	<style type="text/css">
	    h5 {
	        font-family: 'Noto Sans KR', sans-serif;
	    }
	    .img {
	        margin-bottom: 15px !important;
	    }
	</style>
    <sitemesh:write property='head'/>
</head>
<body>
<c:if test="${sessionID != null }">

<div class="wrapper d-flex align-items-stretch">
    <nav id="sidebar">
        <div class="p-4 pt-5">
            <a href="/hello3/view" class="img logo rounded-circle mb-5" style="background-image: url('${pageContext.request.contextPath}${sessionScope.image}');"></a>
            <p style="text-align: center">👩🏻‍💼 ${sessionScope.empName}${sessionScope.positionName}님 환영합니다.</p>
 			
 			<!-- 메뉴 -->
 			<div> ${sessionScope.allMenuList} </div>

            <div class="footer">
                <p>경상남도 진주시 가좌길 74-6 <br/>혜람빌딩 7층</p>
                <p>Tel : 010 - 3581 - 0058
                    <br/>Email: estimulomusic@gmail.com </p>
            </div>
        </div>
    </nav>

 	<!-- Page Content  -->
    <div id="content" class="p-1 p-md-3">
        ${sessionScope.allMenuList_b}
        <nav class="navbar navbar-expand-sm navbar-light bg-light">
            <div class="container-fluid">
                <button type="button" id="sidebarCollapse" class="btn btn-primary">
                    <i class="fa fa-bars"></i>
                    <span class="sr-only">Toggle Menu</span>
                </button>
                <button class="btn btn-dark d-inline-block d-lg-none ml-auto" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <i class="fa fa-bars"></i>  <!-- 메뉴 토글 버튼  -->
                </button>
            
            <!-- nav 메뉴 -->
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                   ${sessionScope.navMenuList}
                </div>
                  <div class="navbar-header">
                    <a class="nav-link" href="${pageContext.request.contextPath}/hr/logout">로그아웃</a>
               </div>
            </div>
        </nav>
        <div>*_*</div>
        <sitemesh:write property='body'/>
    </div>
</div>
    <script>
	    document.addEventListener('DOMContentLoaded', () => {
	     	let menuList = new Array();     	
	      	<c:forEach var="menu" items="${sessionScope.authorityGroupMenuList}">
					menuList.push("${menu}");
			</c:forEach>   
			
	 		$(".m").on('click', function (event) {
				
				if(!menuList.includes(this.id)){
			        swal.fire({
			            text: "접근권한이 없습니다.",
			            icon: "error",
			          });
					return false;
				}    
			});
	 	});
	</script>
</c:if>
<c:if test="${sessionID == null}">
<script>
	location.href="${pageContext.request.contextPath}/logiinfo/loginForm/view"
</script>
</c:if>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>