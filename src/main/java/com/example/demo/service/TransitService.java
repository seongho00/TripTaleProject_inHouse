package com.example.demo.service;

import java.time.Duration;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.util.CsvParser;
import com.example.demo.vo.StopTimeDto;

@Service
public class TransitService {
	
	private final CsvParser csvParser;

	public TransitService(CsvParser csvParser) {
		this.csvParser = csvParser;
	}

	public List<Map<String, Object>> calculateDurations() {
		List<StopTimeDto> stopTimes = csvParser.parseStopTimes("/gtfs/stop_times.txt");
		System.out.println("로드된 stopTimes 수: " + stopTimes.size());

		Map<String, List<StopTimeDto>> grouped = stopTimes.stream()
				.sorted(Comparator.comparingInt(StopTimeDto::getStopSequence))
				.collect(Collectors.groupingBy(StopTimeDto::getTripId));

		List<Map<String, Object>> durations = new ArrayList<>();

		for (String tripId : grouped.keySet()) {
			List<StopTimeDto> stops = grouped.get(tripId);
			if (stops.size() < 2)
				continue;

			for (int i = 1; i < stops.size(); i++) {
				StopTimeDto from = stops.get(i - 1);
				StopTimeDto to = stops.get(i);

				try {
					LocalTime fromTime = LocalTime.parse(from.getDepartureTime());
					LocalTime toTime = LocalTime.parse(to.getArrivalTime());

					long durationSeconds = Duration.between(fromTime, toTime).getSeconds();

					Map<String, Object> result = new HashMap<>();
					result.put("trip_id", tripId);
					result.put("from_stop_id", from.getStopId());
					result.put("to_stop_id", to.getStopId());
					result.put("duration_seconds", durationSeconds);
					durations.add(result);

				} catch (Exception e) {
					System.out.println("시간 파싱 에러: " + e.getMessage());
				}
			}
		}

		System.out.println("계산된 duration 수: " + durations.size());
		return durations;
	}
}
