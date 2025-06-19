package com.example.demo.vo;

import java.time.LocalTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class ChatPlanPlace {

	private Long id;
    private String start;
    private String end;
    private String moveDuration;
    private int dayIndex;

}