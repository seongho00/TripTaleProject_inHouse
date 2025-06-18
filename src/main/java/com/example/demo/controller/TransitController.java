package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.TransitService;

@Controller
public class TransitController {

	private final TransitService transitService;

	public TransitController(TransitService transitService) {
		this.transitService = transitService;
	}

	@GetMapping("/api/transit/durations")
	@ResponseBody
	public List<Map<String, Object>> getDurations() {
		return transitService.calculateDurations();
	}

}
