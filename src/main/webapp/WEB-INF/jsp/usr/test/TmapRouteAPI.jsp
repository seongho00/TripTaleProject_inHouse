<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="관광사진" />
<%@ include file="../common/head.jspf"%>

<div id="map" style="width: 100%; height: 500px;"></div>

<script>
document.addEventListener('DOMContentLoaded', function () {
	  kakao.maps.load(function () {
	    const mapContainer = document.getElementById('map');
	    const map = new kakao.maps.Map(mapContainer, {
	      center: new kakao.maps.LatLng(37.5665, 126.9784),
	      level: 4
	    });

	    fetch("https://apis.openapi.sk.com/transit/routes", {
	      method: "POST",
	      headers: {
	        "Content-Type": "application/json",
	        "appKey": "JtTmUgD4yw9LrbRlREh2B8dYadiOogkRQNM0SdBj",
	      },
	      body: JSON.stringify({
	        startX: "126.9784", // 경도 (서울 시청)
	        startY: "37.5665",  // 위도
	        endX: "127.0276",   // 경도 (강남역)
	        endY: "37.4979",    // 위도
	        lang: 0,
	        count: 1,
	        format: "json"
	      })
	    })
	    .then(response => response.json())
	    .then(data => {
	    	
	      new kakao.maps.Marker({
	    	  position: startLatLng,
	    	  map: map,
	    	  title: "출발지"
	   	      });

	          new kakao.maps.Marker({
	          position: endLatLng,
	     	  map: map,
	      title: "도착지"
	   	  });
	      console.log(data);

	      const legs = data.metaData.plan.itineraries[0].legs;

	      legs.forEach(leg => {
	        let path = [];
	        let color = '#000000'; // 기본 색상

	        // 🚶 도보 구간
	        if (leg.mode === "WALK" && leg.steps) {
	          color = '#888888'; // 회색
	          leg.steps.forEach(step => {
	            if (step.linestring) {
	              step.linestring.split(" ").forEach(pair => {
	                const [lng, lat] = pair.split(",").map(Number);
	                path.push(new kakao.maps.LatLng(lat, lng));
	              });
	            }
	          });
	        }

	        // 🚌 버스 구간
	        else if (leg.mode === "BUS" && leg.passShape?.linestring) {
	          color = '#' + (leg.routeColor || '0068B7');
	          leg.passShape.linestring.split(" ").forEach(pair => {
	            const [lng, lat] = pair.split(",").map(Number);
	            path.push(new kakao.maps.LatLng(lat, lng));
	          });
	        }

	        // 🚇 지하철 구간
	        else if (leg.mode === "SUBWAY" && leg.passShape?.linestring) {
	          color = '#00B36B';
	          leg.passShape.linestring.split(" ").forEach(pair => {
	            const [lng, lat] = pair.split(",").map(Number);
	            path.push(new kakao.maps.LatLng(lat, lng));
	          });
	        }

	        // 지도에 경로 표시
	        if (path.length > 1) {
	          new kakao.maps.Polyline({
	            path: path,
	            strokeWeight: 5,
	            strokeColor: color,
	            strokeOpacity: 0.9,
	            strokeStyle: 'solid'
	          }).setMap(map);
	        }
	      });
	    });
	  });
	});
</script>
<%@ include file="../common/foot.jspf"%>