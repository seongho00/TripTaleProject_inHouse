package com.example.demo.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Component;

import com.example.demo.vo.StopTimeDto;

@Component
public class CsvParser {
	public List<StopTimeDto> parseStopTimes(String path) {
		List<StopTimeDto> list = new ArrayList<>();

		try (BufferedReader br = new BufferedReader(new InputStreamReader(
				Objects.requireNonNull(getClass().getResourceAsStream(path)), StandardCharsets.UTF_8))) {

			String header = br.readLine(); // skip header
			String line;

			while ((line = br.readLine()) != null) {
				String[] parts = line.split(",");

				if (parts.length < 5)
					continue;

				try {
					String tripId = parts[0].replace("\"", "").trim();
					String arrivalTime = parts[1].replace("\"", "").trim();
					String departureTime = parts[2].replace("\"", "").trim();
					String stopId = parts[3].replace("\"", "").trim();
					int stopSequence = (int) Double.parseDouble(parts[4].replace("\"", "").trim());

					StopTimeDto dto = new StopTimeDto(tripId, stopId, arrivalTime, departureTime, stopSequence);
					list.add(dto);
				} catch (Exception e) {
					System.out.println("CSV 행 파싱 실패: " + line);
					// 계속 진행
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
}
