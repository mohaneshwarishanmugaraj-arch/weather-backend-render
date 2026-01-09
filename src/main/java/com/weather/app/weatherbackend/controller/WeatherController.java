package com.weather.app.weatherbackend.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class WeatherController {

    @Value("${weather.api.key}")
    private String apiKey;

    @Value("${weather.api.url}")
    private String apiUrl;

    @GetMapping("/api/weather")
    public Map<String, Object> getWeather(@RequestParam String city) {

        String url = apiUrl + "?q=" + city + "&appid=" + apiKey + "&units=metric";

        RestTemplate restTemplate = new RestTemplate();
        Map<String, Object> response = restTemplate.getForObject(url, Map.class);

        Map<String, Object> main = (Map<String, Object>) response.get("main");
        Map<String, Object> sys = (Map<String, Object>) response.get("sys");
        List<Map<String, Object>> weatherList =
                (List<Map<String, Object>>) response.get("weather");

        Map<String, Object> result = new HashMap<>();
        result.put("city", response.get("name"));
        result.put("country", sys.get("country"));
        result.put("temperature", main.get("temp"));
        result.put("description", weatherList.get(0).get("description"));

        return result;
    }
}
