<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=5392fc444044e7f4ad1d8143ec4eb082&libraries=clusterer"></script>
</head>
<body>
    <div class="covid"  style="color: black">
        <h5>😷지역별 코로나 현황</h5>
        <h6 class="covid__today"></h6>
        <h6 class="covidConfirmedperson"></h6>
        <h6 class="covidDead"></h6>
        <h6 class="covidCure"></h6>
    </div>

    <div id="map" style="width:100%;height:70vh;"></div>
    <script>
        let date = new Date();
        let year = date.getFullYear();
        let month = new String(date.getMonth() + 1);
        let day = new String(date.getDate());
        // 한자리수일 경우 0을 채워준다.
        if (month.length == 1) {
            month = "0" + month;
        }
        if (day.length == 1) {
            day = "0" + day;
        }
        let startDate = year + "" + month + "" + day;
        let _startDate = year + "년 " + month + "월 " + day + "일";
        let endDate = year + "" + month + "" + day;
        let text = document.querySelector(".covid__today");
        text.innerText = "오늘: " + _startDate;

        const data = [
            [37.566418, 126.97795, '서울'], //서울시청
            [37.456445, 126.705873, '인천'],
            [37.275221, 127.009382, '경기'],
            [36.480838, 127.289181, '세종'], //세종시청
            [36.350664, 127.384819, '대전'], //대전시청
            [36.658826, 126.672849, '충남'], //충남도청
            [35.820599, 127.108759, '전북'], //전북도청
            [35.160068, 126.851426, '광주'], //광주광역시청
            [34.816351, 126.462924, '전남'], //전남도청
            [37.8853, 127.729835, '강원'], //강원(강원도청)
            [36.635947, 127.491345, '충북'], //충북도청
            [36.574108, 128.509303, '경북'], //경북도청
            [35.871468, 128.601757, '대구'], //대구시청
            [35.238398, 128.692371, '경남'], //경남도청
            [35.539772, 129.311486, '울산'], //울산시청
            [35.180152, 129.07498, '부산'], //부산시청
            [33.3617007, 126.511657, '제주'], //제주
        ]
        let covidConfirmedperson = document.querySelector(".covidConfirmedperson");
        let covidDead = document.querySelector(".covidDead");
        let covidCure = document.querySelector(".covidCure");
        let area = [];
        let markers = [];

        let xhr = new XMLHttpRequest();										//1. XMLHttpRequest()를 통해 Object 생성
        xhr.open('GET', '${pageContext.request.contextPath}/compinfo/openapi' +	//2. open함수로 메소드 방식, url, 비동기 여부 결정
            "?pageNo=" + '1'
            + "&numOfRows=" + '7'
            + "&startCreateDt=" + startDate
            + "&endCreateDt=" + endDate,
            true)
        xhr.setRequestHeader('Accept', 'application/json');	//Accept이 application/json 타입이면 data는 json 타입이어야 함
        xhr.send();															//3. send(data)로 설정한 방식대로 request 전송
        xhr.onreadystatechange = () =>{ 
            if (xhr.readyState == 4 && xhr.status == 200) { //request 후 해당 서버가 200이면
                let txt = xhr.responseText;  				//response 받은 text를
                txt = JSON.parse(txt);
                txt = JSON.parse(txt.gridRowJson);
                console.log(txt); 							//콘솔에 출력
                let covidData = txt.response.body.items.item;
                console.log(data.length);
                console.log('test');
                console.log(covidData);
                /*console.log(covidData[index].gubun, covidData[index].incDec);*/
                for (let index in covidData) {
                    console.log("test");
                    if (covidData[index].gubun == "검역") {
                        continue;
                    }
                    if (covidData[index].gubun == "합계") {
                        covidConfirmedperson.innerText = "코로나 확진자: " + covidData[index].defCnt;
                        covidDead.innerText = "코로나 사망자: " + covidData[index].deathCnt;
                        covidCure.innerText = "코로나 완치자:" + covidData[index].isolClearCnt;
                        continue;
                    }
                    area.push([covidData[index].gubun] +": " + covidData[index].incDec);
                }
                for (let i = 0; i < data.length; i++) {
                    // 지도에 마커를 생성하고 표시한다.
                    let marker = new kakao.maps.Marker({
                        position: new kakao.maps.LatLng(data[i][0], data[i][1]),
                        map: map // 마커를 표시할 지도 객체
                    });
                    console.log(data[i][2]);
                    for (let key of area) {
                        if (data[i][2] == key.substring(0,2)) {
                            data[i][2] = key;
                            continue;
                        }
                    }
                    let infowindow = new kakao.maps.InfoWindow({
                        content : "<div style='color: black; padding: 5px'>" + "추가 확진자" + "<br/>"+ data[i][2]  + "</div>"
                    });
                    kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
                    kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
                    markers.push(marker);
                }
                clusterer.addMarkers(markers);
            }
        }

    const map = new kakao.maps.Map(document.getElementById('map'), { // 지도를 표시할 div
        center : new kakao.maps.LatLng(36.2683, 127.6358), // 지도의 중심좌표
        level : 13 // 지도의 확대 레벨
    });

    // 마커 클러스터러를 생성합니다
    const clusterer = new kakao.maps.MarkerClusterer({
        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
        minLevel: 10 // 클러스터 할 최소 지도 레벨
    });

    // 인포윈도우를 표시하는 클로저를 만드는 함수입니다
    function makeOverListener(map, marker, infowindow) {
        return function() {
            infowindow.open(map, marker);
        };
    }

    // 인포윈도우를 닫는 클로저를 만드는 함수입니다
    function makeOutListener(infowindow) {
        return function() {
            infowindow.close();
        };
    }

    </script>
</body>
</html>