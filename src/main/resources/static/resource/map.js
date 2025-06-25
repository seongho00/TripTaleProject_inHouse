window.onload = function() {
	kakao.maps.load(function() {
		const mapContainer = document.getElementById('map');
		const map = new kakao.maps.Map(mapContainer, {
			center: new kakao.maps.LatLng(35.8, 127.8),
			level: 12
		});

		map.setZoomable(false); // 휠 확대/축소 막기

		// ✅ 더블클릭 확대 방지 (DOM 레벨 차단)
		mapContainer.addEventListener('dblclick', function(e) {
			e.stopPropagation();
			e.preventDefault();
		}, true);

		let activeInfoOverlay = null;

		// 영역 색깔
		const colors = [
			'#f94144', '#f3722c', '#f8961e', '#f9c74f',
			'#90be6d', '#43aa8b', '#577590', '#277da1',
			'#4d908e', '#b5838d', '#6a4c93', '#f28482',
			'#84a59d', '#f6bd60', '#cdb4db', '#9a8c98', '#2a9d8f'
		];

		// 영역 라벨 이름
		const fallbackNames = [
			"서울특별시", "부산광역시", "대구광역시", "인천광역시", "광주광역시",
			"대전광역시", "울산광역시", "세종특별자치시", "경기도", "강원도",
			"충청북도", "충청남도", "전라북도", "전라남도", "경상북도",
			"경상남도", "제주특별자치도"
		];

		// 영역 라벨에 따른 이미지 url
		const imageUrls = [
			"http://tong.visitkorea.or.kr/cms/resource/29/2678629_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/15/1974215_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/43/1573743_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/03/2599103_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/48/3083348_image2_1.jpg",
			"http://tong.visitkorea.or.kr/cms/resource/68/3350768_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/81/2712581_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/70/3353970_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/08/2943208_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/55/3492855_image2_1.jpg",
			"http://tong.visitkorea.or.kr/cms/resource/71/3494971_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/62/2797962_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/40/3358040_image2_1.JPG", "http://tong.visitkorea.or.kr/cms/resource/92/2653892_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/52/1567752_image2_1.jpg",
			"http://tong.visitkorea.or.kr/cms/resource/53/3083353_image2_1.jpg", "http://tong.visitkorea.or.kr/cms/resource/93/1876193_image2_1.jpg"
		];

		fetch('/sd_cleaned.geojson.json')
			.then(res => res.json())
			.then(geojson => {
				geojson.features.forEach((feature, index) => {
					const name = feature.properties?.name || fallbackNames[index] || `미지정${index}`;
					const color = colors[index % colors.length];
					const coords = feature.geometry?.coordinates;
					const type = feature.geometry?.type;
					const imageUrl = feature.properties?.imageUrl || imageUrls[index] || `미지정${index}`;

					if (!coords || !Array.isArray(coords)) return;
					const polygons = extractPolygons(type, coords);
					if (!polygons.length) return;

					const polygon = createPolygon(map, polygons, color);
					const center = adjustCenter(polygons.flat(), name);
					const labelEl = createLabelElement(name);

					const labelOverlay = new kakao.maps.CustomOverlay({
						position: center,
						content: labelEl,
						xAnchor: 0.5,
						yAnchor: 0.5
					});
					labelOverlay.setMap(map);

					// 이벤트 핸들러
					const onMouseOver = () => polygon.setOptions({ fillColor: '#ffffff', fillOpacity: 1 });
					const onMouseOut = () => polygon.setOptions({ fillColor: color, fillOpacity: 1 });
					const onClick = () => showInfoOverlay(map, center, name, imageUrl);

					kakao.maps.event.addListener(polygon, 'mouseover', onMouseOver);
					kakao.maps.event.addListener(polygon, 'mouseout', onMouseOut);
					kakao.maps.event.addListener(polygon, 'click', onClick);

					labelEl.addEventListener('mouseover', onMouseOver);
					labelEl.addEventListener('mouseout', onMouseOut);
					labelEl.addEventListener('click', onClick);
				});
			})
			.catch(err => console.error("🚨 GeoJSON 로드 실패:", err));

		function extractPolygons(type, coords) {
			const polygons = [];
			const toLatLngs = ring => ring.map(c => new kakao.maps.LatLng(c[1], c[0]));
			if (type === "Polygon") {
				coords.forEach(ring => polygons.push(toLatLngs(ring)));
			} else if (type === "MultiPolygon") {
				coords.forEach(multi => multi.forEach(ring => polygons.push(toLatLngs(ring))));
			}
			return polygons;
		}

		function createPolygon(map, polygons, color) {
			return new kakao.maps.Polygon({
				map,
				path: polygons,
				strokeWeight: 2,
				strokeColor: '#333',
				strokeOpacity: 0.8,
				fillColor: color,
				fillOpacity: 1
			});
		}

		function adjustCenter(latlngs, name) {
			const avg = latlngs.reduce(
				(sum, latlng) => {
					sum.lat += latlng.getLat();
					sum.lng += latlng.getLng();
					return sum;
				}, { lat: 0, lng: 0 }
			);
			let lat = avg.lat / latlngs.length;
			let lng = avg.lng / latlngs.length;

			// 라벨 위치 조절
			const adjust = {
				"경기도": [-0.3, 0.1],
				"경상남도": [0.3, 0],
				"경상북도": [0.1, -0.2],
				"전라북도": [0, 0.2],
				"충청북도": [0, -0.2]
			};

			if (adjust[name]) {
				lat += adjust[name][0];
				lng += adjust[name][1];
			}

			return new kakao.maps.LatLng(lat, lng);
		}

		function createLabelElement(name) {
			const div = document.createElement('div');
			div.className = 'label bg-white border border-gray-600 px-2 py-1 rounded text-sm text-black';
			div.style.pointerEvents = 'auto';
			div.innerText = name;
			return div;
		}

		// 클릭 시 오버레이 표시 코드
		// 오버레이 html 코드
		function createInfoContent(name, imageUrl) {
			return `
		    <div class="relative w-48 h-[198px] flex flex-col items-center gap-1.5 p-2.5 bg-white border border-black shadow-md rounded">
		      <!-- 닫기 버튼 -->
		      <button class="absolute top-1 right-1 text-black text-lg font-bold close-btn">
		        <i class="fa-solid fa-xmark text-3xl cursor-pointer"></i>
		      </button>

		      <img src="${imageUrl}" class="w-[183px] h-[103px] object-cover" />
		      <p class="w-[111px] h-[30px] text-xl text-center text-black">${name}</p>
		      <div class="w-[95px] h-[27px] rounded-[10px] bg-[#18a0fb] cursor-pointer flex items-center justify-center select-btn">
		        <p class="text-xl text-white">선택</p>
		      </div>
		    </div>
		  `;
		}

		function showInfoOverlay(map, position, name, imageUrl) {
			if (activeInfoOverlay) activeInfoOverlay.setMap(null);

			const content = createInfoContent(name, imageUrl);

			// 오버레이 위치 조절
			activeInfoOverlay = new kakao.maps.CustomOverlay({
				position,
				content,
				xAnchor: 0.5,
				yAnchor: 1.08
			});

			activeInfoOverlay.setMap(map);

			// 버튼 이벤트 바인딩
			setTimeout(() => {
				const selectBtn = document.querySelector('.select-btn');
				const closeBtn = document.querySelector('.close-btn');

				if (selectBtn) {
					selectBtn.addEventListener('click', () => {
						$('#helpModal').removeClass('hidden').addClass('flex');

						$('#helpModalCloseBtn').on('click', function() {
							const tripName = $('#tripNameInput').val().trim();

							if (!tripName) {
								alert('여행 이름을 입력해주세요!');
								return;
							}
							const region = $('.select-btn').closest('.info-window').data('region'); // ← 필요 시 dataset에서 꺼내기
							location.replace(`../planner/calendar?region=${region}&tripName=${tripName}`);
						});
						
					});
				}

				if (closeBtn) {
					closeBtn.addEventListener('click', () => {
						if (activeInfoOverlay) {
							activeInfoOverlay.setMap(null);
							activeInfoOverlay = null;
						}
					});
				}
			}, 0);
		}
	});
};