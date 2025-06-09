<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="관광사진" />
<%@ include file="../common/head.jspf"%>



<script>
function sleep(ms) {
	  return new Promise(resolve => setTimeout(resolve, ms));
	}
	
function getAddressFromCoords(lat, lon, areaCode) {
    const url = "https://apis.openapi.sk.com/tmap/geo/reversegeocoding?version=1&lat="+ lat +"&lon="+ lon +"&coordType=WGS84GEO&addressType=A10";

    fetch(url, {
      headers: {
        "appKey": "JtTmUgD4yw9LrbRlREh2B8dYadiOogkRQNM0SdBj"
      }
    })
      .then(res => res.json())
      .then(data => {
        if (data.addressInfo) {
        	try{
            	const fullAddress = data.addressInfo.fullAddress; // 전체 주소 문자열
                const parts = fullAddress.split(","); // 공백 기준으로 분리
                const secondPart = parts[2]; // 두 번째 요소 (index는 0부터 시작)
               
              	console.log("주소:", secondPart);
                
              	$.ajax({
                     type: "GET",
                     url: "/usr/test/tripLocationService",
                     data: { keyword: secondPart, areaCode : areaCode },
                     success: function (response) {
                       	console.log("서버 응답:", response);
                     },
                     error: function (xhr, status, error) {
                    	
                     	console.error("서버 전송 실패:", error);
                     }
                   }); 
                
        	} catch (e){
        		console.error("주소 파싱 중 오류 발생:", e);
        	}
        } else {
          console.warn("주소 정보를 가져올 수 없습니다.");
        }
      })
      .catch(err => {
        console.error("API 호출 오류:", err);
      });
  }  
  
	const API_KEY = 'CtMWbR%2BmYCIwYQmPYdFuMiP4LsJ6aVV3CcbyZUXI5bGiblyS1OilOVAYopA9VxwIcRyQ7pT%2FADS7FzuMVs3uEw%3D%3D'; // Encoding된 키
	
	async function getAirData() {
		const areaCode = 3;
		const url = 'https://apis.data.go.kr/B551011/KorService2/areaBasedList2'
				+ '?serviceKey='
				+ API_KEY
				+ '&_type=json&pageNo=1&numOfRows=52&MobileOS=Test&MobileApp=AppTest'
				+ '&cat1=C01&contentTypeId=25&areaCode=' + areaCode;

		try {
			const response = await fetch(url);
			if (!response.ok) {
				throw new Error(`HTTP 오류! 상태 코드: ${response.status}`);
			}
			const data = await
			response.json();
			
			
			const datas = data.response.body.items.item;
			 
			 
			 
			getAddressFromCoords(36.3686302309, 127.3862701991, areaCode);
	 		/* for (const [index, item] of datas.entries()) {
				console.log(index + "번 째 데이터");
				console.log(item.mapy, item.mapx);
				
				await getAddressFromCoords(item.mapy, item.mapx, areaCode);
				await sleep(20000); // 20초 대기
			}   */

		} catch (e) {
			console.error("API 호출 실패:", e);
		}
	}
	getAirData();
</script>


<%@ include file="../common/foot.jspf"%>