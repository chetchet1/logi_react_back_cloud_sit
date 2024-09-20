<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ taglib prefix="J2H" tagdir="/WEB-INF/tags" %>   
<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javascript"
   src="//dapi.kakao.com/v2/maps/sdk.js?appkey=17f589ec2340ee90f6b411fa04316f22&libraries=services,clusterer,drawing"></script>

<script src="https://code.jquery.com/jquery-3.6.0.js"
   integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
   crossorigin="anonymous"></script>
<meta charset="utf-8" />
<style>
.map_wrap, .map_wrap * {
   margin: 0;
   padding: 0;
   font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
   font-size: 12px;
}

.map_wrap a, .map_wrap a:hover, .map_wrap a:active {
   color: #000;
   text-decoration: none;
}

.map_wrap {
   position: relative;
   width: 100%;
   height: 500px;
}

#menu_wrap {
   position: absolute;
   top: 0;
   left: 0;
   bottom: 0;
   width: 250px;
   margin: 10px 0 30px 10px;
   padding: 5px;
   overflow-y: auto;
   background: rgba(255, 255, 255, 0.7);
   z-index: 1;
   font-size: 12px;
   border-radius: 10px;
}

.bg_white {
   background: #fff;
}

#menu_wrap hr {
   display: block;
   height: 1px;
   border: 0;
   border-top: 2px solid #5F5F5F;
   margin: 3px 0;
}

#menu_wrap .option {
   text-align: center;
}

#menu_wrap .option p {
   margin: 10px 0;
}

#menu_wrap .option button {
   margin-left: 5px;
}

#placesList li {
   list-style: none;
}

#placesList .item {
   position: relative;
   border-bottom: 1px solid #888;
   overflow: hidden;
   cursor: pointer;
   min-height: 65px;
}

#placesList .item span {
   display: block;
   margin-top: 4px;
}

#placesList .item h5, #placesList .item .info {
   text-overflow: ellipsis;
   overflow: hidden;
   white-space: nowrap;
}

#placesList .item .info {
   padding: 10px 0 10px 55px;
}

#placesList .info .gray {
   color: #8a8a8a;
}

#placesList .info .jibun {
   padding-left: 26px;
   background:
      url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_jibun.png)
      no-repeat;
}

#placesList .info .tel {
   color: #009900;
}

#placesList .item .markerbg {
   float: left;
   position: absolute;
   width: 36px;
   height: 37px;
   margin: 10px 0 0 10px;
   background:
      url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png)
      no-repeat;
}

#placesList .item .marker_1 {
   background-position: 0 -10px;
}

#placesList .item .marker_2 {
   background-position: 0 -56px;
}

#placesList .item .marker_3 {
   background-position: 0 -102px
}

#placesList .item .marker_4 {
   background-position: 0 -148px;
}

#placesList .item .marker_5 {
   background-position: 0 -194px;
}

#placesList .item .marker_6 {
   background-position: 0 -240px;
}

#placesList .item .marker_7 {
   background-position: 0 -286px;
}

#placesList .item .marker_8 {
   background-position: 0 -332px;
}

#placesList .item .marker_9 {
   background-position: 0 -378px;
}

#placesList .item .marker_10 {
   background-position: 0 -423px;
}

#placesList .item .marker_11 {
   background-position: 0 -470px;
}

#placesList .item .marker_12 {
   background-position: 0 -516px;
}

#placesList .item .marker_13 {
   background-position: 0 -562px;
}

#placesList .item .marker_14 {
   background-position: 0 -608px;
}

#placesList .item .marker_15 {
   background-position: 0 -654px;
}

#pagination {
   margin: 10px auto;
   text-align: center;
}

#pagination a {
   display: inline-block;
   margin-right: 10px;
}

#pagination .on {
   font-weight: bold;
   cursor: default;
   color: #777;
}

#map {
   width: 70%;
   height: 100%;
   position: relative;
   overflow: hidden;
}

.mapType {
   margin: 10px;
   margin-left: 260px;
   padding: 10px;
}

#chkUseDistrict {
   margin: 10px;
}

#chkRoadView {
   margin: 10px;
}

#chkTraffic {
   margin: 10px;
}

#chkBicycle {
   margin: 10px;
}
</style>
</head>
<body>
	<h5>🛣️오시는 길</h5>
	<h6>🗺️지도</h6>
   <div class="map_wrap">
      <div id="map"></div>
      <div id="menu_wrap" class="bg_white">
         <div class="option">
            <div>
               <form onsubmit="searchPlaces(); return false;">
                  키워드 : <input type="text" value="진주 서울IT학원" id="keyword" size="15">
                  <button type="submit">검색하기</button>
               </form>
            </div>
         </div>
         <hr>
         <ul id="placesList"></ul>
         <div id="pagination"></div>
      </div>
   </div>
   <div class="mapType">
      <input type="checkbox" id="chkUseDistrict"
         onclick="setOverlayMapTypeId()" /> 지적편집도 정보 보기 <input
         type="checkbox" id="chkRoadView" onclick="setOverlayMapTypeId()" />
      로드뷰 보기 <input type="checkbox" id="chkTraffic"
         onclick="setOverlayMapTypeId()" /> 교통정보 보기 <input type="checkbox"
         id="chkBicycle" onclick="setOverlayMapTypeId()" /> 자전거도로 정보 보기
   </div>
   <div>
   <h6>🚌대중교통</h6>
		   <div style="margin-left: 40px;"><img id="hrdEditorImg_2" alt="sub-icon.jpg-^|^-5e1ec920-8db8-4be4-8342-26ab9a70956c.jpg-^|^-11241" src="http://hrdmarket.co.kr/resources/file/hrd/hrd_institution_15020500002/894ba45c-fcb7-46a6-becc-05a21a2f46c5.jpg">&nbsp; <strong>시외버스</strong><br>
				<br>
				- 창원, 마산<br>
				창원시외버스터미널(30분간격 50분소요) - 진주시 가좌동 개양 오거리 하차<br>
				마산시외버스터미널(10분간격 50분소요) - 진주시 가좌동 개양 오거리 하차<br>
				<br>
				<a href="https://www.bustago.or.kr/" target="_blank"><span style="color: rgb(0, 0, 255);">- 기타 시외버스 시간표 보러가기&gt;&gt;</span></a><br>
				<br>
				<img id="hrdEditorImg_2" alt="sub-icon.jpg-^|^-894ba45c-fcb7-46a6-becc-05a21a2f46c5.jpg-^|^-11241" src="http://hrdmarket.co.kr/resources/file/hrd/hrd_institution_15020500002/894ba45c-fcb7-46a6-becc-05a21a2f46c5.jpg">&nbsp; <strong>시내버스</strong><br>
				<br>
				- 가좌주공아파트 : 110 , 121 , 128 , 130 , 132 , 133 , 134 , 135 , 136 , 141 , 145 , 150 , 151 , 160 , 170 , 283 , 380 , 381<br>
				<br>
				- 진주역환승정류장 : 111 , 120 , 121 , 122 , 123 , 124 , 126 , 127 , 128 , 129 , 130 , 131 , 132 , 133 , 134 , 135 , 136 , 140 ,<br>
				141 , 142 , 143 , 144 , 145 , 150 , 151 , 152 , 160 , 170 , 171 , 285 , 289 , 292 , 294<br>
				<br>
				- 정촌초등학교 : 111 , 120 , 122 , 123 , 124 , 126 , 127 , 129 , 144 , 171 , 283 , 285 , 289 , 292 , 294 , 380 , 381
			</div>            
		</div>
   <script>
      var Position = new kakao.maps.LatLng(35.159764, 128.106251);
      var container = document.getElementById('map');
      var options = {
         center : Position,
         level : 2
      };

      var map = new kakao.maps.Map(container, options);
      // 장소 검색 객체를 생성합니다
      var ps = new kakao.maps.services.Places();
      // 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
      var infowindow = new kakao.maps.InfoWindow({
         zIndex : 1
      });

      // 키워드로 장소를 검색합니다
      searchPlaces();

      // 키워드 검색을 요청하는 함수입니다
      function searchPlaces() {

         var keyword = document.getElementById('keyword').value;

         if (!keyword.replace(/^\s+|\s+$/g, '')) {
            alert('키워드를 입력해주세요!');
            return false;
         }

         // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
         ps.keywordSearch(keyword, placesSearchCB);
      }

      // 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
      function placesSearchCB(data, status, pagination) {
         if (status === kakao.maps.services.Status.OK) {

            // 정상적으로 검색이 완료됐으면
            // 검색 목록과 마커를 표출합니다
            displayPlaces(data);

            // 페이지 번호를 표출합니다
            displayPagination(pagination);

         } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

            alert('검색 결과가 존재하지 않습니다.');
            return;

         } else if (status === kakao.maps.services.Status.ERROR) {

            alert('검색 결과 중 오류가 발생했습니다.');
            return;

         }
      }
      var markers = [];
      var marker = new kakao.maps.Marker({
         // 지도 중심좌표에 마커를 생성합니다 
         position : map.getCenter()
      });
      // 지도에 클릭 이벤트를 등록합니다
      // 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다

      // 마커 클러스터러에 클릭이벤트를 등록합니다
      // 마커 클러스터러를 생성할 때 disableClickZoom을 true로 설정하지 않은 경우
      // 이벤트 헨들러로 cluster 객체가 넘어오지 않을 수도 있습니다

      kakao.maps.event.addListener(map, 'click', function(mouseEvent) {

         // 클릭한 위도, 경도 정보를 가져옵니다 
         var latlng = mouseEvent.latLng;

         // 지도에 마커를 표시합니다
         marker.setMap(map);
         // 마커 위치를 클릭한 위치로 옮깁니다
         marker.setPosition(latlng);

         /*          var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
          message += '경도는 ' + latlng.getLng() + ' 입니다'; */

         //alert(message);
         $.ajax({
            method : "GET",
            url : "https://dapi.kakao.com/v2/local/geo/coord2address.json",
            data : {
               x : latlng.getLng(),
               y : latlng.getLat()
            },
            headers : {
               Authorization : "KakaoAK 86c145ce50b8c26529240acf7f458e82"
            }
         }).done(function(msg) {
            alert("현재 위치는: " + msg.documents[0].address.address_name);
            console.log(msg.documents[0].address.address_name);

         });

      });
      var mapTypes = {
         RoadView : kakao.maps.MapTypeId.ROADVIEW,
         traffic : kakao.maps.MapTypeId.TRAFFIC,
         bicycle : kakao.maps.MapTypeId.BICYCLE,
         useDistrict : kakao.maps.MapTypeId.USE_DISTRICT
      };

      // 체크 박스를 선택하면 호출되는 함수입니다
      function setOverlayMapTypeId() {
         var RoadView = document.getElementById('chkRoadView'), chkTraffic = document
               .getElementById('chkTraffic'), chkBicycle = document
               .getElementById('chkBicycle'), chkUseDistrict = document
               .getElementById('chkUseDistrict');

         // 지도 타입을 제거합니다
         for ( var type in mapTypes) {
            map.removeOverlayMapTypeId(mapTypes[type]);
         }

         // 지적편집도정보 체크박스가 체크되어있으면 지도에 지적편집도정보 지도타입을 추가합니다
         if (chkUseDistrict.checked) {
            map.addOverlayMapTypeId(mapTypes.useDistrict);
         }

         // 지형정보 체크박스가 체크되어있으면 지도에 지형정보 지도타입을 추가합니다
         if (chkRoadView.checked) {
            map.addOverlayMapTypeId(mapTypes.RoadView);
         }

         // 교통정보 체크박스가 체크되어있으면 지도에 교통정보 지도타입을 추가합니다
         if (chkTraffic.checked) {
            map.addOverlayMapTypeId(mapTypes.traffic);
         }

         // 자전거도로정보 체크박스가 체크되어있으면 지도에 자전거도로정보 지도타입을 추가합니다
         if (chkBicycle.checked) {
            map.addOverlayMapTypeId(mapTypes.bicycle);
         }

      }
      // 검색 결과 목록과 마커를 표출하는 함수입니다
      function displayPlaces(places) {

         var listEl = document.getElementById('placesList'), menuEl = document
               .getElementById('menu_wrap'), fragment = document
               .createDocumentFragment(), bounds = new kakao.maps.LatLngBounds(), listStr = '';

         // 검색 결과 목록에 추가된 항목들을 제거합니다
         removeAllChildNods(listEl);

         // 지도에 표시되고 있는 마커를 제거합니다
         removeMarker();

         for (var i = 0; i < places.length; i++) {

            // 마커를 생성하고 지도에 표시합니다
            var placePosition = new kakao.maps.LatLng(places[i].y,
                  places[i].x), marker = addMarker(placePosition, i), itemEl = getListItem(
                  i, places[i]); // 검색 결과 항목 Element를 생성합니다

            // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
            // LatLngBounds 객체에 좌표를 추가합니다
            bounds.extend(placePosition);

            // 마커와 검색결과 항목에 mouseover 했을때
            // 해당 장소에 인포윈도우에 장소명을 표시합니다
            // mouseout 했을 때는 인포윈도우를 닫습니다
            (function(marker, title) {
               kakao.maps.event.addListener(marker, 'mouseover',
                     function() {
                        displayInfowindow(marker, title);
                     });

               kakao.maps.event.addListener(marker, 'mouseout',
                     function() {
                        infowindow.close();
                     });

               itemEl.onmouseover = function() {
                  displayInfowindow(marker, title);
               };

               itemEl.onmouseout = function() {
                  infowindow.close();
               };
            })(marker, places[i].place_name);

            fragment.appendChild(itemEl);
         }

         // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
         listEl.appendChild(fragment);
         menuEl.scrollTop = 0;

         // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
         map.setBounds(bounds);
      }

      // 검색결과 항목을 Element로 반환하는 함수입니다
      function getListItem(index, places) {

         var el = document.createElement('li'), itemStr = '<span class="markerbg marker_'
               + (index + 1)
               + '"></span>'
               + '<div class="info">'
               + '   <h5>' + places.place_name + '</h5>';

         if (places.road_address_name) {
            itemStr += '    <span>' + places.road_address_name + '</span>'
                  + '   <span class="jibun gray">' + places.address_name
                  + '</span>';
         } else {
            itemStr += '    <span>' + places.address_name + '</span>';
         }

         itemStr += '  <span class="tel">' + places.phone + '</span>'
               + '</div>';

         el.innerHTML = itemStr;
         el.className = 'item';

         return el;
      }

      // 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
      function addMarker(position, idx, title) {
         var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
         imageSize = new kakao.maps.Size(36, 37), // 마커 이미지의 크기
         imgOptions = {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx * 46) + 10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset : new kakao.maps.Point(13, 37)
         // 마커 좌표에 일치시킬 이미지 내에서의 좌표
         }, markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize,
               imgOptions), marker = new kakao.maps.Marker({
            position : position, // 마커의 위치
            image : markerImage
         });

         marker.setMap(map); // 지도 위에 마커를 표출합니다
         markers.push(marker); // 배열에 생성된 마커를 추가합니다

         return marker;
      }

      // 지도 위에 표시되고 있는 마커를 모두 제거합니다
      function removeMarker() {
         for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
         }
         markers = [];
      }

      // 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
      function displayPagination(pagination) {
         var paginationEl = document.getElementById('pagination'), fragment = document
               .createDocumentFragment(), i;

         // 기존에 추가된 페이지번호를 삭제합니다
         while (paginationEl.hasChildNodes()) {
            paginationEl.removeChild(paginationEl.lastChild);
         }

         for (i = 1; i <= pagination.last; i++) {
            var el = document.createElement('a');
            el.href = "#";
            el.innerHTML = i;

            if (i === pagination.current) {
               el.className = 'on';
            } else {
               el.onclick = (function(i) {
                  return function() {
                     pagination.gotoPage(i);
                  }
               })(i);
            }

            fragment.appendChild(el);
         }
         paginationEl.appendChild(fragment);
      }

      // 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
      // 인포윈도우에 장소명을 표시합니다
      function displayInfowindow(marker, title) {
         var content = '<div style="padding:5px;z-index:1;">' + title
               + '</div>';

         infowindow.setContent(content);
         infowindow.open(map, marker);
      }

      // 검색결과 목록의 자식 Element를 제거하는 함수입니다
      function removeAllChildNods(el) {
         while (el.hasChildNodes()) {
            el.removeChild(el.lastChild);
         }
      }
   </script>
</body>
</html>